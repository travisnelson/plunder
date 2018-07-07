package  {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Table extends Deck {
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var positions:Array;
	
		// Initialization:
		public function Table(p:Sprite) {
			super();
			
			positions=new Array(p.numChildren);

			for(var i:int=0;i<p.numChildren;++i){
				positions[i]=p.getChildAt(i);
			}
			
			cards.length=positions.length;			
		}
	
		// Public Methods:
		public function findSet():Array{
			for(var i=0;i<cards.length;++i){
				if(cards[i]==null)
					continue;
				for(var j=i+1;j<cards.length;++j){
					if(cards[j]==null)
						continue;
					for(var k=j+1;k<cards.length;++k){
						if(cards[k]==null)
							continue;
						if(checkSet(new Array(cards[i], cards[j], cards[k]))){
							return (new Array(cards[i], cards[j], cards[k]));
						}
					}
				}
			}
			return null;
		}		
		
		override public function get nCards():int {
			var count=0;
			
			for(var index=0;index<cards.length;++index){
				if(cards[index]!=null)
					++count;
			}
			return count;
		}
			
		override public function push(card:Card):int{
			var index:int;

			for(index=0;index<cards.length;++index){
				if(cards[index]==null){
					add(index, card);
					return index;
				}
			}

			throw new Error("Tried to push with no room left");
		}
		override public function pop():Card{
			for(var i=cards.length;i>=0;--i){
				if(cards[i]!=null)
					return remove(i)
			}
			return null;
		}
		
		public function remove(index:int):Card{
			if(index>=positions.length)
				throw new Error("Index out of bounds");
			if(cards[index]==null)
				throw new Error("Card doesn't exist at index");
				
			positions[index].removeChild(cards[index]);
			
			var card:Card=cards[index];
			cards[index]=null;
			card.removeEventListener("cardSelected", cardSelected);
			card.removeEventListener("cardUnselected", cardUnselected);
			return card;
		}

		public function add(index:int, card:Card){
			if(cards[index]!=null)
				throw new Error("Index position already occupied");
				
			positions[index].addChild(card);
			cards[index]=card;
			card.addEventListener("cardSelected", cardSelected);
			card.addEventListener("cardUnselected", cardUnselected);
		}

		public function unselectAll(){
			for(var i=0;i<cards.length;++i){
				if(cards[i]!=null)
					cards[i].selected=false;
			}
		}
		
		public function getSelected():Array {
			var selectedCards:Array=new Array();
			for(var i=0;i<cards.length;++i){
				if(cards[i]!=null && cards[i].selected){
					selectedCards.push(cards[i]);
				}
			}			
			return selectedCards;
		}
	
		public function removeSelectedCards(deck:Deck){
			for(var i=0;i<cards.length;++i){
				if(cards[i]!=null && cards[i].selected){
					deck.push(remove(i));
				}
			}
			
		}
		
		public function checkSet(selectedCards:Array):Boolean{
			return selectedCards[0].cardID.checkSet(selectedCards[1].cardID, selectedCards[2].cardID);
		}
		
		public function checkSelectedSet():Boolean{
			var selectedCards:Array=new Array();

			for(var i=0;i<cards.length;++i){
				if(cards[i]!=null && cards[i].selected){
					selectedCards.push(cards[i]);
				}
			}
			
			if(selectedCards.length!=3)
				throw new Error("didn't find 3 selected cards");
			
			
			return checkSet(selectedCards);		
		}

		public function fillExtras(){
			for(var i=0;i<cards.length;++i){
				if(cards[i]==null){
					for(var j=Math.max(i+1, 12);j<cards.length;++j){
						if(cards[j]!=null){
							add(i, remove(j));
							break;
						}
					}
				}
			}
		}

		// Event handlers:
		public function cardUnselected(event:Event){
			dispatchEvent(new Event("updateDisplays"));
		}
		
		public function cardSelected(event:Event){
			var count=0;
			
			for(var i=0;i<cards.length;++i){
				if(cards[i]!=null && cards[i].selected)
					count++;
			}
			
			dispatchEvent(new Event("updateDisplays"));
			
			if(count==3)
				dispatchEvent(new Event("setSelected"));
			
			if(count>3)
				throw new Error("More than 3 cards were selected");
		}
		
		// Protected Methods:
	}
	
}