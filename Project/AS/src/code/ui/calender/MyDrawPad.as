package code.ui.calender
	//code.ui.calender.MyDrawPad
{
	import drawPad.Paper;
	
	import flash.display.MovieClip;
	
	public class MyDrawPad extends MovieClip
	{
		private var myPaper:Paper ;
		
		public function MyDrawPad()
		{
			super();
			
			myPaper = new Paper(0xff00ff,null,null,this.getBounds(this));
			this.addChild(myPaper);
		}
	}
} 