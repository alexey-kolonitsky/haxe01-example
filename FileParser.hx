import sys.io.File;
import sys.FileSystem;

class FileParser {

	public var name:String;
	public var path:String;
	public var risks:Array<String>;
	private var content:String;

	public function new (path:String):Void {
		this.path = path;
	}
	
	public function readContent():Void {
		content = "";
		if (!FileSystem.exists(path)) {
			Sys.println('[ERROR][FileItem] File does not exists. $path');
		}

		try {
			content = File.getContent(path);
		} catch(msg:String){
			Sys.println("[ERROR][FileItem] read file " + path);
		}
	}

	public function scanTags(?tagName:String):Void {

		risks = [];

		var javadocStartIndex:Int = 0;
		var javadocEndIndex:Int = 0;
		var javadoc:String = "";

		function findTag() {
			var tagPattern:EReg = ~/@(\w+)\s([a-z\.]{3,})/ig;
			while (tagPattern.match(javadoc)) {
				var tag = tagPattern.matched(1); 
				var tagValue = tagPattern.matched(2); 
				if (tagName == tag) {
					risks.push(tagValue);
				}
				javadoc = tagPattern.matchedRight();
			}
		}

		while (javadocStartIndex != -1 
			&& javadocEndIndex != -1
			&& javadocStartIndex <= javadocEndIndex 
			&& javadocStartIndex < content.length 
			&& javadocEndIndex < content.length) {

			javadocStartIndex = content.indexOf("/**", javadocStartIndex);
			javadocEndIndex = content.indexOf("*/", javadocEndIndex + 1);
			javadoc = content.substring(javadocStartIndex, javadocEndIndex);
			if (javadoc.length > 0) {
				findTag();
			}
		}
	}
}