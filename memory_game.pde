//Supawit Sukdang 6601012610164
//multiplayer
//hint 
//timer 
int cols = 5;
int rows;
int cardWidth = 25;
int cardHeight = 35;
int[][] cardFlipped ;  
int[][] cardValues = {
  {1, 2, 3, 4, 5},
  {1, 2, 3, 4, 5},
  {6, 7, 8, 9, 10},
  {6, 7, 8, 9, 10},
  {1, 2, 3, 4, 5},
  {1, 2, 3, 4, 5},
  {6, 7, 8, 9, 10},
  {6, 7, 8, 9, 10} 
};
int[][] cardValues_2 = {
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
int u = 80;
int v = 30;
int o = 0;

void setup() {  
  size(300, 300); 
  background(255); 
  smooth();
  frameRate(30); 
  strokeWeight(1); 
  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  if(playGame){ 
  background(255);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int x = j * (cardWidth + 10); 
      int y = i * (cardHeight + 10);  
      
      if (cardFlipped[i][j] == 0) {
        flipCard(x, y); 
      } else if (cardFlipped[i][j] == 1) {
        memoryGame(x, y, cardValues[i][j]);  
      }
    }
  }}
  else {
  background(255);
  for(int p = 0; p < 240 ;p = p+60){
    gameMode(u,v+p ,p);
    o = o + 60;
  }
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
}

void memoryGame(int x, int y, int number) {
  line(x, y, x + cardWidth, y);  
  line(x, y, x, y + cardHeight);  
  line(x + cardWidth, y, x + cardWidth, y + cardHeight);  
  line(x, y + cardHeight, x + cardWidth, y + cardHeight);  
  
  fill(0);  
  text(number, x + cardWidth / 2, y + cardHeight / 2);
}

void flipCard(int x, int y) {
  fill(150); 
  rect(x, y, cardWidth, cardHeight);
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
            } else {
              secondCardX = j;
              secondCardY = i;
              waitingForSecondCard = true;
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
        cardValues =  cardValues_2 ;
     }
     cardFlipped = new int[rows][cols];
  }}
  

void checkForMatch() {
  if (firstCardX != -1 && firstCardY != -1 && secondCardX != -1 && secondCardY != -1) {
    if (cardValues[firstCardY][firstCardX] == cardValues[secondCardY][secondCardX]) {
      removeMatchedCards(firstCardY, firstCardX, secondCardY, secondCardX);
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
