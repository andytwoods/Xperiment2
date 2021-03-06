/****
* Copyright 2013 tbyrne.org All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
****/





package xmlTools.xinclude;

import haxe.io.Bytes;
import msignal.Signal;
import org.tbyrne.io.IO;

import xmlTools.xinclude.IXmlIncludeTask;

@:build(LazyInst.check())
class XmlIncludeManager 
{
	@lazyInst
	public var progressChanged:Signal1<XmlIncludeManager>;
	@lazyInst
	public var completeChanged:Signal1<XmlIncludeManager>;
	
	public var inputProvider(get, null):IInputProvider;
	private function get_inputProvider():IInputProvider {
		return _inputProvider;
	}
	
	private var _tasks:Array<XmlIncludeTask>;
	private var _finishedTasks:Int;
	private var _complete:Bool;
	private var _progress:Float = 0;
	private var _total:Float = 0;
	private var _inputProvider:IInputProvider;
	private var _currentIndex:Int = 0;
	private var _currentTask:XmlIncludeTask;

	public function new(inputProvider:IInputProvider) {
		_complete = true;
		_tasks = new Array<XmlIncludeTask>();
		_finishedTasks = 0;
		_inputProvider = inputProvider;
	}
	
	public var currentTask(get, null):IXmlIncludeTask;
	public function get_currentTask():IXmlIncludeTask {
		return _currentTask;
	}
	
	public function getProgress():Float {
		return _progress;
	}
	public function getTotal():Float {
		return _total;
	}
	public function isComplete():Bool {
		return _complete;
	}
	
	public function getCurrTask():Int {
		return _currentIndex;
	}
	public function getTaskCount():Int {
		return _tasks.length;
	}
	public function getTask(i:Int):IXmlIncludeTask {
		return _tasks[i];
	}
	
	public function add(rootFile:String, ?withinDir:String):IXmlIncludeTask {
		var ret:XmlIncludeTask = new XmlIncludeTask(_inputProvider, rootFile, withinDir);
		_tasks.push(ret);
		ret.progressChanged.add(onProgressChanged);
		ret.stateChanged.add(onStateChanged);
		setComplete(false);
		checkProgress();
		return ret;
	}
	
	public function startInclude():Void {
		_currentIndex = 0;
		doNextInclude();
	}
	private function doNextInclude():Void {
		if (_currentTask!=null) {
			_currentTask.stateChanged.remove(onCurrentStateChanged);
			_currentTask = null;
		}
		if (_currentIndex<_tasks.length) {
			_currentTask = _tasks[_currentIndex];
			_currentTask.stateChanged.add(onCurrentStateChanged);
			onCurrentStateChanged(_currentTask);
			_currentTask.startInclude();
		}else {
			//setComplete(true);
		}
	}
	
	private function onCurrentStateChanged(from:IXmlIncludeTask):Void {
		switch (_currentTask.getState()) {
			case XmlIncludeTaskState.Succeeded, XmlIncludeTaskState.Failed:
				_currentIndex++;
				doNextInclude();
			default:
				//ignore
		}
	}
	
	private function onProgressChanged(from:IXmlIncludeTask):Void {
		checkProgress();
	}
	private function onStateChanged(from:IXmlIncludeTask):Void {
		switch (from.getState()) {
			case XmlIncludeTaskState.Succeeded, XmlIncludeTaskState.Failed:
				from.progressChanged.remove(onProgressChanged);
				from.stateChanged.remove(onStateChanged);
				checkComplete();
			default:
				//ignore
		}
	}
	
	
	private function checkProgress():Void {
		var prog:Float = 0;
		var total:Float = 0;
		if(_tasks.length>0){
			for (task in _tasks) {
				prog += task.getProgress(); 
				total += task.getTotal(); 
			}
		}
		setProgress(prog, total);
	}
	private function setProgress(progress:Float, total:Float):Void {
		if (_progress == progress && _total == total) return;
		
		_progress = progress;
		_total = total;
		LazyInst.exec(progressChanged.dispatch(this));
	}
	private function checkComplete():Void {
		var complete:Bool = true;
		for (task in _tasks) {
			switch(task.getState()) {
				case XmlIncludeTaskState.Waiting, XmlIncludeTaskState.Working:
					complete = false;
				default:
					// ignore
			}
		}
		setComplete(complete);
	}
	private function setComplete(value:Bool):Void {
		if (_complete == value) return;
		
		_complete = value;
		LazyInst.exec(completeChanged.dispatch(this));
	}
}