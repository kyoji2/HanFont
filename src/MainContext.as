package  
{
	import controllers.ShowAboutCommand;

	import views.AboutMediator;
	import views.AboutView;
	import controllers.CloseSettingCommand;
	import controllers.CompileCommand;
	import controllers.InitModelCommand;
	import controllers.SaveConfigCommand;
	import controllers.ShowSettingCommand;
	import controllers.StartupCommand;

	import events.AppEvent;
	import events.CompileEvent;
	import events.SaveEvent;

	import koffee.managers.IPopupManager;
	import koffee.managers.PopupManager;

	import models.AppModel;

	import views.AppMediator;
	import views.AppView;
	import views.BarMediator;
	import views.BarView;
	import views.SettingMediator;
	import views.SettingView;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Kevin Cao
	 */
	public class MainContext extends Context 
	{
		public function MainContext(contextView : DisplayObjectContainer = null)
		{
			super(contextView, true);
		}

		override public function startup() : void 
		{
			injector.mapSingleton(AppModel);
			
			var pm : PopupManager = new PopupManager();
			pm.init(contextView.stage);
			injector.mapValue(IPopupManager, pm);
			
			mediatorMap.mapView(AppView, AppMediator);			mediatorMap.mapView(SettingView, SettingMediator);
			mediatorMap.mapView(BarView, BarMediator);
			mediatorMap.mapView(AboutView, AboutMediator);
			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCommand, ContextEvent);			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, InitModelCommand, ContextEvent);
			commandMap.mapEvent(AppEvent.SHOW_SETTING, ShowSettingCommand, AppEvent);
			commandMap.mapEvent(AppEvent.CLOSE_SETTING, CloseSettingCommand, AppEvent);
			commandMap.mapEvent(AppEvent.SHOW_ABOUT, ShowAboutCommand, AppEvent);
			commandMap.mapEvent(CompileEvent.COMPILE_REQUEST, CompileCommand, CompileEvent);
			commandMap.mapEvent(SaveEvent.SAVE, SaveConfigCommand, SaveEvent);
			
			super.startup();
		}
	}
}
