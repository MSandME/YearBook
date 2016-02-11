package code.ui.calender
	//code.ui.calender.MainInterface
{
	import diagrams.calender.CalenderConstants;
	import diagrams.calender.MyShamsi;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class MainInterface extends MovieClip
	{
		private var dayName:TextField,
					day:TextField,
					monthName:TextField,
					yearTF:TextField;
		
		public function MainInterface()
		{
			super();
			
			dayName = Obj.get("day_name_txt",this);
			day = Obj.get("day_txt",this);
			monthName = Obj.get("month_txt",this);
			yearTF = Obj.get("year_txt",this);
			
			setDateInterface();
		}
		
		private function setDateInterface():void
		{
			// TODO Auto Generated method stub
			var miladiDate:Date = new Date() ;
			
			var shamsi:MyShamsi = MyShamsi.miladiToShamsi(miladiDate) ;
			dayName.text = UnicodeStatic.convert(CalenderConstants.dayNames[(miladiDate.day+2)%7],true) ;
			day.text = shamsi.date ;
			monthName.text = UnicodeStatic.convert(CalenderConstants.monthNames[shamsi.month]) ;
			yearTF.text = shamsi.fullYear ;
		}
	}
}