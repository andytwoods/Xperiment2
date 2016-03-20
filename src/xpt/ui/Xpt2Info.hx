package xpt.ui;
import haxe.macro.Context;

/**
 * ...
 * @author Andy Woods
 */
class Xpt2Info
{

	
	public static function GET():Map<String,String>
	{
		var map:Map<String,String> = new Map<String,String>();
		
		map.set('Xpt2CompilationDate', getBuildDate());
		map.set('Xpt2CommitHash', getGitCommitHash());
		return map;
	}
	
	
	private macro static function getBuildDate()
	{
		return Context.makeExpr(Date.now().toString(), Context.currentPos());
	}
	
	//https://github.com/ypid/haxe-version/blob/master/Version.hx
	private static macro function getGitCommitHash():haxe.macro.Expr {
        var git_rev_parse_HEAD = new sys.io.Process('git', [ 'rev-parse', 'HEAD' ] );
        if (git_rev_parse_HEAD.exitCode() != 0) {
            throw("`git rev-parse HEAD` failed: " + git_rev_parse_HEAD.stderr.readAll().toString());
        }
        var commit_hash = git_rev_parse_HEAD.stdout.readLine();
        return macro $v{commit_hash};
    }
	
}