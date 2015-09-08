package xpt.results;
import utest.Assert;


/**
 * ...
 * @author 
 */
class Test_Results
{

	public function new() 
	{
		
	}
	
	public function test__addResultsInfo() {
	
		var trialResults:TrialResults = new TrialResults();
		trialResults.results = ['a' => 'aa', 'b' => 'bb'];
		
		
		Results.__addResultsInfo(trialResults, ['a' => 'aa', 'b' => 'bb']);
		
		Assert.isTrue(trialResults.results.toString().length==38); //cannot guarantee order. {b => bb, b1 => bb, a => aa, a1 => aa}
		
	}
	
}