package controllers 
{
	import flash.display.Sprite;
	import views.BarView;
	import views.AppView;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Kevin Cao
	 */
	public class StartupCommand extends Command 
	{
		override public function execute() : void 
		{
			contextView.addChild(new AppView());
			contextView.addChild(new Sprite());
			contextView.addChild(new BarView());
		}
	}
}
