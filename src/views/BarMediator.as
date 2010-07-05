package views 
{
	import events.AppEvent;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.MouseEvent;

	/**
	 * @author Kevin Cao
	 */
	public class BarMediator extends Mediator 
	{

		[Inject]
		public var view : BarView;

		override public function onRegister() : void 
		{
			addViewListener(MouseEvent.CLICK, clickHandler);
			
			eventMap.mapListener(view, MouseEvent.MOUSE_DOWN, mouseDownHandler, MouseEvent);
		}

		private function clickHandler(event : MouseEvent) : void 
		{
			switch (event.target) 
			{
				case view.setting_btn:
					// 设置
					dispatch(new AppEvent(AppEvent.SHOW_SETTING));
					break;
					
				case view.min_btn:
					// 最小化
					contextView.stage.nativeWindow.minimize();
					break;
					
				case view.close_btn:
					// 关闭窗口
					contextView.stage.nativeWindow.close();
					break;
					
				case view.title:
					// 关于
					dispatch(new AppEvent(AppEvent.SHOW_ABOUT));
					break;
			}
		}

		private function mouseDownHandler(event : MouseEvent) : void 
		{
			contextView.stage.nativeWindow.startMove();
		}
	}
}
