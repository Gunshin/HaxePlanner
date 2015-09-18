package planner.pddl.tree;
import planner.pddl.ActionData;
import planner.pddl.Domain;
import planner.pddl.State;
import planner.pddl.tree.TreeNode;

/**
 * ...
 * @author 
 */
class TreeNodeParameter extends TreeNode
{
	
	var paramName:String = null;
	
	public function new(paramName_:String) 
	{
		super();
		
		paramName = paramName_;
	}
	
	override public function Evaluate(data_:ActionData, state_:State, domain_:Domain):Bool
	{
		throw "This function should not be getting called.";
	}
	
	override public function Execute(data_:ActionData, state_:State, domain_:Domain):String
	{
		return Std.string(state_.GetFunction(data_.GetParameterMap().get(paramName).GetValue()));
	}
	
	override public function GetRawName():String
	{
		return paramName;
	}
	
	override public function GetRawTreeString():String
	{
		return paramName;
	}
}