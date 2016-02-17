package xpt.tools;

import utest.Assert;

/**
 * ...
 * @author Andy Woods
 */
class Test_Base64
{

	public function new() 
	{
	}
	
	public function test() {
		//https://www.base64encode.org/
		Assert.isTrue(Base64.encode("Type (or paste) here...") == "VHlwZSAob3IgcGFzdGUpIGhlcmUuLi4=");
		Assert.isTrue(Base64.encode("Man is distinguished, not only by his reason, but ...") =="TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCAuLi4=");
	}
	
}