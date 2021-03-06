package planner.pddl.tree;
import planner.pddl.ActionData;
import planner.pddl.Domain;
import planner.pddl.heuristic.HeuristicData;
import planner.pddl.Pair;
import planner.pddl.State;
import planner.pddl.StateHeuristic;
import planner.pddl.tree.TreeNodeInt;

/**
 * ...
 * @author Michael Stephens
 */
class TreeNodeIntFunctionValue extends TreeNodeInt
{

	var value:String = null;
	
	public function new(value_:String) 
	{
		super(); //pass in a fresh array because we dont want any crazy cyclic shenanigans to happen
		
		value = value_;
	}
	
	override public function Evaluate(data_:ActionData, state_:State, domain_:Domain):Bool
	{
		throw "This function should not be getting called.";
	}
	
	override public function Execute(data_:ActionData, state_:State, domain_:Domain):String
	{
		return value;
	}
	
	override public function HeuristicEvaluate(data_:ActionData, heuristic_data_:HeuristicData, state_:StateHeuristic, domain_:Domain):Bool 
	{
		throw "This function should not be getting called.";
	}
	
	override public function HeuristicExecute(data_:ActionData, heuristic_data_:HeuristicData, state_:StateHeuristic, domain_:Domain):String 
	{
		return value;
	}
	
	override public function GenerateConcrete(action_data_:ActionData, state_:State, domain_:Domain):Array<TreeNode>
	{
		return [new TreeNodeIntFunctionValue(value)]; // since this treenode will never change, just use this instead of instantiating a copy
	}
	
	override public function GetRawName():String
	{
		return value;
	}
	
	override public function GetRawTreeString():String
	{
		return value;
	}

	override public function Clone():TreeNode 
	{
		return new TreeNodeIntFunctionValue(value);
	}
	
	public function SetValue(value_:String)
	{
		value = value_;
	}
	
}