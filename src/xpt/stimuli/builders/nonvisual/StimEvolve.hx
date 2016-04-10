package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import thx.Floats;
import xpt.comms.services.REST_Service;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.evolve.Individual;
import xpt.stimuli.builders.nonvisual.StimEvolve;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.tools.XRandom;
import xpt.trial.Trial;
import xpt.comms.CommsResult;

class StimEvolve extends StimulusBuilder {
    var _trialStarted:Bool = false;
	var stims:Array<Stimulus>;
	var target:Stimulus;
	var evolveManager:StimEvolveManager;
	var target_changed_once = false;
	var saveParams:Array<String>;
	var individual:IndividualInstruction;

    
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
		
		var evolveId:String = get('evolveId', null);
		if (evolveId == null) throw 'no evolveId specified';
		
		this.stims = NonVisual_Tools.getStims(trial, this);
		this.target = trial.findStimulus(get('target'));
		
		if (target == null) throw 'Cannot find target to evolve (' + get('target') + ').';
		target.component.visible = false;
		
		saveParams = getStringArray('data');
		if (saveParams == null) throw "For an Evolve stimulus, you MUST set what 'data' you want to return from the trial results. Not done so.";
		
		evolveManager = StimEvolveManager.my_instance(evolveId);
		evolveManager.trialStarted(this);
		changeTargetGenes();
    }
	

	private function onTrialEnded(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_END, onTrialEnded);

		var results:Map<String,String> = e.trial.results();
		var evolveData:Map<String,String> = new Map<String,String>();
		
		var val:String;
		for (key in saveParams) {
			val = results.get(key);
			if (val == null) throw "For an evolve stimulus, in it's 'data' field, cannot find one of the params set in the results: "+key+".";
			evolveData.set(key, val);
		}
		
		individual.data = evolveData;
		var data = individual.composeOutput();
		evolveManager.send_data(data);
		
		if (evolveManager.collectData == true) {
			var edata = evolveManager.results_buffer.compose();
			for (key in edata) {
				e.trial.save(key, edata.get(key));
			}
		}
		
		
    }
    
	private function changeTargetGenes() {
	
		if(target_changed_once == false){
			individual = evolveManager.take_individual();

			if (individual == null) {
				return;
			}
			if (individual.must_generate == true) {
				trace('must generate an individual');
				individual.generate(getStringArray("genes").length, get("maxGeneValue"), get("minGeneValue"), get("geneType"));
			}
			trace('setting individual');
			
			target_changed_once = true;
			var genes:Array<String> = getStringArray('genes');
			//trace(genes); //race condiction here..........................................................................................................................................
			if (genes.length > individual.genes.length) throw 'the evolver in the cloud has not provided enough genes (you have too many genes to change).';
			var gene:String;
			var transform:String = get('transform');
			//trace(individual.genes);
			for (g in 0...genes.length) {
				gene =  genes[g];
				target.setDynamic(gene, process(transform, individual.genes[g]-1));
			}	
			target.builder.update();
			target.component.visible = true;
			
		}
	}
	
	function process(transform:String, i:Float):String
	{
		if (transform == null) return Std.string(i);
		
		var colours:Array<String> = get('colours', '').split(",");
		var colour:String = colours[Std.int(i)];
		return colour;
	}
	
	public function individualsAvailable() {	
		changeTargetGenes();
	}
    
}

class IndividualInstruction {
	
	public var rating_num:Int;
	public var genes:Array<Float>;
	public var id:Int;	
	public var data:Map<String,String>;
	public var must_generate:Bool = false;
	
	public function new(arr:Array<String>) {	
		if (arr == null) {
			must_generate = true;
			return;
		}
		for (item in arr) {
			parse(item.split(":"));
		}
	}
	
	public function generate(numGenes:Int, maxGeneValue:String, minGeneValue:String, geneType:String) {
		this.id = -1;
		genes = new Array<Float>();
		for (i in 0...numGenes) {
			genes[i] = makeGene(Std.parseFloat(maxGeneValue), Std.parseFloat(minGeneValue), geneType);
		}
	}
	
	function makeGene(max:Float, min:Float, type:String) {
		var f:Float = XRandom.random();
		var range:Float = max - min;
		f *= range;
		f += min;
		if (type.toLowerCase() == 'int') {
			f = Floats.roundTo(f, 0);
		}
		return f;
	}
	
	function parse(split:Array<String>) {
		if (split.length != 2) return;
		switch(split[0]) {
		
			case 'rating_num':
				this.rating_num = Std.parseInt(split[1]);
			case 'id':
				this.id = Std.parseInt(split[1]);
			case 'genes':
				var val:String = split[1];
				this.genes = new Array<Float>();
				var arr2 = val.split("|");
				for (i in 0...arr2.length) {
					this.genes.push(Std.parseFloat(arr2[i]));
				}
		}
	}
	
	public function composeOutput():Map<String,String> {
		var ratings = new Array<String>();
		for (rating in data) {
			ratings.push(rating);
		}
		var strId:String = Std.string(id) + "-";
		var rating:String = null;
		if (ratings != null) rating = ratings.join("|");
		else rating = '';
		
		var results:Map<String,String> = [strId + 'rating' => rating, strId + 'rating_num' => Std.string(rating_num)];
		if (must_generate == true) results.set('genes', genes.join(","));
		return results;
	}
	
	
	public static function add(str:String, parent:Array<IndividualInstruction>):Int {
		//didnt want to add json parsers so done by hand
		var count:Int = 0;
		str = str.substr(2, str.length-4); // remove surrounding brackets
        str = str.split("{").join("");
        
        var arr = str.split("}");
        for (s in arr) {
			parent.push( new IndividualInstruction(null ));
			count ++;
		}
		var generated:Array<IndividualInstruction> = new Array<IndividualInstruction>();
		for (child in parent) {
			if (child.must_generate == true) generated.push(child);
		}
		while (generated.length > 0 && count>=0) {
			var child = generated.pop();
			parent.remove(child);
			count--;
		}
		
		return count;
	}
	
	public static function emergencyGenerate(parent:Array<IndividualInstruction>):Int {
		var ind = new IndividualInstruction(null);
		parent.push( ind );
		return 1;
	}
}

class Results_buffer {
	var data:Map<String,String> = new Map<String,String>();

	public function new() {	
	}
	
	public function add(d:Map<String,String>) {
		for (key in d.keys()) {
			data.set(key, d.get(key));
		}
	}
	
	public function compose():Map<String,String> {
		var copy:Map<String,String> = new Map<String,String>();
		for (key in data.keys()) {
			copy.set(key, data.get(key));
			data.remove(key);
		}
		return copy;
	}
}

class StimEvolveManager {
	
	private static var instances:Map<String,StimEvolveManager> = new Map<String,StimEvolveManager>();
	
	public var params:StimEvolveParams;
	private var newlyInstantiated:Bool = true;
	private var trial:Trial;
	private var stimEvolve:StimEvolve;	
	private var individualInstructions = new Array<IndividualInstruction>();
	//private var individualsCount:Int = 0;
	public var results_buffer = new Results_buffer();
	private var requestsCount:Int = 0;
	private var return_unused = false;
	private var emergencyGenerateCount:Int = 0;
	private var failedSendCount:Int = 0;
	private var totalRatingsMade:Int = 0;
	
	public var collectData:Bool = false;
	
	public static function my_instance(id:String):StimEvolveManager {
		if (instances.exists(id) == false) {
			instances.set(id,new StimEvolveManager());
		}
		return instances.get(id);
	}

	public function feedback():Map<String,String> {
		var feedbackData:Map<String,String> = new Map<String,String>();
		if (emergencyGenerateCount > 0) {
			feedbackData.set('emergencyGeneratedCount', Std.string(emergencyGenerateCount));
		}
		if (failedSendCount > 0) {
			feedbackData.set('failedSendCount', Std.string(failedSendCount));
		}
		return feedbackData;
	}
	
	public function new() {	
	}
	
	public function take_individual():IndividualInstruction {
		if (individualInstructions.length > 0) {
			for (individual in individualInstructions) {
				if (individual.must_generate == false) {
					individualInstructions.remove(individual);
					return individual;
				}
			}
			//if cant find an individual that must be generated...
			return individualInstructions.shift();
		}
		return null;
	}
	
	public function send_data(data:Map<String,String>) {
		totalRatingsMade ++;
		if (totalRatingsMade >= params.individuals) collectData = true;
		results_buffer.add(data);
		if (return_unused) {
			////////////////////////////////////////////////////////////////////////////////SORT OUT LATER
		}
		
		var commsManager = new EvolveCommsManager(params, callback);
		commsManager.returnData(results_buffer.compose());
	}
	
	
	public function trialStarted(stimEvolve:StimEvolve) 
	{
		this.stimEvolve = stimEvolve;
		
		if (newlyInstantiated == true) {
			newlyInstantiated = false;
			EvolveCommsManager.addEvolveId(stimEvolve.get('evolveId'));
			params = StimEvolveParams.get(stimEvolve);
		}
		
		var required:Int = params.individuals - requestsCount;
		if (required > 0) {
			if (newlyInstantiated == true)  request(params.request_at_start);
			else request(params.request_each_time);
		}
		else {
			return_unused = true;
		}
	}
	
	function request(howMany:Int) 
	{
		var commsManager = new EvolveCommsManager(params, callback);
		commsManager.request(howMany);
		requestsCount+= howMany;
	}
	
	function callback(commsManager:EvolveCommsManager, commsResult:CommsResult, commsType:CommsType, data:Map<String,String>, message:String) {
		switch(commsType){
			case CommsType.RequestIndividual:
				callback_request(commsManager, commsResult, data, message);
			case CommsType.ReturnIndividual:
				callback_return(commsManager, commsResult, data);
		}
	}
	
	inline function callback_request(commsManager:EvolveCommsManager, commsResult:CommsResult, data:Map<String,String>, message:String) 
	{
		switch(commsResult) {
			case CommsResult.Success:
				requestsCount += IndividualInstruction.add(message, individualInstructions);
			case CommsResult.Fail:
				requestsCount += IndividualInstruction.emergencyGenerate(individualInstructions);
				emergencyGenerateCount++;
		}
		if (this.stimEvolve != null) this.stimEvolve.individualsAvailable();
	}
	
	inline function callback_return(commsManager:EvolveCommsManager, commsResult:CommsResult, data:Map<String, String>) 
	{
		switch(commsResult) {
			case CommsResult.Success:
				'no action';
			case CommsResult.Fail:
				failedSendCount++;
				results_buffer.add(data);
		}	
	}
}





class EvolveCommsManager {
	
	static public var url:String;
	
	private static inline var UUID_TAG:String = 'uuid';
	private static inline var EVOLVE_ID_TAG:String = 'evolve_id';
	private static inline var CSRF_TAG:String = 'csrfmiddlewaretoken';
	
	private static inline var CHECKOUT:String = 'checkout/';
	private static inline var RETURN:String = 'return/';
	
	public static inline var REQUEST_HOW_MANY:String = 'request_how_many';
	
	var tryAgain:Int;
	var params:StimEvolveParams;
	var callback:EvolveCommsManager->CommsResult->CommsType -> Map<String,String>->String->Void;
	public var type:CommsType;
	
	private static var genericData:Map<String,String>;
	

	public function new(params:StimEvolveParams, callback:EvolveCommsManager->CommsResult->CommsType -> Map<String,String>->String->Void) {
		this.callback = callback;
		this.params = params;
		this.tryAgain = params.tryAgain;
	}
	
	public function request(howMany:Int) {
		this.type = CommsType.RequestIndividual;
		var data:Map<String,String> = new Map<String,String>();
		data.set(REQUEST_HOW_MANY, Std.string(howMany));
		communicate(decorateData(data));	
	}
	
	public function returnData(data:Map<String,String>) {
		this.type = CommsType.ReturnIndividual;
		communicate(decorateData(data));
	}
	
	//add permissions etc
	function decorateData(data:Map<String,String>):Map<String,String>
	{		
		for (key in genericData.keys()) {
			data.set(key, genericData.get(key));
		}
		return data;
	}
	
	function communicate(data:Map < String, String >) {
		var _url:String = url;
		switch(type) {
			case RequestIndividual:
				_url += CHECKOUT;
			case ReturnIndividual:
				_url += RETURN;
		}
		new REST_Service(data, requestResult(type), 'POST', _url, '*');
	}
	

	function requestResult(type:CommsType) {
		
		return 	function requestResult(result:CommsResult, message:String, data:Map<String,String>) {
			//trace(1111, result, message, data);
			var done:Bool = false;
			if (result == CommsResult.Success) {
				DebugManager.instance.info('Evolve comms service ' + type.getName() + ' evolve data successully');
				done = true;
			}
			else {
				DebugManager.instance.info('Evolve comms service FAILED to ' + type.getName() + ' data successully');
				//trace(tryAgain, 1222);
				if (tryAgain > 0) {
					communicate(data);
					tryAgain--;
				}
				else {
					done = true;
				}
			}
			if (done == true) {
				if (callback != null) {
					callback(this, result, type, data, message);
				}
			}
		}
	}
	
	static public function addEvolveId(id:String) {
		EvolveCommsManager.genericData.set(EVOLVE_ID_TAG, id);
	}
	
	static public function setup(uuid:String, csrf:String, _url:String) 
	{		
		EvolveCommsManager.genericData = [EvolveCommsManager.UUID_TAG => uuid, EvolveCommsManager.CSRF_TAG => csrf];
		url = _url;
	}
}





class StimEvolveParams {
		
	public var individuals:Int = 80;
	public var request_each_time:Int = 1;// 2;
	public var tryAgain:Int = 0;
	public var request_at_start:Int = 1;// 5;
	
	static public function get(stimEvolve:StimEvolve):StimEvolveParams
	{
		var s:StimEvolveParams = new StimEvolveParams();

		var val:Int;		
		if ((val = stimEvolve.getInt('individuals')) != -1) {
			s.individuals = val;
		}
		
		if ((val = stimEvolve.getInt('request_each_time')) != -1) {
			s.request_each_time = val;
		}
		
		if ((val = stimEvolve.getInt('request_at_start')) != -1) {
			s.request_at_start = val;
		}
		
		if ((val = stimEvolve.getInt('tryAgain')) != -1) {
			s.tryAgain = val;
		}
		

		return s;
	}
	

	public function new(){}
	
}


enum CommsType {
	RequestIndividual;
	ReturnIndividual;
}
