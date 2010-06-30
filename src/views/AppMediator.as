package views
{
	import assets.RingSymbol;
	import events.AppEvent;
	import events.CompileEvent;

	import koffee.managers.IPopupManager;
	import koffee.ui.TextLabel;

	import models.AppModel;

	import nl.demonsters.debugger.MonsterDebugger;

	import com.greensock.TweenLite;

	import org.robotlegs.mvcs.Mediator;

	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeProcess;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.BlurFilter;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.text.TextFormat;

	/**
	 * @author Kevin Cao
	 */
	public class AppMediator extends Mediator
	{

		[Inject]
		public var view : AppView;

		[Inject]
		public var model : AppModel;

		[Inject]
		public var pm : IPopupManager;

		private var fr : FileReference;
		private var tempFile : File;

		override public function onRegister() : void 
		{
			addContextListener(AppEvent.SHOW_SETTING, showSettingHandler);
			addContextListener(AppEvent.CLOSE_SETTING, closeSettingHandler);
			addContextListener(AppEvent.COMPILE_SUCCESS, compileResultHandler);			addContextListener(AppEvent.COMPILE_FAIL, compileResultHandler);
			addContextListener(AppEvent.SETTING_CHANGE, settingChangeHandler);
			
			addViewListener(MouseEvent.CLICK, clickHandler);
			
			addViewListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler);
			addViewListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
			
			eventMap.mapListener(view.bg, MouseEvent.MOUSE_DOWN, mouseDownHandler, MouseEvent);
			
			eventMap.mapListener(view.aaa_ck, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.cff_ck, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.systemFont_cb, Event.CHANGE, changeHandler, Event);
			eventMap.mapListener(view.range_list, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.fontPath_ti, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.italic_ck, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.bold_ck, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.space_ck, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.restrict_ck, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.fontName_ti, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.className_ti, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.input_ta, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.systemFont_rb.group, Event.CHANGE, changeHandler, Event);			eventMap.mapListener(view.variable_rb.group, Event.CHANGE, changeHandler, Event);
		}

		
		
		private function closeSettingHandler(event : Event) : void 
		{
			// enable view
			view.mouseChildren = true;
			view.filters = null;
			view.alpha = 1;
		}

		private function showSettingHandler(event : Event) : void 
		{
			// disable view
			view.mouseChildren = false;
			view.filters = [new BlurFilter()];
			view.alpha = .5;
		}

		private function settingChangeHandler(event : Event) : void 
		{
			view.cff_ck.enabled = model.sdkVersion == "4";
			view.update();
		}

		private function changeHandler(event : Event) : void 
		{
			view.update();
		}

		private function clickHandler(event : MouseEvent) : void 
		{
			switch (event.target) 
			{
				case view.clear_btn:
					view.input_ta.text = "";
					view.update();
					break;
					
				case view.browse_btn:
					lightBox("文件正在读取...");
					
					var file : File = new File();
					file.browseForOpen("选择字体文件", [new FileFilter("Font File (*.ttf;*.otf)", "*.ttf;*.otf")]);
					file.addEventListener(Event.SELECT, browseSelectHandler);
					file.addEventListener(Event.CANCEL, cancelHandler);
					break;
					
				case view.import_btn:
					lightBox("文件正在读取...");
					
					fr = new FileReference();
					fr.browse([new FileFilter("Text File (*.txt;*.as;*.xml;*.htm;*.html;*.php;*.asp;*.aspx;*.js)", "*.txt;*.as;*.xml;*.htm;*.html;*.php;*.asp;*.aspx;*.js")]);
					fr.addEventListener(Event.SELECT, importSelectHandler);
					fr.addEventListener(Event.COMPLETE, importCompleteHandler);
					fr.addEventListener(Event.CANCEL, cancelHandler);
					fr.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					break;
					
				case view.save_btn:
					lightBox("文件正在保存...");
					
					fr = new FileReference();
					fr.save(view.output_ta.text, "FontLibrary.as");
					fr.addEventListener(Event.COMPLETE, fileSaveCompleteHandler);
					fr.addEventListener(Event.CANCEL, cancelHandler);
					fr.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					break;
					
				case view.clipboard_btn:
					System.setClipboard(view.output_ta.text);
					// animate btn
					view.clipboard_btn.label = "已复制";
					view.clipboard_btn.enabled = false;
					TweenLite.to(view.clipboard_btn.textField, 0.3, {alpha:0, delay:0.3, onComplete : function():void 
					{
						view.clipboard_btn.label = "复制到剪贴板";
						view.clipboard_btn.enabled = true;
						TweenLite.to(view.clipboard_btn.textField, 0.4, {alpha:1});
					}});
					break;
					
				case view.compile_btn:
					// 编译
					MonsterDebugger.trace(this, NativeProcess.isSupported);
					
					lightBox("文件正在读取...");
					
					var target : File = new File();
					target.addEventListener(Event.SELECT, compileSelectHandler);					target.addEventListener(Event.CANCEL, cancelHandler);
					target.browseForSave("保存");

					break;
			}
		}

		private function mouseDownHandler(event : MouseEvent) : void 
		{
			contextView.stage.nativeWindow.startMove();
		}

		private function dragEnterHandler(event : NativeDragEvent) : void 
		{
			//check and see if files are being drug in
			if(event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				//get the array of files
				var files : Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;

				//make sure only one file is dragged in (i.e. this app doesn't
				//support dragging in multiple files)
				if(files.length == 1)
				{
					//accept the drag action
					NativeDragManager.acceptDragDrop(view.input_ta);
				}
			}
		}

		private function dragDropHandler(event : NativeDragEvent) : void 
		{
			//get the array of files being drug into the app
			var arr : Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;

			//grab the files file
			var f : File = File(arr[0]);

			//create a FileStream to work with the file
			var fs : FileStream = new FileStream();

			//open the file for reading
			fs.open(f, FileMode.READ);

			//read the file as a string
			var data : String = fs.readUTFBytes(fs.bytesAvailable);

			//close the file
			fs.close();

			view.input_ta.text = data;
			
			view.update();
		}

		private function browseSelectHandler(event : Event) : void 
		{
			view.fontPath_ti.text = File(event.target).nativePath;
			view.update();
			pm.close();
		}

		private function importSelectHandler(event : Event) : void 
		{
			try 
			{
				fr.load();
			}
			catch (error : Error) 
			{
				lightBox("文件读取错误！");
			}
		}

		private function importCompleteHandler(event : Event) : void 
		{
			try 
			{
				view.input_ta.text = fr.data.readUTFBytes(fr.data.length);
				view.update();
				pm.close();
			}
			catch (error : Error) 
			{
				lightBox("文件读取错误！");
			}
		}

		private function fileSaveCompleteHandler(event : Event) : void 
		{
			lightBox("文件保存成功！");
		}

		private function compileSelectHandler(event : Event) : void 
		{
			// 保存临时文件
			tempFile = new File(File.applicationStorageDirectory.resolvePath("FontLibrary.as").nativePath);
			var fs : FileStream = new FileStream();
			fs.open(tempFile, FileMode.WRITE);
			fs.position = 0;
			fs.writeUTFBytes(view.output_ta.text);
			fs.close();
			
			pm.show(new RingSymbol());
			contextView.stage.mouseChildren = false;
			
			dispatch(new CompileEvent(CompileEvent.COMPILE_REQUEST, tempFile, File(event.target)));
		}

		private function cancelHandler(event : Event) : void 
		{
			pm.close();
		}

		private function errorHandler(event : IOErrorEvent) : void 
		{
			lightBox("文件读取/保存错误！");
		}

		private function compileResultHandler(event : AppEvent) : void
		{
			contextView.stage.mouseChildren = true;
			
			if(event.type == AppEvent.COMPILE_SUCCESS)
			{
				// 删除临时文件
				if(tempFile && tempFile.exists)
				{
					tempFile.deleteFile();
					tempFile = null;
				}
				
				lightBox("文件编译成功!");
			}
			else
			{
				lightBox("文件编译错误!");
			}
		}

		private function lightBox(str : String) : void 
		{
			var tl : TextLabel = new TextLabel(null, str, new TextFormat("Microsoft YaHei", 12, 0xffffff));
			pm.show(tl);
		}
	}
}
