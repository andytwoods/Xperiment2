package code.utils;

import utest.Assert;

class Test_Text
{

	public function new() 
	{
	}
	
	public function test_word() {
	
		Assert.isTrue(Text.word("aa bb cc", 0) == "aa");
		Assert.isTrue(Text.word("aa bb cc", 2) == "cc");
		Assert.isTrue(Text.word("aa bb cc", 3) == "aa");
		Assert.isTrue(Text.word("aa bb cc", -1) == "cc");
		Assert.isTrue(Text.word("aa bb cc", -2) == "bb");
		Assert.isTrue(Text.word("aa bb cc", -3) == "aa");
		Assert.isTrue(Text.word("aa bb cc", -4) == "cc");
	}
	
	
}