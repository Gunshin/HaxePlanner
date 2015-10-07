package test;

import haxe.Timer;
import planner.pddl.Action;

import planner.pddl.Domain;
import planner.pddl.Problem;
import planner.pddl.Planner;
import planner.pddl.PlannerActionNode;

import planner.pddl.Utilities;
import planner.pddl.tree.Tree;
import planner.pddl.tree.TreeNode;
import planner.pddl.tree.TreeNodeFunction;
import planner.pddl.tree.TreeNodeInt;
import planner.pddl.tree.TreeNodeValue;

/**
 * ...
 * @author Michael Stephens
 */
class Main 
{
	
	var domainLocation:Array<String> = [
	"pddlexamples/IPC3/Tests2/Rovers/Numeric/NumRover.pddl",
	"pddlexamples/runescape/domain2.pddl",
	"pddlexamples/IPC3/Tests3/Settlers/Numeric/Settlers.pddl",
	"pddlexamples/IPC3/Tests1/DriverLog/HardNumeric/driverlogHardNumeric.pddl"
	];
	var problemLocation:Array<String> = [
	"pddlexamples/IPC3/Tests2/Rovers/Numeric/pfile2",
	"pddlexamples/runescape/p2.pddl",
	"pddlexamples/IPC3/Tests3/Settlers/Numeric/pfile1",
	"pddlexamples/IPC3/Tests1/DriverLog/HardNumeric/pfile4"
	];
	//var domainLocation:String = ;
	//var problemLocation:String = ;
	
	public function new()
	{
		//UnitTests();
		
		var domainIndex:Int = 3;
		
		var domain = new Domain(domainLocation[domainIndex]);
		var problem = new Problem(problemLocation[domainIndex], domain);
		
		var start:Float = Sys.cpuTime();
		
		var planner:Planner = new Planner();
		var array:Array<PlannerActionNode> = planner.FindPlan(domain, problem, true);
		
		trace((Sys.cpuTime() - start));
		
		trace("length: " + array.length);
		
		for (i in 0...array.length)
		{
			trace(array[i].GetActionTransform());
		}
		
		/*while (true)
		{
			trace(Timer.stamp());
		}*/
		
	}
	
	public function UnitTests()
	{
		var domain:Domain = new Domain("src/test/runescape/domain.pddl");
		var problem = new Problem("src/test/runescape/p1.pddl", domain);
		
		trace("Starting Action Tests");
		var action:Action = domain.GetAction("Cut_Down_Tree");
		
		Assert((action != null), "Could not find action");
		Assert((action.GetData().GetParameterMap().exists("?resource")), "Could not find parameter");
		Assert((action.GetData().GetValue("~count") != null), "Could not find value");
		
		trace("Starting Plan Test");		
		var planner:Planner = new Planner();
		var array:Array<PlannerActionNode> = planner.FindPlan(domain, problem, true);
		
		Assert((array.length == 2), "Plan length is wrong");
		var compareArray:Array<String> = [
			"Move_To bank_area logs_area",
			"Cut_Down_Tree logs logs_area 15"
		];
		
		for (i in 0...array.length)
		{
			Assert((Utilities.Compare(array[i].GetActionTransform(), compareArray[i]) == 0), "Task: " + i + " is wrong");
		}
	}
	
	inline function Assert(flag_:Bool, mes_:String)
	{
		if (!flag_)
		{
			trace( "ERROR: " + mes_);
			throw "";
		}
	}
	
	public static function main()
	{
		new Main();
	}
}