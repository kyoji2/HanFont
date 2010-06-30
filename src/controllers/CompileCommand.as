package controllers 
{
	import events.AppEvent;
	import events.CompileEvent;

	import models.AppModel;

	import nl.demonsters.debugger.MonsterDebugger;

	import org.robotlegs.mvcs.Command;

	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	/**
	 * @author Kevin Cao
	 */
	public class CompileCommand extends Command 
	{

		[Inject]
		public var model : AppModel;

		[Inject]
		public var event : CompileEvent;

		override public function execute() : void 
		{
			var args : Vector.<String> = new Vector.<String>();
			
			args.push("-o");
			args.push(event.targetFile.nativePath);
			
			args.push("-static-link-runtime-shared-libraries=true");
			
			args.push("--");
			args.push(event.asFile.nativePath);
		
			var info : NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = model.compiler;
			info.workingDirectory = File.applicationStorageDirectory;
			info.arguments = args;
		
			var process : NativeProcess = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, processOutputHandler);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, processErrorHandler);
			process.addEventListener(NativeProcessExitEvent.EXIT, exitHandler);
			process.start(info);
		}

		private function processOutputHandler(event : Event) : void
		{
			var process : NativeProcess = NativeProcess(event.target);
			
			// utf
//			MonsterDebugger.trace(this, process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable), 0x111199);
			
			// gb2312
			var bytes : ByteArray = new ByteArray();
			process.standardOutput.readBytes(bytes, 0, process.standardOutput.bytesAvailable);
			MonsterDebugger.trace(this, bytes.readMultiByte(bytes.length, "gb2312"), 0x111199);
		}

		private function processErrorHandler(event : Event) : void
		{
			var process : NativeProcess = NativeProcess(event.target);
			
			//utf
//			MonsterDebugger.trace(this, process.standardError.readUTFBytes(process.standardError.bytesAvailable), 0x991111);
			
			// gb2312
			var bytes : ByteArray = new ByteArray();
			process.standardOutput.readBytes(bytes, 0, process.standardOutput.bytesAvailable);
			MonsterDebugger.trace(this, bytes.readMultiByte(bytes.length, "gb2312"), 0x991111);
		}

		private function exitHandler(event : NativeProcessExitEvent) : void
		{
			MonsterDebugger.trace(this, "exist:" + event.exitCode);
			
			if(event.exitCode == 0)
			{
				dispatch(new AppEvent(AppEvent.COMPILE_SUCCESS));
			}
			else
			{
				dispatch(new AppEvent(AppEvent.COMPILE_FAIL));
			}
		}
	}
}
