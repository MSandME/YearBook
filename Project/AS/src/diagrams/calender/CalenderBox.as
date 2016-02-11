package diagrams.calender
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	internal class CalenderBox extends MovieClip
	{
		private static const padding:Number = 1 ;
		private static const maskPadding:Number = 5 ;
		private static const maskPaddingT:Number = 20 ;
		private static const ellipse:Number = 10 ;
		
		private var dateTitle:CalenderText ;
		
		private var Width:Number;
		
		private var Height:Number ;

		private var myDelay:uint;
		
		/**show or hider timer*/
		private var myTimer:Timer ;
		
		
		public var data:CalenderDayData ;
		
		private var contentInterface:CelenderBoxContent;
		
		private var contentArea:MovieClip;
		
		private var contentMask:MovieClip ;

		private var cahsedContents:CalenderContents;
		
		
		public function CalenderBox(myData:CalenderDayData,W:Number,H:Number)
		{
			super();
			
			data = myData ;
			
			Width = W ;
			Height = H ;
			
			var color:uint ;
			
			if(data.isCurrentDay)
			{
				color = CalenderConstants.Color_boxBackGround_currentDay ;
			}
			else if(data.isFriday)
			{
				color = CalenderConstants.Color_boxBackGround_friday ;
			}
			else
			{
				color = CalenderConstants.Color_boxBackGround ;
			}
			
			this.graphics.beginFill(color,1);
			this.graphics.drawRoundRect(padding,padding,Width-padding*2,Height-padding*2,ellipse);
			
			dateTitle = new CalenderText(CalenderConstants.Color_boxNames,CalenderConstants.Font_size_dates,CalenderConstants.Font_boxNames/*,TextFormatAlign.LEFT*/);
			this.addChild(dateTitle);
			
			/*
			contentInterface = new CelenderBoxContent(Width-20,Height-20);
			this.addChild(contentInterface);
			contentInterface.x = 10 ;
			contentInterface.y = 10 ;*/
			
			dateTitle.width = W ;
			dateTitle.height = H ;
			
			/*dateTitle.x = padding ;
			dateTitle.y = padding ;*/
			
			dateTitle.text = data.title;
			
			//TextPutter.onStaticArea(dateTitle,id,true,true,false);
			
			this.addChild(dateTitle);
			
			
			this.buttonMode = true ;
			this.mouseEnabled = true ;
			this.mouseChildren = false ;
			this.addEventListener(MouseEvent.CLICK,calBoxSelected);
		}
		
		
		public function show( delay:uint = 0 )
		{
			if(!CalenderConstants.Debug_instantShow)
			{
				this.alpha = 0 ;
				
				myDelay = delay ;
				canselTimer();
				
				myTimer = new Timer(delay,1);
				myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,showMe);
				myTimer.start();
				
				this.addEventListener(Event.REMOVED_FROM_STAGE,canselTimer);
			}
		}
		
			protected function showMe(event:TimerEvent):void
			{
				// TODO Auto-generated method stub
				AnimData.fadeIn(this);
			}
		
		public function get showSpeed():Number
		{
			return myDelay ;
		}
		
		public function hide(delay:int = -1)
		{
			if(CalenderConstants.Debug_instantShow)
			{
				Obj.remove(this);
				return ;
			}
			canselTimer();
			if(delay < 0)
			{
				delay = myDelay;
			}
			
			
			myTimer = new Timer(delay,1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,hideMe);
			myTimer.start();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,canselTimer);
		}
		
		protected function hideMe(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			myTimer.reset();
			AnimData.fadeOut(this,deleteMe);
		}
		
		private function deleteMe()
		{
			Obj.remove(this);
		}
		
		/**Cansel timer*/
		private function canselTimer(e=null)
		{
			if(myTimer != null)
			{
				myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,showMe);
				myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,hideMe);
				myTimer.reset();
				myTimer = null ;
			}
		}
		
		
		
		
		
		
		
		/**clear old calender datas and show these calender data on it*/
		public function addContents(calenderContent:CalenderContents)
		{
			//clear
			
			
			cahsedContents = calenderContent ;
			
			
			if(contentMask!=null)
			{
				contentMask.graphics.clear();
				this.removeChild(contentMask);
				contentMask = null ;
				
				this.removeChild(contentInterface);
				contentInterface = null ;
			}
			
			if(calenderContent.contents.length == 0)
			{
				return ;
			}
			
			contentMask = new MovieClip();
			this.addChild(contentMask);
			contentMask.x = maskPadding ;
			contentMask.y = maskPaddingT ;
			contentMask.graphics.beginFill(0) ;
			contentMask.graphics.drawRoundRect( 0 , 0 , Width-maskPadding*2 , Height-maskPadding-maskPaddingT ,ellipse ) ;
			
			contentInterface = new CelenderBoxContent(Width-maskPadding*2,Height-maskPadding-maskPaddingT,cahsedContents);
			this.addChild(contentInterface);
			contentInterface.x = maskPadding;
			contentInterface.y = maskPaddingT ;
			
			if(CalenderConstants.maskAvailable)
			{
				contentInterface.mask = contentMask ;
			}
			else
			{
				contentMask.visible = false ;
			}
			
			this.addChild(dateTitle);
		}
		
		protected function calBoxSelected(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace('show calender data now');
			
			this.dispatchEvent(new CalenderEvent(CalenderEvent.DATE_SELECTED,cahsedContents,data.Mdate,data.to));
		}		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		override public function get width():Number
		{
			return Width ;
		}
		
		override public function set width(value:Number):void
		{
			//nothing happends
		}
		
		
		
		override public function get height():Number
		{
			return Height ;
		}
		
		override public function set height(value:Number):void
		{
			//nothing happends
		}
		
		
	}
}