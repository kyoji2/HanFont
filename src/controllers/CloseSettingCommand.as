package controllers 
{
	import com.greensock.TweenLite;

	import org.robotlegs.mvcs.Command;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Kevin Cao
	 */
	public class CloseSettingCommand extends Command 
	{
		private var contianer : DisplayObjectContainer;

		override public function execute() : void 
		{
			contianer = DisplayObjectContainer(contextView.getChildAt(1));
			TweenLite.to(contianer.getChildAt(0), .2, {alpha : 0, onComplete : onTweenComplete});
		}

		private function onTweenComplete() : void 
		{
			contianer.removeChildAt(0);
		}
	}
}
