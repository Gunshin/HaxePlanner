package planner.pddl;

/**
 * ...
 * @author Michael Stephens
 */
class Value
{
	var name:String = null;	
	
	var value:String = null;
	
	public function new(name_:String)
	{
		name = name_;
	}
	
	public function GetPossibleValues(data_:ActionData, state_:State, domain_:Domain, heuristic_version_:Bool, use_sampling_:Bool, percentage_:Float):Array<String> { throw "must override this function"; }
	
	public function SetValue(value_:String)
	{
		value = value_;
	}
	
	public function GetValue():String
	{
		return value;
	}
	
	public function GetName():String
	{
		return name;
	}
	
	public function toString():String
	{
		return "{\"name\":\"" + name + "\",\"value\":\"" + value + "\"}";
	}
	
}