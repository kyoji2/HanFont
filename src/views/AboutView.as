package views 
{
	import assets.AboutSymbol;

	import com.greensock.TweenMax;

	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author Kevin Cao
	 */
	public class AboutView extends AboutSymbol 
	{
		public function AboutView()
		{
			logo.buttonMode = true;
			close_btn.buttonMode = true;
			filters = [new DropShadowFilter(0, 45, 0x0, 1, 30, 30, .3)];
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		private function mouseOverHandler(event : MouseEvent) : void 
		{
			switch(event.target)
			{
				case close_btn:
				case logo:
					TweenMax.to(event.target, .1, {tint : 0xffffff});
					break;
			}
		}

		private function mouseOutHandler(event : MouseEvent) : void 
		{
			switch(event.target)
			{
				case close_btn:
					TweenMax.to(event.target, .1, {tint : 0x999999});
					break;
				case logo:
					TweenMax.to(event.target, .1, {removeTint : true});
					break;
			}
		}
	}
}
