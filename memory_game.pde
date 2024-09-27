int cols = 5;
int rows = 4;
int cardWidth = 50;
int cardHeight = 60;
int[][] cardFlipped = new int[rows][cols];  
int[][] cardValues = {
  {1, 2, 3, 4, 5},
  {1, 2, 3, 4, 5},
  {6, 7, 8, 9, 10},
  {6, 7, 8, 9, 10}
}; 
int firstCardX = -1, firstCardY = -1;
int secondCardX = -1, secondCardY = -1; 
boolean waitingForSecondCard = false;
int delayCounter = 0;

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
