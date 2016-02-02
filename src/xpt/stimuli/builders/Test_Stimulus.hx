package xpt.stimuli.builders;

import flash.events.Event;
import openfl.events.MouseEvent;
import utest.Assert;
import xpt.stimuli.Stimulus;

class Test_Stimulus
{

	public function new() {	}
	

	public function test_listeners() {
	
		var stim:Stimulus = new Stimulus();
		
		stim.set('onClick', 'bla');
		
		stim.addListeners();
		
		var stimListener:Stim_Listener = stim.listeners.get('click');
		
		Assert.isTrue(stimListener != null && stimListener.remove !=null );
		
		stim.removeListeners();
		
		Assert.isTrue(stim.listeners == null);
		
	}
	
}