package controllers 
{
	import events.AppEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.File;

	import events.SaveEvent;

	import models.AppModel;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Kevin Cao
	 */
	public class SaveConfigCommand extends Command 
	{

		[Inject]
		public var model : AppModel;

		[Inject]
		public var event : SaveEvent;

		override public function execute() : void 
		{
			if(model.sdkPath == event.path && model.sdkVersion == event.version) return;
			
			var ini : File = new File(File.applicationStorageDirectory.resolvePath("config.xml").nativePath);
			
			var config : XML =	<config/>;
			
			config.appendChild(<version>{event.version}</version>);
			config.appendChild(<path>{event.path}</path>);
			
			var fs : FileStream = new FileStream();
			fs.open(ini, FileMode.WRITE);
			fs.position = 0;
			fs.writeUTFBytes(config.toXMLString());
			fs.close();
			
			model.sdkVersion = event.version;
			model.sdkPath = event.path;
			
			dispatch(new AppEvent(AppEvent.SETTING_CHANGE));
		}
	}
}
