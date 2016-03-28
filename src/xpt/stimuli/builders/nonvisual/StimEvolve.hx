package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import xpt.comms.services.REST_Service;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.nonvisual.StimEvolve;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.trial.Trial;
import xpt.comms.CommsResult;

class StimEvolve extends StimulusBuilder {
    private var _trialStarted:Bool = false;
    private var _suffleAdded:Bool = false;
    private var _shuffled:Bool = false;
	var stims:Array<Stimulus>;
	var target:Stimulus;
    
    public function new() {
        super();
        Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
		Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_END, onTrialEnded);
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
	}
    
    private function onTrialStarted(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
        _trialStarted = true;
		
		StimEvolveManager.instance.trialStarted(trial, this);
		
		this.stims = NonVisual_Tools.getStims(trial, this);
		this.target = trial.findStimulus(get('target'));
		
		if (target == null) throw 'Cannot find target to evolve (' + get('target') + ').';
		target.component.visible = false;
		
		wireupTarget(target);

    }
	
	function wireupTarget(target:Stimulus) 
	{
		
	}

	private function onTrialEnded(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialEnded);


    }
    
   
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() { // could happen instantly, could happen after a give time
        _suffleAdded = true;
    }
}

class StimEvolveManager {
	
	private static var _instance:StimEvolveManager;
	public static var instance(get, never):StimEvolveManager;
	
	public var params:StimEvolveParams;
	private var newlyInstantiated:Bool = true;
	private var trial:Trial;
	private var stimEvolve:StimEvolve;
	private var evolvePackages:Array<EvolvePackage> = new Array<EvolvePackage>();
	
	
	private static function get_instance():StimEvolveManager {
		if (_instance == null) {
			_instance = new StimEvolveManager();
		}
		return _instance;
	}

	
	public function new() {	
	}
	
	public function trialStarted(trial:Trial, stimEvolve:StimEvolve) 
	{
		
		this.stimEvolve = stimEvolve;
		
		if (newlyInstantiated == true) {
			params = StimEvolveParams.get(stimEvolve);
			newlyInstantiated = false;

			if(this.trial != trial){
				request(params.requestIndividualsAtStart);
			}
			
			this.trial = trial;
		}
		
		
		
	}
	
	function request(howMany:Int) 
	{
		for(i in 0...howMany) evolvePackages.push(	new EvolvePackage(params)	);
	}
	

	

	
}

class StimEvolveParams {
		
	public var individuals:Int = 8;
	public var requestIndividualsAtStart:Int = 2;
	public var tryAgain:Int = 0;
	
	static public function get(stimEvolve:StimEvolve):StimEvolveParams
	{
		var s:StimEvolveParams = new StimEvolveParams();

		var val:Int;		
		if ((val = stimEvolve.getInt('individuals')) != -1) {
			s.individuals = val;
		}
		
		if ((val = stimEvolve.getInt('requestIndividualsAtStart')) != -1) {
			s.requestIndividualsAtStart = val;
		}
		
		if ((val = stimEvolve.getInt('tryAgain')) != -1) {
			s.tryAgain = val;
		}
		
		
		
		
		/*var allFields = Type.getInstanceFields(StimEvolveParams);
		for (field in allFields) {
		
			var vtype = Type.typeof(Reflect.field(s, field));

			var val:String = stimEvolve.get(field);
			if (val != null) Reflect.setField(s, field, val);
			
			switch(vtype) {
				case TInt:
					var val = stimEvolve.getInt(field);
					if (val != -1) Reflect.setField(s, field, val);
				case TClass(c):
					switch(c) {
						case String:
							var val:String = stimEvolve.get(field);
							if (val != null) {
								Reflect.setField(s, field, val);
							}
					}
					
				default:
					throw 'not defined yet';				
			}
		}*/
		
		return s;
	}
	

	public function new(){}
	
}


enum CommsType {
	RequestIndividual;
	ReturnIndividual;
}


class EvolvePackage {
	
	static public var url:String;
	
	private  static inline var specialTag:String = 'info_';
	private static inline var UUID_TAG:String = specialTag + 'uuid';
	private static inline var EXPT_ID_TAG:String = specialTag + 'expt_id';
	private static inline var CSRF_TAG:String = 'csrfmiddlewaretoken';
	
	var tryAgain:Int;
	var params:StimEvolveParams;
	
	private static var genericData:Map<String,String>;

	public function new(params:StimEvolveParams) {
	
		this.params = params;
		this.tryAgain = params.tryAgain;
		var data = composeData(RequestIndividual);
		communicate(data, RequestIndividual);
	}
	
	public function giveback(individual:Dynamic) {
		tryAgain = params.tryAgain;
		communicate(composeData(ReturnIndividual), ReturnIndividual);
	}
	
	function composeData(type:CommsType):Map<String,String>
	{		
		var m:Map<String,String> = new Map<String,String>();
		for (key in genericData.keys()) {
			m.set(key, genericData.get(key));
		}
		
		m.set('type', type.getName());
		
		return m;
	}
	
	function communicate(data:Map < String, String > , type:CommsType) {
		new REST_Service(data, requestResult(type), 'POST', url);
	}
	

	function requestResult(type:CommsType):CommsResult -> String -> Map<String,String> -> Void {
		
		return 	function requestResult(success:CommsResult, message:String, data:Map<String,String>) {
			
			if (success == CommsResult.Success) {
				DebugManager.instance.info('Evolve comms service '+type.getName()+' evolve data successully');
			}
			else {
				DebugManager.instance.info('Evolve comms service FAILED to '+type.getName()+' data successully');
				if (tryAgain > 0) {
					communicate(data, type);
					tryAgain--;
					trace('err');
				}
			}
		}
	}
	
	static public function setup(exptId:String, uuid:String, csrf:String, _url:String) 
	{		
		EvolvePackage.genericData = [EvolvePackage.EXPT_ID_TAG => exptId, EvolvePackage.UUID_TAG => uuid, EvolvePackage.CSRF_TAG => csrf];
		url = _url;
	}
}



