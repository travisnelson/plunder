package  {
	import flash.events.EventDispatcher;
	
	public class Deck extends EventDispatcher {
		
		// Constants:
		// Public Properties:
		// Private Properties:
		protected var cards:Array;
	
		// Initialization:
		public function Deck() { 
			cards=new Array();
		}
	
		// Public Methods:
		public function loadPirateDeck() {
			var id:PirateCardID=new PirateCardID(0,0,0,0);
			
			for(var i=0;i<81;++i){
				push(new Card(id.copy(), id.dataString(), id.number()));
				id.increment();
			}
		}		
		
		public function push(card:Card):int{
			cards.push(card);
			return cards.length-1;
		}

		public function unshift(card:Card){
			cards.unshift(card);
		}
		
		public function pop():Card{
			return cards.pop();
		}

		public function get nCards():int {
			return cards.length;
		}
	
		public function shuffle(){	
			var buf:Array = new Array();
 
			while (cards.length > 0) {
		    buf.push(cards.splice(Math.round(Math.random() * (cards.length-1)), 1)[0]);
			}
			cards=buf;
		}
			
		
		// Protected Methods:
	}
	
}