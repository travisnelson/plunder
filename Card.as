package  {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.events.Event;
  import flash.utils.getDefinitionByName;

	public class Card extends Sprite {
		// Constants:
		// Public Properties:
		// Private Properties:
		private var ID:CardID;
		private var _selected:Boolean=false;
		private var ants:Ants;
	
	
		// Initialization:
		
		public function Card(id:CardID, whichSym:String, num:int) {
			ID=id;
			
			var cBase:cardBase=new cardBase();			
			var cardClass=getDefinitionByName("mc_"+whichSym) as Class;
			var sym:Array=new Array();
			var spacing:int=8;

			if(num==1){
				sym[0]=new cardClass();
				sym[0].x=cBase.width/2;
				sym[0].y=cBase.height/2;
				cBase.addChild(sym[0]);
			} else if(num==2){
				sym[0]=new cardClass();
				sym[0].x=(cBase.width/3)-spacing;
				sym[0].y=cBase.height/2;
				cBase.addChild(sym[0]);
				sym[1]=new cardClass();
				sym[1].x=(cBase.width/3*2)+spacing;
				sym[1].y=cBase.height/2;
				cBase.addChild(sym[1]);
			} else if(num==3){
				sym[0]=new cardClass();
				sym[0].x=cBase.width/2;
				sym[0].y=cBase.height/2;
				cBase.addChild(sym[0]);
				sym[1]=new cardClass();
				sym[1].x=(cBase.width/4)-spacing;
				sym[1].y=cBase.height/2;
				cBase.addChild(sym[1]);
				sym[2]=new cardClass();
				sym[2].x=(cBase.width/4*3)+spacing;
				sym[2].y=cBase.height/2;
				cBase.addChild(sym[2]);				
			}

			addChild(cBase);
			addEventListener(MouseEvent.MOUSE_DOWN, select);
		}
	
		// Public Methods:
		public function get cardID():CardID{
			return ID;
		}
		
		
		public function get selected():Boolean{
			return _selected;
		}
		public function set selected(b:Boolean){
			if(!b){
				if(ants!=null){
					removeChild(ants);
					ants=null;
				}
			} else {
				ants=new Ants();
				addChild(ants);
			}

			_selected=b;
		}
		
		override public function toString():String{
			return ID.toString();
		}
		public function dataString():String {
			return ID.dataString();
		}
		
		// Event handlers:
		public function select(event:MouseEvent){
			if(!selected){
				selected=true;
				dispatchEvent(new Event("cardSelected"));
			} else {
				selected=false;
				dispatchEvent(new Event("cardUnselected"));
			}
		}
		
		
		
		
		// Protected Methods:
	}
	
}