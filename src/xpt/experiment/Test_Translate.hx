package xpt.experiment;

import thx.Maps;
import utest.Assert;

class Test_Translate
{

	public function new() {	}
	
	public function test_translate() {
		var props:Map<String,String> = ['a.eng' => 'e', 'b.french' => 'f'];	
		
		Translate.__translate(props, 'french', ['eng', 'french'], 'eng');

		Assert.isTrue(props.get('b') == 'f');
		Assert.isTrue(props.get('b.eng')=='');
	}
	
}