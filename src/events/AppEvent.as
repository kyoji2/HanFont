package events{	import flash.events.Event;	/**	 * @author Kevin Cao	 */	public class AppEvent extends Event 	{		public static const SHOW_SETTING : String = "showSetting";		public static const CLOSE_SETTING : String = "closeSetting";
		public static const COMPILE_SUCCESS : String = "compileSuccess";
		public static const COMPILE_FAIL : String = "compileFail";
		public static const SETTING_CHANGE : String = "settingChange";
		public function AppEvent(type : String) 		{			super(type);		}		override public function toString() : String 		{			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase");		}		override public function clone() : Event 		{			return new AppEvent(type);		}	}}