package xpt.timing;
import utest.Assert;
import xpt.stimuli.Stimulus;

/**
 * ...
 * @author 
 */
class Test_TimingBoss
{

	public function new() { }
	
	public function test_sortOn() {
		/*
		var stim = new Stimulus();
		stim.start = 11;
		stim.stop = 1000;
		stim.id = "a";
		stim.depth = 1;
		
		var stim1 = new Stimulus();
		stim1.start = 550;
		stim1.stop = 0;
		stim1.id = "b";
		stim1.depth = 0;
		
		var stim2 = new Stimulus();
		stim2.start = 550;
		stim2.stop = 650;
		stim2.id = "c";
		stim2.depth = 2;
		
		
		var arr:Array<Stimulus> = TimingBoss.__sortOn("stop", [stim, stim1, stim2]);
		
		Assert.isTrue(arr[0].id == "b");
		Assert.isTrue(arr[1].id == "c");
		Assert.isTrue(arr[2].id == "a");
		*/
	}

	public function test_grand() {
		/*
		var t:TimingBoss = new TimingBoss();
		
		var stim:Stimulus = new Stimulus();
		stim.start = 11;
		stim.stop = 1000;
		stim.id = "a";
		stim.depth = 1;
		
		t.add(stim);
		Assert.isTrue(t.__startTimeSorted.length == 1);
		Assert.isTrue(t.__endTimeSorted.length == 1);
		Assert.isTrue(t.__allStim.length == 1);
		Assert.isTrue(t.__objsOnScreen.length == 0);
		

		
		var stim1 = new Stimulus();
		stim1.start = 500;
		stim1.stop = 600;
		stim1.id = "b";
		stim1.depth = 2;
		t.add(stim1);
		t.sortTime();
		
		Assert.isTrue(t.__startTimeSorted.length == 2);
		
		t.checkForEvent(11);
		Assert.isTrue(t.__objsOnScreen.length == 1);
		Assert.isTrue(t.__startTimeSorted.length == 1);
		
		
		stim = new Stimulus();
		stim.start = 550;
		stim.stop = 650;
		stim.id = "c";
		stim.depth = 0;
		t.add(stim);
		t.sortTime();
		
		t.checkForEvent(550);
		Assert.isTrue(t.__objsOnScreen.length == 3);
		Assert.isTrue(t.__startTimeSorted.length == 0);
		
		var a = t.getStimulusID("a");
		var b = t.getStimulusID("b");
		var c = t.getStimulusID("c");
		

		
		Assert.isTrue(t.__endTimeSorted[0].stop == 600);
		Assert.isTrue(t.__endTimeSorted[1].stop == 650);
		Assert.isTrue(t.__endTimeSorted[2].stop == 1000);
		

		t.checkForEvent(601);
		
		Assert.isTrue(t.__objsOnScreen.length == 2);
		Assert.isTrue(t.__endTimeSorted.length == 2);
		
		t.checkForEvent(1001);
		Assert.isTrue(t.__objsOnScreen.length == 0);
		Assert.isTrue(t.__endTimeSorted.length == 0);
		Assert.isTrue(t.__startTimeSorted.length == 0);
		Assert.isTrue(t.__allStim.length == 3);
		*/
	}
	
}