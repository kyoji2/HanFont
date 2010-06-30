package controllers 
{
	import views.SettingView;

	import com.greensock.TweenLite;

	import org.robotlegs.mvcs.Command;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Kevin Cao
	 */
	public class ShowSettingCommand extends Command 
	{
		override public function execute() : void 
		{
			var contianer : DisplayObjectContainer = DisplayObjectContainer(contextView.getChildAt(1));
			if(!contianer.numChildren) 
			{
				contianer.addChild(new SettingView());
				
				TweenLite.from(contianer.getChildAt(0), .2, {alpha : 0});
			}
		}
	}
}
