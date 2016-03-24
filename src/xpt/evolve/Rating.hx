package xpt.evolve;
import flash.events.TimerEvent;
import flash.utils.Timer;

@:allow(xpt.evolve.Test_HEvalulationManager)
class Rating{
	public var rating_num:Int;
	public var rating:Int;
	public var rater:String;
	public var timeout:Int;
	var timer:Timer;
	var fail_callback: Void->Void;
	var params:Map<String,Int>;
	
    public function new(rating_num:Int, params:Map<String,Int>){
        this.rating_num = rating_num;
        this.params = params;
		this.timeout = this.params.get('time_out');
	}

    public function start(rater, fail_callback){
        this.rater = rater;

        this.fail_callback = fail_callback;
        this.timer = new Timer(this.timeout);
		this.timer.addEventListener(TimerEvent.TIMER, do_callback);
		this.timer.start();
	}

    public function do_callback(e:TimerEvent){
		stop_timeout();
        this.fail_callback();
	}

    public function rated(rating){
        stop_timeout();
        this.rating = rating;
	}

    function stop_timeout(){
        this.timer.stop();
		this.timer.removeEventListener(TimerEvent.TIMER, do_callback);
	}
}
