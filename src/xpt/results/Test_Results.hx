package xpt.results;
import thx.Maps;
import utest.Assert;
import xpt.comms.CommsResult;

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
		
		
		Results.__addResults(trialResults, ['a' => 'aa', 'b' => 'bb']);
		
		Assert.isTrue(trialResults.results.toString().length==38); //cannot guarantee order. {b => bb, b1 => bb, a => aa, a1 => aa}
		
	}
	
	public function test_failToSend() {
	
		Results.setup('abc', 'def', 'true', 'PUSH');
		var r:Results = new Results();
		var f:CommsResult->String->Map<String,String>->Void = r.serviceResult('some service', null);
		
		Assert.isTrue(r.failedSend_backup == null);
		
		var map:Map<String,String> = ['a' => 'aa', 'b' => 'bb', Results.EXPT_ID_TAG => 'cc'];
		
		f(CommsResult.Fail, 'bla', map);
		
		Assert.isTrue(r.failedSend_backup != null);
		Assert.isTrue(r.failedSend_backup.exists(Results.EXPT_ID_TAG) == false);
		
		var tr:TrialResults = new TrialResults();
		
		r.failedSend_backup.set(Results.EXPT_ID_TAG, 'aa');
		tr.addResult(Results.EXPT_ID_TAG, 'aaaa');

		tr.add_failed_to_send_Results(r.failedSend_backup);
		
		Assert.isTrue(tr.results.get('info_expt_id1_DEVEL_ERR') == 'aa');
		
		for (key in map){
			Assert.isTrue(tr.results.get(key)== map.get(key));
		}
	}
}