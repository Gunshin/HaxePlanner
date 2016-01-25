package planner.pddl;

import de.polygonal.ds.Heap;
import haxe.ds.HashMap;
import planner.pddl.heuristic.IHeuristic;
import planner.pddl.heuristic.HeuristicResult;
import planner.pddl.Action;
import planner.pddl.Domain;
import planner.pddl.Pair;
import planner.pddl.planner.BreadthSearchResult;
import planner.pddl.planner.GreedySearchResult;
import planner.pddl.planner.PlannerNode;
import planner.pddl.planner.PlannerActionNode;
/**
 * ...
 * @author Michael Stephens
 */
class Planner
{	
	var domain:Domain = null;
	var problem:Problem = null;
	
	var heuristic:IHeuristic = null;
	
	var hasMetric:Bool = false;
	
	
	var closed_list_length:Int = 0;
	var open_list_length:Int = 0;
	
	
	public function new() 
	{
		
	}
	
	
	/*
	 * 
	 * 
	 * greedy search from start node
	 * if dead end reached
	 * 		take current open list, expand best node first, adding successives into fresh list
	 * 		if new node has 'better' expansion than the lowest we have seen
	 * 			append list to the new list, and start from beginning?
	 * 		
	 * 
	 * 
	 */
	
	
	#if debug_output
	var iteration:Int = 0;
	#end
	
	public function FindPlan(domain_:Domain, problem_:Problem, heuristic_:IHeuristic):Array<PlannerActionNode>
	{
		domain = domain_;
		problem = problem_;
		
		var initial_state:State = problem_.GetClonedInitialState();
		var initial_heuristic:HeuristicResult = new HeuristicResult(null, 0);
		
		if (heuristic_ != null)
		{
			heuristic = heuristic_;
			
			initial_heuristic = heuristic.RunHeuristic(initial_state);
		}
		
		/*for (i in initial_heuristic.ordered_list)
		{
			Utilities.Logln(i.GetActionTransform());
		}*/
		
		#if debugging_heuristic
		throw "heuristic debug info thrown into standard output file";
		#end
		
		hasMetric = problem.HasProperty("metric");
		
		var current_state:PlannerNode = new PlannerNode(initial_state, null, null, 0, initial_heuristic);
		
		var closest_heuristic:Null<Int> = null;
		
		var open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		var initial_greedy_result:GreedySearchResult = GreedySearch(current_state, new Map<Int, PlannerNode>());
		current_state = initial_greedy_result.last_successively_lower_node;
		
		var temp:Array<PlannerActionNode> = BacktrackPlan(initial_greedy_result.last_successively_lower_node);
		
		/*trace("Running");
		
		Utilities.Logln("length: " + temp.length);
		for (i in temp)
		{
			Utilities.Logln(i.GetActionTransform());
		}
		
		throw "";*/
		
		// check to see if an initial greedy search will return a plan
		if (!problem_.EvaluateGoal(current_state.state))
		{
			// since it did not find a plan, lets take the open list generated by the greedy search, and perform
			// an breadth first over it (essentially just iterate and generate a new list each time composed of the new open nodes)
			// until we find a better path (ends with a state that is closer heuristically than our current state)
			
			closest_heuristic = initial_greedy_result.last_successively_lower_node.estimate.length;
			
			// need to initialise the open list with what is left from the greedy search (reuse everything!)
			// i would just set the reference, but i have been having a few issues with mutable objects T_T so shallow clone
			open_list = cast initial_greedy_result.open_list.clone(true);
			
			while (!problem_.EvaluateGoal(current_state.state) && open_list.size() > 0)
			{
				//trace("breadth search at estimate: " + current_state.estimate.length);
				var breadth_result:BreadthSearchResult = BreadthSearch(current_state);
				//trace("breadth open list length: " + breadth_result.open_list.size());
				//open_list = breadth_result.open_list;
				closed_list = closed_list.concat(breadth_result.closed_list);
				
				if (breadth_result.found_better_node != null)
				{
					current_state = breadth_result.found_better_node;
					
					closest_heuristic = current_state.estimate.length;
				}
				else
				{
					current_state = open_list.pop();
				}
				
				
				
			}
			
		}
		
		//trace("open_list: " + problem_.EvaluateGoal(current_state.state));
		
		return BacktrackPlan(current_state);
	}
	
	static var MAX_BREADTH_ITERATIONS:Int = 7;
	
	function BreadthSearch(node_:PlannerNode):BreadthSearchResult
	{
		//Utilities.Logln("running breadth on: " + node_.plannerActionNode.GetActionTransform() + " with current estimate: " + node_.estimate.length);
		
		var open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var secondary_open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		var visited_states:Map<Int, PlannerNode> = new Map<Int, PlannerNode>();
		
		secondary_open_list.add(node_);
		
		for (iteration in 0...MAX_BREADTH_ITERATIONS)
		{
			//Utilities.Logln("ITERATION " + iteration + " ---------------------------------");
			open_list = secondary_open_list;
			secondary_open_list = new Heap<PlannerNode>();
			
			//trace("iteration: " + iteration + " State count: " + open_list.size());
			
			while(open_list.size() > 0)
			{
				var breadth_node:PlannerNode = open_list.pop();
				
				// get all of the states for the next iteration. pointless doing this on the last iteration
				var succ_states:Array<PlannerNode> = GetAllSuccessiveStates(breadth_node, visited_states);
				
				for (succ_node in succ_states)
				{
					secondary_open_list.add(succ_node);
				}
				
				var greedy_result:GreedySearchResult = GreedySearch(breadth_node, visited_states);
				
				//Utilities.Logln("action: " + breadth_node.plannerActionNode.GetActionTransform() + " had result: " + greedy_result.last_successively_lower_node.estimate.length);
				
				//ConcatenateHeaps(new_open_list, greedy_result.open_list);
				closed_list = closed_list.concat(greedy_result.closed_list);
				
				if (greedy_result.last_successively_lower_node != null && greedy_result.last_successively_lower_node.estimate.length < node_.estimate.length)
				{
					// add the stuff still in the open list to the new list
					ConcatenateHeaps(open_list, secondary_open_list);
					//Utilities.Logln("node_ estimate: " + node_.estimate.length + " result estimate: " + greedy_result.last_successively_lower_node.estimate.length);
					return new BreadthSearchResult(greedy_result.last_successively_lower_node, open_list, closed_list);
				}
				
			}
		}
		return new BreadthSearchResult(null, open_list, closed_list);
		
	}
	
	function GreedySearch(start_state_:PlannerNode, visited_states_:Map<Int, PlannerNode>):GreedySearchResult
	{
		var temp_visited:Map<Int, PlannerNode> = new Map<Int, PlannerNode>();
		
		#if debugging
		Utilities.Logln("STARTING GREEDY SEARCH ----------------------");
		Utilities.Logln("Start node: " + start_state_.state);
		
		if (start_state_.plannerActionNode != null)
		{
			Utilities.Logln("Start action: " + start_state_.plannerActionNode.GetActionTransform());
		}
		#end
		
		var open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		var previous_state:PlannerNode = null;
		var current_state:PlannerNode = start_state_;
		
		var result:GreedySearchResult = null;
		
		
		do
		{
			var successive_states:Array<PlannerNode> = GetAllNonVisitedSuccessiveStates(current_state, temp_visited);
			//var successive_states:Array<PlannerNode> = GetAllSuccessiveStates(current_state, visited_states_);
			#if debugging
			Utilities.Logln("Successive states: ");
			#end
			for (i in successive_states)
			{
				open_list.add(i);
				#if debugging
				Utilities.Logln(i.plannerActionNode.GetActionTransform());
				#end
			}
			closed_list.push(current_state);
			
			// GetAllSuccessiveStates may return no states if those states have already been visited
			if (open_list.size() == 0)
			{
				#if debugging
				Utilities.Logln("\n\nGreedy Search exited due to empty open list\n\n\n\n\n");
				#end
				return new GreedySearchResult(null, open_list, closed_list);
			}
			
			previous_state = current_state;
			current_state = GetNextState(open_list);
			#if debugging
			Utilities.Logln("\n\nNew current_state: " + current_state.plannerActionNode.GetActionTransform());
			Utilities.Logln("state: " + current_state.state);
			#end
			// if the current state, eg. the next best heuristic
			if (current_state.estimate.length >= previous_state.estimate.length)
			{
				#if debugging
				Utilities.Logln("\n\nGreedy Search exited due to no better estimate: current_state: " + current_state.estimate.length + " previous_state: " + previous_state.estimate.length);
				Utilities.Logln("previous_state: " + previous_state.plannerActionNode.GetActionTransform() + "\n\n\n\n\n");
				#end
				return new GreedySearchResult(previous_state, open_list, closed_list);
			}
			
		}
		while (!problem.EvaluateGoal(current_state.state));
		// we dropped out of the loop because the goal evaluated correctly, maybe
		#if debugging
		Utilities.Logln("\n\nExited Greedy Search because goal has been satisfied");
		Utilities.Logln("Satisfied action: " + current_state.plannerActionNode.GetActionTransform());
		Utilities.Logln("Satisfied state: " + current_state.state + "\n\n\n\n\n");
		#end
		return new GreedySearchResult(current_state, open_list, closed_list);
	}
	
	function BacktrackPlan(plannerNode_:PlannerNode):Array<PlannerActionNode>
	{
		var backwardsActionSet:Array<PlannerActionNode> = new Array<PlannerActionNode>();
		
		var currentNode:PlannerNode = plannerNode_;
		while (currentNode.plannerActionNode != null)
		{
			backwardsActionSet.push(currentNode.plannerActionNode);
			
			currentNode = currentNode.parent;
		}
		backwardsActionSet.reverse();
		return backwardsActionSet;
		
	}
	
	static function GetNextState(openList_:Heap<PlannerNode>):PlannerNode
	{
		return openList_.pop();
	}
	
	/**
	 * 
	 * 
	 * 
	 * @param	parent_state_
	 * @return A set of successive states without filtering on whether the states have been visited before.
	 */
	function GetAllSuccessiveStates(parent_state_:PlannerNode, visited_states_:Map<Int, PlannerNode>):Array<PlannerNode>
	{
		var successive_states:Array<Pair<PlannerActionNode, State>> = GetAllRawSuccessiveStates(parent_state_);
		
		var final_nodes:Array<PlannerNode> = new Array<PlannerNode>();
		
		for (action_state_pair in successive_states)
		{
			var plannerNode:PlannerNode = null;
			
			var hash:Int = action_state_pair.b.GenerateStateHash();
			if (!visited_states_.exists(hash))
			{
				var last_heuristic:HeuristicResult = new HeuristicResult(null, 0);
				if (heuristic != null)
				{
					last_heuristic = heuristic.RunHeuristic(action_state_pair.b);
				}
				
				plannerNode = new PlannerNode(action_state_pair.b, parent_state_, action_state_pair.a, parent_state_.depth + 1, last_heuristic);
				
				if (hasMetric)
				{
					plannerNode.SetMetric(problem.EvaluateMetric(plannerNode.state));
				}
			}
			else
			{
				#if debugging
				
				if (!visited_states_.get(hash).state.Equals(action_state_pair.b))
				{
					Utilities.Log("Same hash: State A: " + visited_states_.get(hash).state + "\n");
					Utilities.Log("Same hash: State B: " + action_state_pair.b + "\n");
					throw "ERROR: A state has been found with the same hash value as a DIFFERENT state. States dumped into output log.";
				}
				
				#end
				
				plannerNode = visited_states_.get(hash);
			}
			
			final_nodes.push(plannerNode);
		}
		
		return final_nodes;
	}
	
	/**
	 * 
	 * @param	parent_state_
	 * @return A set of states that HAVE been filtered based on whether the state was visited before.
	 */
	function GetAllNonVisitedSuccessiveStates(parent_state_:PlannerNode, visited_states_:Map<Int, PlannerNode>):Array<PlannerNode>
	{
		var successive_states:Array<Pair<PlannerActionNode, State>> = GetAllRawSuccessiveStates(parent_state_);
		
		var non_visited:Array<PlannerNode> = new Array<PlannerNode>();
		
		for (action_state_pair in successive_states)
		{
			var hash:Int = action_state_pair.b.GenerateStateHash();
			//trace("hash: " + actionNode.action.GetName() + " :: exists? " + visited_states.exists(hash));
			if (!visited_states_.exists(hash))
			{
				var last_heuristic:HeuristicResult = new HeuristicResult(null, 0);
				if (heuristic != null)
				{
					last_heuristic = heuristic.RunHeuristic(action_state_pair.b);
				}
				
				var plannerNode:PlannerNode = new PlannerNode(action_state_pair.b, parent_state_, action_state_pair.a, parent_state_.depth + 1, last_heuristic);
				
				if (hasMetric)
				{
					plannerNode.SetMetric(problem.EvaluateMetric(plannerNode.state));
				}
				
				visited_states_.set(hash, plannerNode);
				non_visited.push(plannerNode);
			}
			#if debugging
			else
			{
				if (!visited_states_.get(hash).state.Equals(action_state_pair.b))
				{
					Utilities.Log("Same hash: State A: " + visited_states_.get(hash).state + "\n");
					Utilities.Log("Same hash: State B: " + action_state_pair.b + "\n");
					throw "ERROR: A state has been found with the same hash value as a DIFFERENT state. States dumped into output log.";
				}
			}
			#end
		}
		#if debugging
		Utilities.Logln("GetAllNonVisitedSuccessiveStates: raw state count: " + successive_states.length + " return count: " + non_visited.length);
		Utilities.Logln("raw actions::");
		for (i in successive_states)
		{
			Utilities.Logln(i.a.GetActionTransform());
		}
		Utilities.Logln("return actions::");
		for (i in non_visited)
		{
			Utilities.Logln(i.plannerActionNode.GetActionTransform());
		}
		#end
		return non_visited;
	}
	
	function GetAllRawSuccessiveStates(parent_state_:PlannerNode):Array<Pair<PlannerActionNode, State>>
	{
		var states:Array<Pair<PlannerActionNode, State>> = new Array<Pair<PlannerActionNode, State>>();
		
		var actions:Array<PlannerActionNode> = GetAllActionsForState(parent_state_.state, domain);
		for (actionNode in actions)
		{
			actionNode.Set();
			states.push(new Pair<PlannerActionNode, State>(actionNode, actionNode.action.Execute(parent_state_.state, domain)));
		}
		
		return states;
	}
	
	
	static public function GetAllActionsForState(state_:State, domain_:Domain):Array<PlannerActionNode>
	{
		var actions:Array<PlannerActionNode> = new Array<PlannerActionNode>();
		
		for (actionName in domain_.GetAllActionNames())
		{
			var action:Action = domain_.GetAction(actionName);
			
			var parameter_combinations:Array<Array<Pair<String, String>>> = GetAllPossibleParameterCombinations(action, state_, domain_);
			
			// has an extra array since these combinations are used per parameter combination
			var value_combinations:Array<Array<Array<Pair<String, String>>>> = GetAllPossibleValueCombinations(action, parameter_combinations, state_, domain_, false);
			
			for (param_index in 0...parameter_combinations.length)
			{
				var param_combination:Array<Pair<String, String>> = parameter_combinations[param_index];
				action.GetData().SetParameters(param_combination);
				if (value_combinations[param_index].length > 0)
				{
					for (val_combination in value_combinations[param_index])
					{
						action.GetData().SetValues(val_combination);
						
						if (action.Evaluate(state_, domain_))
						{
							actions.push(new PlannerActionNode(action, param_combination, val_combination));
						}
					}
				}
				else
				{
					if (action.Evaluate(state_, domain_))
					{
						actions.push(new PlannerActionNode(action, param_combination, null));
					}
				}
			}
			
		}
		
		return actions;
	}
	
	static public function GetAllPossibleParameterCombinations(action_:Action, initial_state_:State, domain_:Domain):Array<Array<Pair<String, String>>>
	{
		/*
		 * Array<Array<Pair<String, String>>> Is essentialy an array of tuples, with each element of the tuple being a pair
		 * which contains the name and value associated with that name. The name is required so that the action knows which parameter needs the value.
		 */	
		var combinations:Array<Array<Pair<String, String>>> = null;
		
		var raw_values:Array<Array<Pair<String, String>>> = new Array<Array<Pair<String, String>>>();
		
		// first lets populate the raw_values array with everything we need
		
		var actionParams:Array<Parameter> = action_.GetData().GetParameters();
		for (paramIndex in 0...actionParams.length)
		{
			// lets record the fact that the first so many raw values are of the param type			
			var obj_array:Array<Pair<String, String>> = new Array<Pair<String, String>>();
			for (obj in initial_state_.GetObjectsOfType(actionParams[paramIndex].GetType()))
			{
				obj_array.push(new Pair(actionParams[paramIndex].GetName(), obj));
			}
			
			raw_values.push(obj_array);
		}
		// since we have now finished populating the array, lets generate the sets correctly
		
		combinations = GenerateCombinations(raw_values);
		return combinations;
	}
	
	static public function GetAllPossibleValueCombinations(action_:Action, parameter_combinations_:Array<Array<Pair<String, String>>>, state_:State, domain_:Domain, heuristic_version_:Bool):Array<Array<Array<Pair<String, String>>>>
	{
		//Utilities.Log("Planner.GetAllPossibleValueCombinations: " + action_+"\n");
		var returnee:Array<Array<Array<Pair<String, String>>>> = new Array<Array<Array<Pair<String, String>>>>();
		
		for (combination in parameter_combinations_)
		{
			action_.GetData().SetParameters(combination);
			
			var value_ranges:Array<Array<Pair<String, String>>> = new Array<Array<Pair<String, String>>>();
			
			var actionValues:Array<Value> = action_.GetData().GetValues();
			if (actionValues.length > 0)
			{
				for (valueIndex in 0...actionValues.length)
				{
					var obj_array:Array<Pair<String, String>> = new Array<Pair<String, String>>();
					for (obj in actionValues[valueIndex].GetPossibleValues(action_.GetData(), state_, domain_, heuristic_version_))
					{
						obj_array.push(new Pair(actionValues[valueIndex].GetName(), obj));
					}
					value_ranges.push(obj_array);
				}
				
				returnee.push(GenerateCombinations(value_ranges));
			}
			else
			{
				returnee.push(new Array<Array<Pair<String, String>>>()); // just push an empty array, since we want this to succeed
			}
		}
		return returnee;
	}
	
	static public function GenerateCombinations(value_ranges_:Array<Array<Pair<String, String>>>):Array<Array<Pair<String, String>>>
	{
		var returnee:Array<Array<Pair<String, String>>> = new Array<Array<Pair<String, String>>>();
		
		var values_index:Array<Int> = new Array<Int>();
		for (value in value_ranges_) // set values_index to start indexs
		{
			values_index.push(0);
		}
		
		// this condition checks the last element in the index array to the last element in the raw values array
		// we do this because we are counting up in a left to right manner eg.
		// 000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 010, 110, 210, 310, etc. etc.
		// if the last digit is equal to the end of the last elements length, we know that we have finished brute forcing the combinations.
		while (values_index[value_ranges_.length - 1] != value_ranges_[value_ranges_.length - 1].length)
		{
			// add the current index values to the set and store it
			var values_set:Array<Pair<String, String>> = new Array<Pair<String, String>>();
			for (i in 0...value_ranges_.length)
			{
				values_set.push(value_ranges_[i][values_index[i]]);
			}
			
			returnee.push(values_set);
			
			for (i in 0...values_index.length)
			{
				values_index[i]++;
				if (values_index[i] != value_ranges_[i].length) // if this value has not hit the limit, do not increase any futher values
				{
					break;
				}
				
				// since it passed the above, it did hit the limit, so reset to 0
				if (i != values_index.length - 1) // we also need to make sure we dont reset the most significant. if we do, we enter a forever loop
				{
					values_index[i] = 0;
				}
			}
			
		}
		
		return returnee;
	}
	
	public function GetClosedListLength():Int
	{
		return closed_list_length;
	}
	
	public function GetOpenListLength():Int
	{
		return open_list_length;
	}
	
	static function ConcatenateHeaps(heap_a_:Heap<PlannerNode>, heap_b_:Heap<PlannerNode>)
	{
		//var returnee:Heap<T> = heap_a.clone(true);
		
		for (i in 0...heap_b_.size())
		{
			heap_a_.add(heap_b_.pop());
		}
	}
	
}