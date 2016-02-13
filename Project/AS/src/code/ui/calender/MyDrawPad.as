package code.ui.calender
	//code.ui.calender.MyDrawPad
{
	import drawPad.Paper;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MyDrawPad extends MovieClip
	{
		private var myPaper:Paper ;
		
		public function MyDrawPad()
		{
			super();
			
			myPaper = new Paper(0xff00ff,null,null,this.getBounds(this));
			this.addChild(myPaper);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDrawStarted);
			this.addEventListener(Event.REMOVED_FROM_STAGE,clearDrawing);
		}
		
 		
		protected function onDrawStarted(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			myPaper.startDraw(0x002200,5,this.mouseX,this.mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDrawing);
			this.addEventListener(Event.ENTER_FRAME,drawing);
		}
		
		protected function drawing(event:Event):void
		{
			// TODO Auto-generated method stub
			myPaper.lineTo(this.mouseX,this.mouseY);
		}
		
		protected function stopDrawing(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			myPaper.stopDraw();
			
			clearDrawing();
		}
		
		private function clearDrawing(e:*=null):void
		{
			// TODO Auto Generated method stub
			
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDrawing);
			this.removeEventListener(Event.ENTER_FRAME,drawing);
		}
	}
} 