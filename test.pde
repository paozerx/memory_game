int cols = 5;
int rows = 4;
int cardWidth = 50;
int cardHeight = 60;
int[][] cardFlipped = new int[rows][cols];  
int[][] cardValues = new int[rows][cols]; // Store card values
int firstCardX = -1, firstCardY = -1; // Store the first card's position
int secondCardX = -1, secondCardY = -1; // Store the second card's position
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
  
  // Initialize card values with random pairs
  initializeCardValues(); 
  shuffleCards(); // Shuffle the card values
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

  // Handle delay for mismatched cards
  if (waitingForSecondCard) {
    delayCounter++;
    if (delayCounter > 30) { // Show the cards for a short duration
      cardFlipped[firstCardY][firstCardX] = 0; // Flip back first card
      cardFlipped[secondCardY][secondCardX] = 0; // Flip back second card
      waitingForSecondCard = false; // Reset
      firstCardX = -1;
      firstCardY = -1;
      secondCardX = -1;
      secondCardY = -1;
      delayCounter = 0; // Reset delay counter
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
  if (waitingForSecondCard) return; // Ignore clicks while waiting for second card

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int x = j * (cardWidth + 10); 
      int y = i * (cardHeight + 10); 
      
      if (mouseX > x && mouseX < x + cardWidth && mouseY > y && mouseY < y + cardHeight) {
        if (cardFlipped[i][j] == 0) {
          cardFlipped[i][j] = 1; // Flip the card
          
          if (firstCardX == -1) {
            // First card flipped
            firstCardX = j;
            firstCardY = i;
          } else {
            // Second card flipped
            secondCardX = j;
            secondCardY = i;
            waitingForSecondCard = true;
            checkForMatch(); // Check if the cards match
          }
        }
      }
    }
  }
}

void checkForMatch() {
  // Check if the values of the first and second card match
  if (cardValues[firstCardY][firstCardX] == cardValues[secondCardY][secondCardX]) {
    // Cards match; remove them
    removeMatchedCards(firstCardY, firstCardX, secondCardY, secondCardX);
  } 
}

void removeMatchedCards(int y1, int x1, int y2, int x2) {
  // Set the matched cards as flipped permanently
  cardFlipped[y1][x1] = 2; // Mark as matched
  cardFlipped[y2][x2] = 2; // Mark as matched
  
  // Reset the card positions for the next turn
  firstCardX = -1; 
  firstCardY = -1; 
  secondCardX = -1;
  secondCardY = -1; 
  waitingForSecondCard = false; // Reset
}

void shuffleCards() {
  // Shuffle the card values
  int[] flatValues = new int[rows * cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      flatValues[i * cols + j] = cardValues[i][j];
    }
  }
  // Simple Fisher-Yates shuffle
  for (int i = flatValues.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = flatValues[i];
    flatValues[i] = flatValues[j];
    flatValues[j] = temp;
  }
  // Refill cardValues
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cardValues[i][j] = flatValues[i * cols + j];
    }
  }
}

void initializeCardValues() {
  // Create unique pairs for the card values
  int totalPairs = (rows * cols) / 2;
  int[] pairs = new int[totalPairs];
  
  for (int i = 0; i < totalPairs; i++) {
    pairs[i] = i + 1; // Create pairs 1 to totalPairs
  }
  
  // Fill cardValues with pairs
  int[] flatValues = new int[rows * cols];
  for (int i = 0; i < totalPairs; i++) {
    flatValues[i * 2] = pairs[i];      // Place first instance of the pair
    flatValues[i * 2 + 1] = pairs[i];  // Place second instance of the pair
  }
  
  // Fill cardValues 2D array
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cardValues[i][j] = flatValues[i * cols + j];
    }
  }
}
