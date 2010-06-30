package models 
{
	import org.robotlegs.mvcs.Actor;

	import flash.filesystem.File;
	import flash.system.Capabilities;

	/**
	 * @author Kevin Cao
	 */
	public class AppModel extends Actor 
	{
		private var _sdkPath : String = "";
		private var _sdkVersion : String = "";

		public function AppModel()
		{
		}

		public function get sdkPath() : String
		{
			return _sdkPath;
		}

		public function set sdkPath(value : String) : void
		{
			_sdkPath = value;
		}

		public function get sdkVersion() : String
		{
			return _sdkVersion;
		}

		public function set sdkVersion(sdkVersion : String) : void
		{
			_sdkVersion = sdkVersion;
		}

		public function get compiler() : File 
		{
			return new File(_sdkPath).resolvePath(Capabilities.os.indexOf("Windows") != -1 ? "bin/mxmlc.exe" : "bin/mxmlc");
		}
	}
}
