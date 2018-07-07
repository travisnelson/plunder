package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
  import flash.events.TimerEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import com.kongregate.as3.client.KongregateAPI;	
	import com.kongregate.as3.client.events.KongregateEvent;
	
	public class Set extends MovieClip {
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var deck:Deck;
		private var table:Table;
		private var discard:Deck;

		private var gameTimer:Timer;
		private var kongregate:KongregateAPI

		private var foundSets:int=0;
		private var time:int=0;
		private var drawsUsed:int=0;
		private var hintsUsed:int=0;

		private var drawBtnDisabled:XedOut;
		private var hintBtnDisabled:XedOut;
		private var instructions:instructionsClass;
		private var winSet:Array;
		private var finalScore:finalScoreClass;
		private var highscores:highscoreClass;

		private var preloadingFinished:Boolean=false;

		private var soundsOn:Boolean=true;
		private var bellSound:bellSoundT;
		private var bellsSound:bellsSoundT;
		private var cheerSound:cheerSoundT;
		private var buzzerSound:buzzerSoundT;
		
		// Initialization:
		public function Set() {
			// do preloading
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, preloader);			
			loaderInfo.addEventListener(Event.COMPLETE, preloaderFinished);
			
			kongregate = new KongregateAPI();
			addChild(kongregate);
	
			kongregate.addEventListener(KongregateEvent.COMPLETE, kongregateFinished);
			stop();
		}

		public function kongregateFinished(event:KongregateEvent){
			if(preloadingFinished)
				gotoAndPlay(2);
			else
				preloadingFinished=true;
		}

		public function preloaderFinished(event:Event){
			if(preloadingFinished)
				gotoAndPlay(2);
			else
				preloadingFinished=true;
		}

		public function preloader(event:ProgressEvent){
			var progress:Number=event.bytesLoaded / event.bytesTotal * 100;
			
			loaderBar.scaleX=progress/100;			
		}

		public function initGame(){
			deck=new Deck();
			deck.loadPirateDeck();
			discard=new Deck();	
			table=new Table(places);
			table.addEventListener("setSelected", checkSet);

			bellSound=new bellSoundT();
			bellsSound=new bellsSoundT();
			cheerSound=new cheerSoundT();
			buzzerSound=new buzzerSoundT();

			winSetPlace1.mouseEnabled=false;
			winSetPlace2.mouseEnabled=false;
			winSetPlace3.mouseEnabled=false;
		
			drawBtn.addEventListener(MouseEvent.MOUSE_DOWN, drawMore);
			resetBtn.addEventListener(MouseEvent.MOUSE_DOWN, resetGameHandler);	
			hintBtn.addEventListener(MouseEvent.MOUSE_DOWN, hintHandler);
			infoBtn.addEventListener(MouseEvent.MOUSE_DOWN, infoHandlerOn);
			table.addEventListener("updateDisplays", updateDisplaysHandler);
			scoresBtn.addEventListener(MouseEvent.MOUSE_DOWN, highscoresHandler);
			soundsBtn.addEventListener(MouseEvent.MOUSE_DOWN, soundsOnHandler);
			
			gameTimer=new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, updateTimer);
			gameTimer.start();

			kongregate.stats.submit("GameComplete", 0);
			kongregate.stats.submit("CompletedNoHints", 0);
			kongregate.stats.submit("CompletedNoDraws", 0);
 			kongregate.stats.submit("Score", -9999);
 			kongregate.stats.submit("Time", 9999);

			resetGame();
			gameTimer.stop();
			gotoInstructions();			
		}
	
		// Public Methods:		
		public function calculateScore():int{
			var score:int=0;
			
			score += foundSets * 10;
			score += hintsUsed * -5;
			score += drawsUsed * -5;
			score += int(time / -10);
			
			return score;
		}
		
		public function updateDisplays(){
			foundSetsDisplay.text=String(foundSets);
			cardsLeftDisplay.text=String(deck.nCards+table.nCards);
			timeDisplay.text=String(time);
			scoreDisplay.text=String(calculateScore());
			
			if((deck.nCards<3 || table.nCards>=18)){
				if(drawBtnDisabled==null){
					drawBtnDisabled=new XedOut();
					drawBtn.addChild(drawBtnDisabled);
				}
			} else {
				if(drawBtnDisabled!=null){
					drawBtn.removeChild(drawBtnDisabled);
					drawBtnDisabled=null;
				}
			}


			if(table.getSelected().length>0 || table.findSet()==null){
				if(hintBtnDisabled==null){
					hintBtnDisabled=new XedOut();
					hintBtn.addChild(hintBtnDisabled);
				}
			} else {
				if(hintBtnDisabled!=null){
					hintBtn.removeChild(hintBtnDisabled);
					hintBtnDisabled=null;
				}
			}
		}
		
		public function resetGame(){
			while(table.nCards)
				deck.push(table.pop());
			while(discard.nCards)
				deck.push(discard.pop());
			deck.shuffle();
			for(var i=0;i<12;++i){
				table.push(deck.pop());
			}
			foundSets=0;
			time=0;
			drawsUsed=0;
			hintsUsed=0;
			updateDisplays();
		}
		

		// Event handlers:
		public function updateTimer(event:TimerEvent){
			++time;
			updateDisplays();
		}
		
		public function turnOffWinShow(event:TimerEvent){
			winSetPlace1.removeChild(winSet[0]);
			winSetPlace2.removeChild(winSet[1]);
			winSetPlace3.removeChild(winSet[2]);

			winSet[0].selected=false;
			winSet[1].selected=false;
			winSet[2].selected=false;
		}
		
		public function checkSet(event:Event){
			if(table.checkSelectedSet()){
				++foundSets;
				winSet=table.getSelected();
				table.removeSelectedCards(discard);
				table.fillExtras();
				
				winSetPlace1.addChild(winSet[0]);
				winSetPlace2.addChild(winSet[1]);
				winSetPlace3.addChild(winSet[2]);
				
				var winShowTimer:Timer=new Timer(500, 1);
				winShowTimer.addEventListener(TimerEvent.TIMER, turnOffWinShow);
				winShowTimer.start();
				winShowTimer.start();
				
				if(table.nCards<12 && deck.nCards>=3){
					var cardIndices:Array=new Array(3);
					
					cardIndices[0]=table.push(deck.pop());
					cardIndices[1]=table.push(deck.pop());
					cardIndices[2]=table.push(deck.pop());

					var maxRedraw:int=int(deck.nCards/3);
					while(table.findSet()==null && --maxRedraw>0){
						deck.unshift(table.remove(cardIndices[0]));
						deck.unshift(table.remove(cardIndices[1]));
						deck.unshift(table.remove(cardIndices[2]));
						
						cardIndices[0]=table.push(deck.pop());
						cardIndices[1]=table.push(deck.pop());
						cardIndices[2]=table.push(deck.pop());
					}					
				}
				
				if(soundsOn)
					bellsSound.play();
				
				if(deck.nCards==0 && table.findSet()==null){
					// winrar
					gameTimer.stop();
					if(soundsOn)
						cheerSound.play();
					
					kongregate.stats.submit("GameComplete", 1);
					if(hintsUsed==0)
						kongregate.stats.submit("CompletedNoHints", 1);
					if(drawsUsed==0)
						kongregate.stats.submit("CompletedNoDraws", 1);
    			kongregate.stats.submit("Score", calculateScore());
    			kongregate.stats.submit("Time", time);
		
					finalScore=new finalScoreClass();
					finalScore.x=75.
					finalScore.y=120;
					finalScore.finalResetBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeFinalScore);
					finalScore.finalScoresBtn.addEventListener(MouseEvent.MOUSE_DOWN, finalHighscoresHandler);
					finalScore.finalScoreDisplay.text=String(calculateScore());
					addChild(finalScore);
				}
				
			} else {
				// fail
				if(soundsOn)
					buzzerSound.play();
			}
			
			table.unselectAll();
			updateDisplays();
		}

		public function closeFinalScore(event:MouseEvent){
			removeChild(finalScore);
			finalScore=null;
		}

		public function soundsOnHandler(event:MouseEvent){
			if(soundsOn){
				soundsDisplay.text="Sounds Off";
				soundsOn=false;
			} else {
				soundsDisplay.text="Sounds On";
				soundsOn=true;
			}
		}

		public function resetGameHandler(event:MouseEvent){
			if(finalScore){
				removeChild(finalScore);
				finalScore=null;
			}
			resetGame();
		}
		
		public function updateDisplaysHandler(event:Event){
			if(table.getSelected().length<3 && soundsOn)
				bellSound.play();
			updateDisplays();
		}

		public function gotoInstructions(){
			places.visible=false;
			instructions=new instructionsClass();
			instructions.Btn.addEventListener(MouseEvent.MOUSE_DOWN, infoHandlerOff);
			addChild(instructions);			
		}
	
		public function highscoreReturnHandler(event:MouseEvent){
			removeChild(highscores);
			highscores=null;
			places.visible=true;
		}
	
		public function scoresCallback(result:Object){
			if(!result.success){
				trace("score request failed");
				return;
			}
			
			highscores.scoreName1=result.list[0].username;
			highscores.scoreNum1=result.list[0].score;
			highscores.scoreName2=result.list[1].username;
			highscores.scoreNum2=result.list[1].score;
			highscores.scoreName3=result.list[2].username;
			highscores.scoreNum3=result.list[2].score;

			highscores.scoreName4=result.list[3].username;
			highscores.scoreNum4=result.list[3].score;
			highscores.scoreName5=result.list[4].username;
			highscores.scoreNum5=result.list[4].score;
			highscores.scoreName6=result.list[5].username;
			highscores.scoreNum6=result.list[5].score;
			highscores.scoreName7=result.list[6].username;
			highscores.scoreNum7=result.list[6].score;
			highscores.scoreName8=result.list[7].username;
			highscores.scoreNum8=result.list[7].score;
			highscores.scoreName9=result.list[8].username;
			highscores.scoreNum9=result.list[8].score;
			highscores.scoreName10=result.list[9].username;
			highscores.scoreNum10=result.list[9].score;
			highscores.scoreName11=result.list[10].username;
			highscores.scoreNum11=result.list[10].score;
			highscores.scoreName12=result.list[11].username;
			highscores.scoreNum12=result.list[11].score;
			highscores.scoreName13=result.list[12].username;
			highscores.scoreNum13=result.list[12].score;
			highscores.scoreName14=result.list[13].username;
			highscores.scoreNum14=result.list[13].score;
			highscores.scoreName15=result.list[14].username;
			highscores.scoreNum15=result.list[14].score;
		}
	
		public function finalHighscoresHandler(event:MouseEvent){
			removeChild(finalScore);
			finalScore=null;
			places.visible=false;
			highscores=new highscoreClass();
			highscores.highscoreReturnBtn.addEventListener(MouseEvent.MOUSE_DOWN, highscoreReturnHandler);

			addChild(highscores);			
//			kongregate.scores.requestList(scoresCallback);
		}
	
		public function highscoresHandler(event:MouseEvent){
			places.visible=false;
			highscores=new highscoreClass();
			highscores.highscoreReturnBtn.addEventListener(MouseEvent.MOUSE_DOWN, highscoreReturnHandler);

			addChild(highscores);
//			kongregate.scores.requestList(scoresCallback);
		}

		public function infoHandlerOn(event:MouseEvent){
			gotoInstructions();
			instructions.playBtnDisplay.text="Return";
		}
		public function infoHandlerOff(event:MouseEvent){
			removeChild(instructions);
			instructions=null;
			places.visible=true;
			gameTimer.start();
		}


		public function hintHandler(event:MouseEvent){
			var setCards:Array;

			if((setCards=table.findSet())!=null && hintBtnDisabled==null){
				setCards[0].selected=true;
//				setCards[1].selected=true;
//				setCards[2].selected=true;

				hintsUsed++;
				updateDisplays();
			}
		}

		public function drawMore(event:MouseEvent){
			if(deck.nCards>=3 && table.nCards<=15 && drawBtnDisabled==null){
				table.push(deck.pop());
				table.push(deck.pop());
				table.push(deck.pop());
				drawsUsed++;
			}
			updateDisplays();
		}
		
		// Protected Methods:
	}
	
}