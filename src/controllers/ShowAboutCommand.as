package controllers 
{
	import koffee.managers.IPopupManager;

	import views.AboutView;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Kevin Cao
	 */
	public class ShowAboutCommand extends Command 
	{

		[Inject]
		public var pm : IPopupManager;

		override public function execute() : void 
		{
			var aboutView : AboutView = new AboutView();
			pm.show(aboutView);
			
			mediatorMap.createMediator(aboutView);
		}
	}
}
