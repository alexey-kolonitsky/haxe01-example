import sys.io.Process;

class GitWrapper {


    /**
     * Constant there it's a property whick will never over-written
     */
	public var gitPath(default,never):String = "C:\\Program Files (x86)\\Git\\bin\\git.exe";
	public var projectRoot(default,never):String = "D:\\alexey\\work\\Starling-Framework";

	/**
	 * Properties it's just extension for fields with accesors fro 
	 * read and write.
	 */
	public var changedFiles(default,null):Array<String>;


	//---------------------------------
	// Constructor
    //---------------------------------

	public function new ():Void {

	}

	/**
	 * Simple method to run git-log command with predefined arguments and
	 * pars result to find 
	 */
	public function log():Void {

		var gitRoot = '--git-dir=$projectRoot\\.git';

		//Result of process become available immediately after creation of instance
		var process = new Process(gitPath, [gitRoot, "log", "-3", "--numstat", "--oneline"]);

		changedFiles = [];
		
		// Very strange behaviour for me. There are we use infinity while-loop
		// and read lines of console output untile exception occured. And we
		// wait for it. For me it is like awaiting illnes. I'm also know
		// that try-catch it's a heavy control-flow in all programming
		// languages.
		try {
	      while(true) {
		    var str = process.stdout.readLine();
		    parseLogLine(str);
	      }
	    } catch(exception:haxe.io.Eof) {

	    }
	}

	/**
	 * HAXE doesn't have 'protected' access modifier for class members but
	 * private methods there behave exactly as protected in JAVA, C# or 
	 * ActionScript
	 */
	private function parseLogLine(str:String):Void {

		var commitLinePattern:EReg = ~/([0-9a-z]{7})\s(.*)/i;
		var changeLinePattern:EReg = ~/\d+\s+\d+\s+(.*)/i;
		if (commitLinePattern.match(str)) {
			Sys.println("COMMIT: " + commitLinePattern.matched(1));
		} else if (changeLinePattern.match(str)) {
			var fileName:String = changeLinePattern.matched(1);
			if (changedFiles.indexOf(fileName) == -1) {
				changedFiles.push(fileName);
				Sys.println("CHANGE: " + fileName);
			}
		} else {
			Sys.println("??????: " + str);
		}
	}
}