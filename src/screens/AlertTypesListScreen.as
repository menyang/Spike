package screens
{
	import display.LayoutFactory;
	import display.settings.alarms.AlertsList;
	
	import feathers.controls.Label;
	import feathers.themes.BaseMaterialDeepGreyAmberMobileTheme;
	import feathers.themes.MaterialDeepGreyAmberMobileThemeIcons;
	
	import model.ModelLocator;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	import ui.AppInterface;
	
	import utils.Constants;
	
	[ResourceBundle("alertsettingsscreen")]

	public class AlertTypesListScreen extends BaseSubScreen
	{	
		/* Display Objects */
		private var alertTypesLabel:Label;
		private var alertTypesList:AlertsList;
		
		public function AlertTypesListScreen() 
		{
			super();
			
			setupHeader();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			setupContent();
			adjustMainMenu();
		}
		
		/**
		 * Functionality
		 */
		private function setupHeader():void
		{
			/* Set Header Title */
			title = ModelLocator.resourceManagerInstance.getString('alertsettingsscreen','alert_types_list_screen_title');
			
			/* Set Header Icon */
			icon = getScreenIcon(MaterialDeepGreyAmberMobileThemeIcons.alertTexture);
			iconContainer = new <DisplayObject>[icon];
			headerProperties.rightItems = iconContainer;
		}
		
		private function setupContent():void
		{
			//Alert Types Label
			alertTypesLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('alertsettingsscreen','alerts_list_section_label'), true);
			screenRenderer.addChild(alertTypesLabel);
			
			//Alert Types List
			alertTypesList = new AlertsList();
			screenRenderer.addChild(alertTypesList);
		}
		
		private function adjustMainMenu():void
		{
			AppInterface.instance.menu.selectedIndex = 3;
		}
		
		/**
		 * Event Handlers
		 */
		override protected function onBackButtonTriggered(event:Event):void
		{
			dispatchEventWith(Event.COMPLETE);
		}
		
		/**
		 * Utility
		 */
		override protected function draw():void 
		{
			super.draw();
			icon.x = Constants.stageWidth - icon.width - BaseMaterialDeepGreyAmberMobileTheme.defaultPanelPadding;
		}
	}
}