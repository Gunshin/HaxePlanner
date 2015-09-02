package htnPlanner.tree;
import htnPlanner.tree.TreeNodeInt;

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
	
}