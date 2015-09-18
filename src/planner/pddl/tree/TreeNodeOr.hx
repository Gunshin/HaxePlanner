package planner.pddl.tree;
import planner.pddl.ActionData;
import planner.pddl.Domain;
import planner.pddl.State;

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
	
	override public function GenerateRangeOfValues(valueName_:String, state_:State, domain_:Domain):Array<String>
	{
		var returnee:Array<String> = new Array<String>();
		
		for (child in children)
		{
			if (Utilities.Compare(child.GetRawName(), "==") == 0)
			{
				var firstChildHasTargetValue:Bool = false;
				Tree.Recursive(function(node_)
				{
					if (Utilities.Compare(node_.GetRawName(), valueName_) == 0)
					{
						firstChildHasTargetValue = true;
						return false; // stop recursion
					}
					
					return true; //continue recursion
				}, child.children[0]);
				
				var nodeInt:TreeNodeInt = cast(child, TreeNodeInt);
				var indexToGetValue:Int = !firstChildHasTargetValue ? 0 : 1;
				var value:Int = nodeInt.GetValueFromChild(indexToGetValue, null, state_, domain_);
				
				returnee.push(Std.string(value));
			}
			else
			{
				returnee = returnee.concat(child.GenerateRangeOfValues(valueName_, state_, domain_));
			}
		}
		
		return returnee;
	}
	
	override public function Execute(data_:ActionData, state_:State, domain_:Domain):String
	{
		throw "cannot use an 'or' within an effect execution (makes no sense)";
	}
	
	override public function GetRawName():String
	{
		return "or";
	}
}