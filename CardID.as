package  {
	
	public class CardID {
		// Constants:

		// Public Properties:
		// Private Properties:
		protected var val:Array;
	
		// Initialization:
		public function CardID(n:int, c:int, s:int, f:int){
			val=new Array(4);
			val[0]=n;
			val[1]=c;
			val[2]=s;
			val[3]=f;
		}
	
		// Public Methods:
		public function toString():String {
			return dataString();
		}
		public function dataString():String {
			return String(val[0])+String(val[1])+String(val[2])+String(val[3]);
		}

		public function increment():CardID{
			++val[0];
			
			if(val[0]==3){
				val[0]=0;
				++val[1];
				if(val[1]==3){
					val[1]=0;
					++val[2];
					if(val[2]==3){
						val[2]=0;
						++val[3];
						if(val[3]==3){
							val[3]=0;
						}
					}
				}
			}
			
			return this;
		}

		public function checkSet(card1:CardID, card2:CardID):Boolean{
			if(!(val[0]==card1.val[0] && val[0]==card2.val[0]) &&
				 !(val[0]!=card1.val[0] && val[0]!=card2.val[0] && card1.val[0]!=card2.val[0]))
				return false;
			if(!(val[1]==card1.val[1] && val[1]==card2.val[1]) &&
				 !(val[1]!=card1.val[1] && val[1]!=card2.val[1] && card1.val[1]!=card2.val[1]))
				return false;
			if(!(val[2]==card1.val[2] && val[2]==card2.val[2]) &&
				 !(val[2]!=card1.val[2] && val[2]!=card2.val[2] && card1.val[2]!=card2.val[2]))
				return false;
			if(!(val[3]==card1.val[3] && val[3]==card2.val[3]) &&
				 !(val[3]!=card1.val[3] && val[3]!=card2.val[3] && card1.val[3]!=card2.val[3]))
				return false;
				
			return true;
		}

	
		// Protected Methods:
	}
	
}