package  {
	
	public class SetCardID extends CardID {		
		// Constants:
		private var numbers:Array=new Array("one", "two", "three");
		private var colors:Array=new Array("red", "purple", "green");
		private var shapes:Array=new Array("squiggle", "diamond", "oval");
		private var fills:Array=new Array("solid", "striped", "hollow");

		// Public Properties:
		// Private Properties:

		// Initialization:
		public function SetCardID(n:int, c:int, s:int, f:int) { 
			super(n,c,s,f);
		}
	
		// Public Methods:
		public function copy():SetCardID {
			return new SetCardID(val[0], val[1], val[2], val[3]);
		}

		override public function toString():String {
			return numbers[val[0]]+" "+colors[val[3]]+" "+shapes[val[1]]+" "+fills[val[2]];
		}

		// Protected Methods:
	}
	
}