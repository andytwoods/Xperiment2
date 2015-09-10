package xpt2.core;

interface IClonable<T> {
	function clone():T;
	private function self():T;
}
