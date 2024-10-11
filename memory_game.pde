//Supawit Sukdang 6601012610164
//multiplayer
//hint 
//timer 
boolean devMode = false;
boolean firstCardOpen = false;
int countCardRemove = 0;
int cols = 5;
int rows;
int location = 0;
int sec = 10;
int cardWidth = 80;
int cardHeight = 60;
String turn_current= "1";
int score_1 = 0;
int score_2 = 0;
int[][] cardFlipped;
int[][] cardValues = {
  {1, 3, 2, 5, 4},
  {2, 1, 4, 3, 5},
  {7, 9, 8, 10, 6},
  {9, 7, 10, 8, 6},
  {11, 13, 15, 12, 14},
  {13, 11, 12, 15, 14},
  {17, 20, 19, 16, 18},
  {20, 17, 18, 19, 16}
}
;

int[][] cardValues2p = {
  {1, 2, 3, 4, 5},
  {1, 2, 3, 4, 5},
  {1, 2, 3, 4, 5},
  {1, 2, 3, 4, 5},
}; 
int firstCardX = -1, firstCardY = -1;
int secondCardX = -1, secondCardY = -1; 
boolean waitingForSecondCard = false;
int delayCounter = 0;
boolean playGame = false;
int u = 160;
int v = 100;
int o = 0;

void setup() {  
  size(450, 800); 
  background(255); 
  smooth();
  frameRate(30); 
  strokeWeight(1); 
  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  if(countCardRemove != (rows*cols)/2 && playGame){
  delayCounter++;
    if (delayCounter > 60){ 
      timer();
      delayCounter = 0;}
  background(255);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int x = j * (cardWidth + 10); 
      int y = i * (cardHeight + 10);  
      if (cardFlipped[i][j] == 0 ) {
        flipCard(x, y, cardValues[i][j]); 
      } else if (cardFlipped[i][j] == 1) {
           memoryGame(x, y, cardValues[i][j]); 
    }
    }}
  fill(0);
  text("Turn: Player ", 80, 640);
  text(turn_current, 150, 640);
  
  text("Timer:  ", 80, 670);
  text(sec, 120,670);
  
  hintGame();

  
  text("Score: Player 1: ", 320, 640);
  text(score_1, 395, 640);
  
  text("Score: Player 2: ", 320, 670);
  text(score_2, 395, 670);
  }
  else if(!playGame) {
  background(255);
  for(int p = 0; p < 300 ;p = p+60){
    gameMode(u,v+p ,p);
    o = o + 60;
  }if(devMode){
    text("DevMode Open",218,450);}
  
  }
  else if(countCardRemove == (rows*cols)/2 && playGame){
    checkGamePlaying();
  }
 

  if (waitingForSecondCard) {
    delayCounter++;
    if (delayCounter > 30) { 
      if (firstCardX != -1 && firstCardY != -1 && secondCardX != -1 && secondCardY != -1) {
        cardFlipped[firstCardY][firstCardX] = 0;
        cardFlipped[secondCardY][secondCardX] = 0;
      }
      firstCardX = -1;
      firstCardY = -1;
      secondCardX = -1;
      secondCardY = -1;
      waitingForSecondCard = false;
      delayCounter = 0;
    }
  }
}
void timer(){
    sec = sec - 1;
    if(sec == 0){
     for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if(cardFlipped[i][j] == 1 && firstCardOpen){
          cardFlipped[i][j] = 0;
          firstCardX = -1;
          firstCardY = -1;
          
        }
      }}
      if(turn_current == "1"){
        turn_current = "2";
        sec = 10;
      }
      else if(turn_current == "2"){
        turn_current = "1";
        sec = 10;
      }
    }
}





void hintGame(){
  if(sec <= 5 && firstCardOpen){
    text("Hint: Maybe have card in column", 190, 600);
    text(location, 350, 600);
  }
}

void hintLocate(int value,int r,int c){
  for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if(cardValues[i][j]==value){
          if(i==r && j==c){
            continue;
          }
          location = j+1;
        }
      }}
  
}

void gameMode(int u,int v,int p){
  // x=80,200 y=50,100 
  line(u, v,u+120, v);  
  line(u, v, u, v+50);  
  line(u+120, v, u+120,v+50);  
  line(u, v+50,u+120, v+50); 
  if (p == 0){
  fill(0); 
  text("Easy", u+60, v+25);
  }
  else if (p == 60){
  fill(0); 
  text("Nomal", u+60, v+25);
  }
  else if (p == 120){
  fill(0); 
  text("Hard", u+60, v+25);
  }
  else if (p == 180){
  fill(0); 
  text("2 pairs", u+60, v+25);
  }
  else if (p == 240){
  fill(0); 
  text("DevMode", u+60, v+25);
  }
}

void memoryGame(int x, int y, int number) {
  line(x, y, x + cardWidth, y);  
  line(x, y, x, y + cardHeight);  
  line(x + cardWidth, y, x + cardWidth, y + cardHeight);  
  line(x, y + cardHeight, x + cardWidth, y + cardHeight);  
  
  fill(0);  
  text(number, x + cardWidth / 2, y + cardHeight / 2);
}

void flipCard(int x, int y, int value) {
  if(devMode){
    fill(150); 
    rect(x, y, cardWidth, cardHeight);
    textSize(20);
    fill(0, 408, 612);
    text(value,x+10,y+10);
    
  }else{
  fill(150); 
  rect(x, y, cardWidth, cardHeight);}
}

void mousePressed() {
  if(playGame){
    if (waitingForSecondCard) return; 
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int x = j * (cardWidth + 10); 
        int y = i * (cardHeight + 10); 
        if (mouseX > x && mouseX < x + cardWidth && mouseY > y && mouseY < y + cardHeight) {
          if (cardFlipped[i][j] == 0) {
            cardFlipped[i][j] = 1;       
            if (firstCardX == -1) {
              firstCardX = j;
              firstCardY = i;
              hintLocate(cardValues[i][j],i,j);
              firstCardOpen = true;
            } else {
              secondCardX = j;
              secondCardY = i;
              waitingForSecondCard = true;
              firstCardOpen = false;
              checkForMatch(); 
            }
          }
        }
      }
    }
  }
  else{
    
    if (mouseX > u && mouseX < u + 120 && mouseY > v  && mouseY < v + 50){
    playGame = true;
     rows = rows+2;
     
    }
     else if (mouseX > u && mouseX < u + 120 && mouseY > v+60  && mouseY < v + 50+60){
        playGame = true;
        rows = rows+4;
         
         
     }
     else if (mouseX > u && mouseX < u + 120 && mouseY > v+120  && mouseY < v + 50+120){
        playGame = true;
        rows = rows+8;
        
        
     }
     else if (mouseX > u && mouseX < u + 120 && mouseY > v+180  && mouseY < v + 50+180){
        playGame = true;
        rows = rows+4;
        cardValues =  cardValues2p ;
     }
     else if (mouseX > u && mouseX < u + 120 && mouseY > v+240  && mouseY < v + 50+240){
       if(devMode){
        devMode = false;}
        else{
          devMode = true;
        }
     }
     cardFlipped = new int[rows][cols];
  }}
  
void checkGamePlaying(){
  if(score_1 > score_2){
    text("Player 1 Win!!!!",230,250);
  }
  else if(score_1 < score_2){
    text("Player 2 Win!!!!",230,250);
  }
  else if(score_1 == score_2){
    text("Two Player No One Win",230,250);
  }
}
void checkForMatch() {
  if (firstCardX != -1 && firstCardY != -1 && secondCardX != -1 && secondCardY != -1) {
    if (cardValues[firstCardY][firstCardX] == cardValues[secondCardY][secondCardX]) {
      removeMatchedCards(firstCardY, firstCardX, secondCardY, secondCardX);
      countCardRemove = countCardRemove + 1;
      if(turn_current == "1"){
        score_1 = score_1 + 1;
        turn_current = "2";
        sec = 10;
      }
      else if(turn_current == "2"){
        score_2 = score_2 + 1;
        turn_current = "1";
        sec = 10;
      }
    } else {
      waitingForSecondCard = true;
      delayCounter = 0;
    }
  }
}


void removeMatchedCards(int y1, int x1, int y2, int x2) {
  cardFlipped[y1][x1] = 2; 
  cardFlipped[y2][x2] = 2;
  firstCardX = -1; 
  firstCardY = -1; 
  secondCardX = -1;
  secondCardY = -1; 
  waitingForSecondCard = false; 
}
