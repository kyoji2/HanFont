package views 
{
	import assets.SettingSymbol;

	/**
	 * @author Kevin Cao
	 */
	public class SettingView extends SettingSymbol 
	{
		public function SettingView()
		{
			mouseEnabled = false;
			error_lbl.visible = false;
			sdk_lbl.visible = true;
		}
	}
}
