package events 
{
	import flash.events.Event;
	import flash.filesystem.File;

	/**
	 * @author Kevin Cao
	 */
	public class CompileEvent extends Event 
	{
		public static const COMPILE_REQUEST : String = "compileRequest";
		
		public var asFile : File;

		public var targetFile : File;

		public function CompileEvent(type : String, asFile : File, targetFile : File) 
		{
			super(type);
			this.asFile = asFile;
			this.targetFile = targetFile;
		}

		override public function clone() : Event 
		{
			return new CompileEvent(type, asFile, targetFile);
		}
	}
}
