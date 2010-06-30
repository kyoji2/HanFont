package  
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import org.robotlegs.core.IContext;

	import flash.display.Sprite;

	/**
	 * @author Kevin Cao
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="550", height="685")]

	public class Main extends Sprite 
	{
		private var context : IContext;

		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			context = new MainContext(this);
		}
	}
}
