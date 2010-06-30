package controllers 
{
	import events.AppEvent;

	import models.AppModel;

	import org.robotlegs.mvcs.Command;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author Kevin Cao
	 */
	public class InitModelCommand extends Command 
	{

		[Inject]
		public var model : AppModel;

		override public function execute() : void 
		{
			var ini : File = new File(File.applicationStorageDirectory.resolvePath("config.xml").nativePath);
			if(ini.exists) 
			{
				readFromConfig(ini);
			} 
			else 
			{
				dispatch(new AppEvent(AppEvent.SHOW_SETTING));
			}
		}

		private function readFromConfig(ini : File) : void 
		{
			var fs : FileStream = new FileStream();
			fs.open(ini, FileMode.READ);
			fs.position = 0;
			var config : XML = XML(fs.readUTFBytes(fs.bytesAvailable));
			model.sdkPath = config.path;
			model.sdkVersion = config.version;
			fs.close();
			
			dispatch(new AppEvent(AppEvent.SETTING_CHANGE));
		}
	}
}
