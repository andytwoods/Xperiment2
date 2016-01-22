package xpt.preloader;

import utest.Assert;

class Test_Preloader_extract_loadable
{

	public function new() { }

	public function test_generateAllPossible() {
	
		var p:Preloader_extract_loadable = new Preloader_extract_loadable();
		
		var props:Map<String,String> = new Map<String,String>();
		props.set('a', '12---3|4');
		props.set('a1','5|6---78');
		
		var list:Array<String> = p.findLoadable(props, 3, 3);
		Assert.isTrue(list.join(",")=="125,35,125,46,478,46,125,35,125");
	}
	
}