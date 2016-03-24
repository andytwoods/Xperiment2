package xpt.evolve;

import utest.Assert;
import xpt.evolve.Individual;
import xpt.mockStudy.Scheduler;

class Test_HEval_and_mockStudy
{

	public function new() { }

	
	public function test1() {
	
		function callback(arr:Array<Individual>) {
			
		}

		var evalParams:Map<String, Int> = new Map<String,Int>();
		evalParams.set('useRating_with_no_timers', 1);
		var scheduler:Scheduler = new Scheduler(600);
		
		var eval:HEvaluationManager = new HEvaluationManager(callback, evalParams);
		
		
		
	}
	
}