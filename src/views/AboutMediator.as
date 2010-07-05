package views 
{
	import koffee.managers.IPopupManager;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author Kevin Cao
	 */
	public class AboutMediator extends Mediator 
	{

		[Inject]
		public var view : AboutView;

		[Inject]
		public var pm : IPopupManager;

		override public function onRegister() : void 
		{
			addViewListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(event : MouseEvent) : void 
		{
			switch(event.target)
			{
				case view.close_btn:
					mediatorMap.removeMediator(this);
					pm.close();
					break;
				case view.logo:
					navigateToURL(new URLRequest("http://kevincao.com"));
					break;
			}
		}
	}
}
