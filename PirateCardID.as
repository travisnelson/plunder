package  {
	
	public class PirateCardID extends CardID {		
		// Constants:
		private var numbers:Array=new Array("one", "two", "three");
		private var colors:Array=new Array("gold", "silver", "blood");
		private var shapes:Array=new Array("skull", "coin", "bottle");
		private var fills:Array=new Array("solid", "striped", "hollow");

		// Public Properties:
		// Private Properties:

		// Initialization:
		public function PirateCardID(n:int, c:int, s:int, f:int) { 
			super(n,c,s,f);
		}
	
		// Public Methods:
		public function copy():PirateCardID {
			return new PirateCardID(val[0], val[1], val[2], val[3]);
		}

		override public function toString():String {
			return numbers[val[0]]+" "+colors[val[3]]+" "+shapes[val[1]]+" "+fills[val[2]];
		}

		override public function dataString():String {
			return fills[val[2]]+"_"+colors[val[3]]+"_"+shapes[val[1]];
		}
		
		public function number():int {
			return val[0]+1;
		}
		

		// Protected Methods:
	}
	
}