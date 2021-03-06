package planner.pddl.tree;
import planner.pddl.ActionData;
import planner.pddl.Domain;
import planner.pddl.heuristic.HeuristicData;
import planner.pddl.Pair;
import planner.pddl.State;
import planner.pddl.StateHeuristic;

/**
 * ...
 * @author Michael Stephens
 */
class TreeNodeOr extends TreeNode
{

	public function new() 
	{
		super();
	}
	
	override public function Evaluate(data_:ActionData, state_:State, domain_:Domain):Bool
	{
		for (i in children)
		{
			if (i.Evaluate(data_, state_, domain_))
			{
				return true;
			}
		}
		return false;
	}
	
	override public function Execute(data_:ActionData, state_:State, domain_:Domain):String
	{
		throw "cannot use an 'or' within an effect execution (makes no sense)";
	}
	
	override public function HeuristicEvaluate(data_:ActionData, heuristic_data_:HeuristicData, state_:StateHeuristic, domain_:Domain):Bool 
	{
		for (i in children)
		{
			if (i.HeuristicEvaluate(data_, heuristic_data_, state_, domain_))
			{
				return true;
			}
		}
		return false;
	}
	
	override public function HeuristicExecute(data_:ActionData, heuristic_data_:HeuristicData, state_:StateHeuristic, domain_:Domain):String 
	{
		throw "cannot use an 'or' within an effect execution (makes no sense)";
	}
	
	override public function GenerateRangeOfValues(data_:ActionData, valueName_:String, state_:State, domain_:Domain, heuristic_version_:Bool):Array<String>
	{
		var returnee:Array<String> = new Array<String>();
		
		for (child in children)
		{
			if (Utilities.Compare(child.GetRawName(), "==") == 0)
			{
				var value_count:Int = 0;
				Tree.Recursive(child, function(node_)
				{
					if (Utilities.Compare(node_.GetRawName().charAt(0), "~") == 0)
					{
						value_count++;
					}
					return true; //search through the hole structure
				});
				
				if (value_count == 1)
				{
					var firstChildHasTargetValue:Bool = false;
					Tree.Recursive(child.children[0], function(node_)
					{
						if (Utilities.Compare(node_.GetRawName(), valueName_) == 0)
						{
							firstChildHasTargetValue = true;
							return false; // stop recursion
						}
						
						return true; //continue recursion
					});
					
					var nodeInt:TreeNodeInt = cast(child, TreeNodeInt);
					var indexToGetValue:Int = !firstChildHasTargetValue ? 0 : 1;
					var value:Pair<Int, Int> = heuristic_version_ ? 
									nodeInt.HeuristicGetValueFromChild(indexToGetValue, data_, null, cast(state_, StateHeuristic), domain_) :
									new Pair(nodeInt.GetValueFromChild(indexToGetValue, data_, state_, domain_), nodeInt.GetValueFromChild(indexToGetValue, data_, state_, domain_));
					
					for (inte in value.a ... value.b + 1)
					{
						returnee.push(Std.string(inte));
					}
					
				}
			}
			else
			{
				returnee = returnee.concat(child.GenerateRangeOfValues(data_, valueName_, state_, domain_, heuristic_version_));
			}
		}
		
		return returnee;
	}
	
	override public function GenerateConcrete(action_data_:ActionData, state_:State, domain_:Domain):Array<TreeNode>
	{
		var concrete_or:TreeNodeOr = new TreeNodeOr();
		
		for (child in children)
		{
			for (conc in child.GenerateConcrete(action_data_, state_, domain_))
			{
				concrete_or.AddChild(conc);
			}
		}
		
		return [concrete_or];
	}
	
	
	override public function GetRawName():String
	{
		return "or";
	}
	
	override public function Clone():TreeNode 
	{
		var clone:TreeNodeOr = new TreeNodeOr();
		
		for (child in children)
		{
			clone.AddChild(child.Clone());
		}
		
		return clone;
	}
}