class Main {

    static function main():Void {

        Sys.println("JavaDocScanner Run");
        
        var git = new GitWrapper();
        git.log();

        var file:FileParser;
        var n:Int = git.changedFiles.length;
        var outputFile = sys.io.File.append("./output.txt");

        for (i in 0 ... git.changedFiles.length) {
        	var fileName = git.changedFiles[i];

        	// This is small difference of HAXE string. You should 
        	// create RegularExpression to 
        	fileName = ~/\//ig.replace(fileName, "\\");
        	var path = git.projectRoot + "\\" + fileName;
        	file = new FileParser(path);
        	file.readContent();
            file.scanTags("testcase");
        	if (file.risks.length > 0) {
        		outputFile.writeString("Risks: " + file.risks.toString() + "\n");
        	}
        }

        outputFile.close();
    }
}
