package events 
{
	import flash.events.Event;

	/**
	 * @author Kevin Cao
	 */
	public class SaveEvent extends Event 
	{
		public static const SAVE : String = "save";
		
		public var version : String;

		public var path : String;

		public function SaveEvent(type : String, path : String, version : String) 
		{
			super(type);
			this.path = path;
			this.version = version;
		}

		override public function clone() : Event 
		{
			var event : SaveEvent = new SaveEvent(type, path, version);
			return event;
		}
	}
}
