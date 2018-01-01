package screens
{
	import flash.system.System;
	
	import display.LayoutFactory;
	import display.settings.general.GlucoseSettingsList;
	import display.settings.general.NotificationSettingsList;
	import display.settings.general.UpdateSettingsList;
	
	import events.ScreenEvent;
	
	import feathers.controls.Label;
	import feathers.events.FeathersEventType;
	import feathers.themes.BaseMaterialDeepGreyAmberMobileTheme;
	import feathers.themes.MaterialDeepGreyAmberMobileThemeIcons;
	
	import model.ModelLocator;
	
	import services.TutorialService;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	import ui.AppInterface;
	
	import utils.Constants;

	[ResourceBundle("generalsettingsscreen")]
	
	public class GeneralSettingsScreen extends BaseSubScreen
	{
		/* Display Objects */
		private var glucoseSettings:GlucoseSettingsList;
		private var notificationSettings:NotificationSettingsList;
		private var updatesSettingsList:UpdateSettingsList;
		private var glucoseLabel:Label;
		private var notificationsLabel:Label;
		private var updateLabel:Label;
		
		public function GeneralSettingsScreen() 
		{
			super();
			
			setupHeader();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			setupContent();
			adjustMainMenu();
			setupEventHandlers();
		}
		
		/**
		 * Functionality
		 */
		private function setupHeader():void
		{
			/* Set Header Title */
			title = ModelLocator.resourceManagerInstance.getString('generalsettingsscreen','general_settings_title');
			
			/* Set Header Icon */
			icon = getScreenIcon(MaterialDeepGreyAmberMobileThemeIcons.settingsApplicationsTexture);
			iconContainer = new <DisplayObject>[icon];
			headerProperties.rightItems = iconContainer;
		}
		
		private function setupContent():void
		{
			//Glucose Section Label
			glucoseLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('generalsettingsscreen','glucose_settings_title'));
			screenRenderer.addChild(glucoseLabel);
			
			//Glucose Settings
			glucoseSettings = new GlucoseSettingsList();
			screenRenderer.addChild(glucoseSettings);
			
			//Notifications Section Label
			notificationsLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('generalsettingsscreen','bg_notifications'), true);
			screenRenderer.addChild(notificationsLabel);
			
			//Notification Settings
			notificationSettings = new NotificationSettingsList();
			screenRenderer.addChild(notificationSettings);
			
			//Update Section Label
			updateLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('generalsettingsscreen','check_for_updates'), true);
			screenRenderer.addChild(updateLabel);
			
			//Update Settings
			updatesSettingsList = new UpdateSettingsList();
			screenRenderer.addChild(updatesSettingsList);
		}
		
		private function adjustMainMenu():void
		{
			AppInterface.instance.menu.selectedIndex = 3;
		}
		
		private function setupEventHandlers():void
		{
			addEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, onScreenOut);
			AppInterface.instance.menu.addEventListener(ScreenEvent.BEGIN_SWITCH, onScreenOut);
			if( TutorialService.isActive && TutorialService.thirdStepActive)
				addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, onScreenIn);
		}
		
		/**
		 * Event Handlers
		 */
		private function onScreenOut(e:Event):void
		{
			//Save Settings
			if (glucoseSettings.needsSave)
				glucoseSettings.save();
			if (notificationSettings.needsSave)
				notificationSettings.save();
			if (updatesSettingsList.needsSave)
				updatesSettingsList.save();
			
			if (TutorialService.isActive && TutorialService.fourthStepActive)
				Starling.juggler.delayCall(TutorialService.fifthStep, .2);
		}
		
		private function onScreenIn(e:Event):void
		{
			removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, onScreenIn);
			
			if( TutorialService.isActive && TutorialService.thirdStepActive)
				Starling.juggler.delayCall(TutorialService.fourthStep, .2);
		}
		
		override protected function onBackButtonTriggered(event:Event):void
		{
			dispatchEventWith(Event.COMPLETE);
		}
		
		/**
		 * Utility
		 */
		override public function dispose():void
		{
			removeEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, onScreenOut);
			AppInterface.instance.menu.removeEventListener(ScreenEvent.BEGIN_SWITCH, onScreenOut);
			if( TutorialService.isActive)
				removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, onScreenIn);
			
			if (glucoseSettings != null)
			{
				glucoseSettings.dispose();
				glucoseSettings = null;
			}
			
			if (notificationSettings != null)
			{
				notificationSettings.dispose();
				notificationSettings = null;
			}
			
			if (updatesSettingsList != null)
			{
				updatesSettingsList.dispose();
				updatesSettingsList = null;
			}
			
			if (glucoseLabel != null)
			{
				glucoseLabel.dispose();
				glucoseLabel = null;
			}
			
			if (notificationsLabel != null)
			{
				notificationsLabel.dispose();
				notificationsLabel = null;
			}
			
			if (updateLabel != null)
			{
				updateLabel.dispose();
				updateLabel = null;
			}
			
			System.pauseForGCIfCollectionImminent(0);
			
			super.dispose();
		}
		
		override protected function draw():void 
		{
			super.draw();
			icon.x = Constants.stageWidth - icon.width - BaseMaterialDeepGreyAmberMobileTheme.defaultPanelPadding;
		}
	}
}