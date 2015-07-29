package xpt.trial;

/**
 * @author 
 */

enum GotoTrial 
{
	Next;
	Previous;
	First;
	Last;
	Again;
	Number(num:Int);
	Name(nam:String);
}