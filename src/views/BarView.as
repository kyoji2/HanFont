package views 
{
	import assets.BarSymbol;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	/**
	 * @author Kevin Cao
	 */
	public class BarView extends BarSymbol 
	{
		public function BarView() 
		{
			setting_btn.buttonMode = true;
			min_btn.buttonMode = true;
			close_btn.buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		private function mouseOverHandler(event : MouseEvent) : void 
		{
			switch(event.target)
			{
				case setting_btn:
				case min_btn:
				case close_btn:
					DisplayObject(event.target).filters = [new GlowFilter(0x9f9f9f, 1, 3, 3)];
					break;
			}
		}

		private function mouseOutHandler(event : MouseEvent) : void 
		{
			switch(event.target)
			{
				case setting_btn:
				case min_btn:
				case close_btn:
					DisplayObject(event.target).filters = null;
					break;
			}
		}
	}
}
