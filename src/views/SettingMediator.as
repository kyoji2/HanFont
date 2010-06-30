package views 
{
	import events.AppEvent;
	import events.SaveEvent;

	import koffee.utils.StringHelper;

	import models.AppModel;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.DropShadowFilter;
	import flash.system.Capabilities;

	/**
	 * @author Kevin Cao
	 */
	public class SettingMediator extends Mediator 
	{

		[Inject]
		public var model : AppModel;

		[Inject]
		public var view : SettingView;

		override public function onRegister() : void 
		{
			eventMap.mapListener(view.browse_btn, MouseEvent.CLICK, browseClickHandler, MouseEvent);			eventMap.mapListener(view.done_btn, MouseEvent.CLICK, doneClickHandler, MouseEvent);
			eventMap.mapListener(view.sdk_ti, Event.CHANGE, changeHandler, Event);
			
			view.x = Math.round((contextView.stage.stageWidth - view.width) * .5);
			view.y = Math.round((contextView.stage.stageHeight - view.height) * .5);
			view.filters = [new DropShadowFilter(0, 45, 0x0, 1, 30, 30, .3)];
			
			view.flex3_rb.selected = model.sdkVersion == "3";
			view.sdk_ti.text = model.sdkPath;
			view.sdk_ti.cacheAsBitmap = true;
			
			view.done_btn.enabled = StringHelper.trim(view.sdk_ti.text) != "";
		}

		private function browseClickHandler(event : MouseEvent) : void 
		{
			var sdk : File = new File();
			sdk.browseForDirectory("选择Flex SDK所在的文件夹:");
			sdk.addEventListener(Event.SELECT, selectHandler);
		}

		private function doneClickHandler(event : MouseEvent) : void 
		{
			var sdk : File = new File(view.sdk_ti.text);
			
			if(validateSDK(sdk)) 
			{
				view.sdk_ti.text = sdk.nativePath;
				view.done_btn.enabled = true;
				
				view.mouseChildren = false;
				
				dispatch(new SaveEvent(SaveEvent.SAVE, sdk.nativePath, view.flex3_rb.group.selectedData.toString()));
				dispatch(new AppEvent(AppEvent.CLOSE_SETTING));
			} 
			else 
			{
				view.error_lbl.visible = true;
				view.sdk_lbl.visible = false;
				
				contextView.stage.focus = view.sdk_ti;
			}
		}

		private function selectHandler(event : Event) : void 
		{
			view.sdk_ti.text = File(event.target).nativePath;
			view.done_btn.enabled = true;
			view.error_lbl.visible = false;
			view.sdk_lbl.visible = true;
			
			contextView.stage.focus = view.done_btn;
		}

		private function changeHandler(event : Event) : void 
		{
			view.done_btn.enabled = StringHelper.trim(view.sdk_ti.text) != "";
			view.error_lbl.visible = false;
			view.sdk_lbl.visible = true;
		}

		override public function onRemove() : void 
		{
			eventMap.unmapListener(view.browse_btn, MouseEvent.CLICK, browseClickHandler);
			eventMap.unmapListener(view.done_btn, MouseEvent.CLICK, doneClickHandler);
			
			contextView.stage.focus = null;
		}

		private function validateSDK(path : File) : Boolean 
		{
			var mxmlc : File = path.resolvePath(Capabilities.os.indexOf("Windows") != -1 ? "bin/mxmlc.exe" : "bin/mxmlc");
			return mxmlc.exists;
		}
	}
}
