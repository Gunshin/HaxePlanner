package htnPlanner;

/**
 * ...
 * @author Michael Stephens
 */
class RawTreeNode
{
	public var value:String = null;
	public var parentNode:RawTreeNode = null;
	public var children:Array<RawTreeNode> = new Array<RawTreeNode>();

	
	public var evaluatedVar:String = null;

	public function new(parentNode_:RawTreeNode)
	{
		parentNode = parentNode_;
	}

	
	public function GetChildrenWithContainingValue(value_:String):Array<RawTreeNode>
	{
		if (value_ == null || value_.length == 0)
		{
			throw "value_ is null";
		}
		
		var childrenWithValue:Array<RawTreeNode> = new Array<RawTreeNode>();
		
		for (i in children)
		{
			if (i.value.indexOf(value_) != -1)
			{
				childrenWithValue.push(i);
			}
		}
		
		return childrenWithValue;
		
	}
	
}