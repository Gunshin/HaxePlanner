package planner.pddl;

import de.polygonal.ds.Heap;
import haxe.ds.HashMap;
import planner.pddl.heuristic.Heuristic;
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
	var visited_states:Map<Int, PlannerNode> = new Map<Int, PlannerNode>();
	
	var domain:Domain = null;
	var problem:Problem = null;
	
	var heuristic:Heuristic = null;
	
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
	
	public function FindPlan(domain_:Domain, problem_:Problem, use_heuristic_:Bool):Array<PlannerActionNode>
	{
		domain = domain_;
		problem = problem_;
		
		if (use_heuristic_)
		{
			heuristic = new Heuristic(domain, problem);
		}
		
		hasMetric = problem.HasProperty("metric");
		
		var current_state:PlannerNode = new PlannerNode(problem_.GetClonedInitialState(), null, null, 0, new HeuristicResult(null, 0));
		
		var closest_heuristic:Null<Int> = null;
		
		var open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		var initial_greedy_result:GreedySearchResult = GreedySearch(current_state);
		
		trace("initial: " + initial_greedy_result.last_successively_lower_node.estimate.length);
		
		// check to see if an initial greedy search will return a plan
		if (!problem_.EvaluateGoal(initial_greedy_result.last_successively_lower_node.state))
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
				
				var breadth_result:BreadthSearchResult = BreadthSearch(open_list, closest_heuristic);
				
				open_list = breadth_result.open_list;
				closed_list = closed_list.concat(breadth_result.closed_list);
				
				if (breadth_result.found_better_node != null)
				{
					current_state = breadth_result.found_better_node;
					
					closest_heuristic = current_state.estimate.length;
				}
				
				
				
				
			}
			
		}
		
		
		/*var openList:Heap<PlannerNode> = new Heap<PlannerNode>();
		var closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		do
		{
			var successiveStates:Array<PlannerNode> = GetAllSuccessiveStates(currentState);
			
			#if debug_output
			if (iteration++ >= 1000)
			{
				iteration = 0;
				trace("closed_list_count: " + closed_list.length + " _ next node: " + openList.top().depth + " _ " + openList.top().estimate.length);
				Utilities.Log("closed_list_count: " + closed_list.length + " _ next node: " + openList.top().depth + " _ " + openList.top().estimate.length + "\n\n");
				Utilities.Log("estimate: \n");
				if (openList.top().estimate.ordered_list != null)
				{
					for (action in openList.top().estimate.ordered_list)
					{
						Utilities.Log(action.GetActionTransform() + "\n");
					}
				}
				Utilities.Log(openList.top().state + "\n");
				Utilities.Log("previous actions: \n");
				var backtrack:Array<PlannerActionNode> = BacktrackPlan(openList.top());
				for (action in backtrack)
				{
					Utilities.Log(action.GetActionTransform() + "\n");
				}
			}
			#end
			
			for (i in successiveStates)
			{
				openList.add(i);
			}
			closed_list.push(currentState);
			currentState = GetNextState(openList);
			
			trace("iter: current_state: " + currentState.depth + " _ " + currentState.estimate.length + " _____ " + problem_.EvaluateGoal(currentState.state) + "\n" + currentState);
		}
		while (currentState != null && !problem_.EvaluateGoal(currentState.state));
		
		closed_list_length = closed_list.length;
		open_list_length = openList.size();*/
		
		return BacktrackPlan(current_state);
	}
	
	function BreadthSearch(open_list_:Heap<PlannerNode>, current_best_heuristic:Int):BreadthSearchResult
	{
		// PERFORMANCE
		// lets not make the misake of not keeping immutable
		var copied:Heap<PlannerNode> = cast open_list_.clone(true);
		
		var new_open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var new_closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		while(copied.size() > 0)
		{
			var breadth_node:PlannerNode = copied.pop();
			
			var greedy_result:GreedySearchResult = GreedySearch(breadth_node);
			
			ConcatenateHeaps(new_open_list, greedy_result.open_list);
			new_closed_list = new_closed_list.concat(greedy_result.closed_list);
			
			if (greedy_result.last_successively_lower_node.estimate.length < current_best_heuristic)
			{
				// add the stuff still in the open list to the new list
				ConcatenateHeaps(new_open_list, copied);
				
				return new BreadthSearchResult(greedy_result.last_successively_lower_node, new_open_list, new_closed_list);
			}
			
		}
		
		return new BreadthSearchResult(null, new_open_list, new_closed_list);
		
	}
	
	function GreedySearch(start_state_:PlannerNode):GreedySearchResult
	{
		
		var open_list:Heap<PlannerNode> = new Heap<PlannerNode>();
		var closed_list:Array<PlannerNode> = new Array<PlannerNode>();
		
		var previous_state:PlannerNode = null;
		var current_state:PlannerNode = start_state_;
		
		var result:GreedySearchResult = null;
		
		do
		{
			var successive_states:Array<PlannerNode> = GetAllSuccessiveStates(current_state);
			
			for (i in successive_states)
			{
				open_list.add(i);
			}
			closed_list.push(current_state);
			previous_state = current_state;
			current_state = GetNextState(open_list);
			
			if (current_state == null)
			{
				return null;
			}
			
			// if the current state, eg. the next best heuristic
			if (current_state.estimate.length >= previous_state.estimate.length)
			{
				trace("est: " + current_state.estimate.length);
				return new GreedySearchResult(previous_state, open_list, closed_list);
			}
			
		}
		while (!problem.EvaluateGoal(current_state.state));
		// we dropped out of the loop because the goal evaluated correctly
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
	
	function GetAllSuccessiveStates(parent_state_:PlannerNode):Array<PlannerNode>
	{
		var states:Array<PlannerNode> = new Array<PlannerNode>();
		
		var actions:Array<PlannerActionNode> = GetAllActionsForState(parent_state_.state, domain);
		for (actionNode in actions)
		{
			
			actionNode.Set();
			var newState:State = actionNode.action.Execute(parent_state_.state, domain);
			
			var hash:Int = newState.GenerateStateHash();
			
			if (!visited_states.exists(hash))
			{
				var last_heuristic:HeuristicResult = new HeuristicResult(null, 0);
				if (heuristic != null)
				{
					last_heuristic = heuristic.RunHeuristic(newState);
				}
				
				var plannerNode:PlannerNode = new PlannerNode(newState, parent_state_, actionNode, parent_state_.depth + 1, last_heuristic);
				
				if (hasMetric)
				{
					plannerNode.SetMetric(problem.EvaluateMetric(plannerNode.state));
				}
				
				visited_states.set(hash, plannerNode);
				states.push(plannerNode);
				
			}
			
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
	
	static function GenerateCombinations(value_ranges_:Array<Array<Pair<String, String>>>):Array<Array<Pair<String, String>>>
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