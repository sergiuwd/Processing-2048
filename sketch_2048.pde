int boardSize = 4;
int board[][] = new int[boardSize][boardSize];
int initialItemsNr = 4;
int rootNr = 2;
boolean moved = false;

void setup() {
  size(400, 400);
  reset();
}

void draw() {
  int cellWidth = width / boardSize;
  int cellHeight = height / boardSize;

  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[i].length; j++) {
      stroke(80);
      strokeWeight(2);
      fill(255);
      
      if (board[i][j] > 0) {
        // Cells that have a value
        int colorBias = board[i][j] * 2;
        if(colorBias > 255) {
          colorBias = 255;
        }
        fill(250, 250 - colorBias, 0);
        rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        textSize(28);
        if(colorBias < 125) {
          fill(80);
        } else {
          fill(255);
        }
        textAlign(CENTER, CENTER);
        text(board[i][j], i * cellWidth + cellWidth / 2, j * cellHeight + cellHeight / 2);
      } else {
        // Empty cells
        fill(250);
        rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
      }
    }
  }
  
  // Show the GAME OVER screen
  if(!canMove()) {
    fill(255, 150, 150, 240);
    rect(0, 0, width, height);
    fill(80);
    text("Game Over!", width / 2, 50);
    text("Your score: " + getScore(), width / 2, 100);
    textSize(20);
    fill(0);
    text("Press ENTER to start over", width / 2, height - 50);
  }
}

// Calculate the score
int getScore() {
  int score = 0;
  for(int i = 0; i < boardSize; i++) {
    for(int j = 0; j < boardSize; j++) {
      score += board[i][j];
    }
  }
  
  return score;
}

// Check if there are any available movements
boolean canMove() {
  boolean hasMoves = false;
  
  // Check if there are zeros
  for(int i = 0; i < boardSize; i++) {
    for(int j = 0; j < boardSize; j++) {
      if(board[i][j] == 0) {
        hasMoves = true;
      }
    }
  }
  
  // Check if there are combinations available
  for(int i = 0; i < boardSize; i++) {
    for(int j = 0; j < boardSize; j++) {
      // Check if it can combine
      if(j < boardSize - 1 && board[i][j] == board[i][j + 1] ||
         j > 0             && board[i][j] == board[i][j - 1] ||
         i > 0             && board[i][j] == board[i - 1][j] ||
         i < boardSize - 1 && board[i][j] == board[i + 1][j] ){
          hasMoves = true;
        }
    }
    
  }
  
  return hasMoves;
}

// Insert X random numbers in random cells
void insertRandom(int count) {
  for (int i = 0; i < count; i++) {
    int col = floor(random(boardSize));
    int row = floor(random(boardSize));

    if (board[row][col] == 0) {
      double exp = round(random(1, 2));
      board[row][col] = (int)Math.pow(rootNr, exp);
    } else {
      i--;
      continue;
    }
  }
}

// Reset the board
void reset() {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      board[i][j] = 0;
    }
  }

  insertRandom(initialItemsNr);
}

// Move existing numbers to the empty cells in the movement direction
int[] shift(int[] col) {
  int[] newCol = new int[boardSize];
  int index = boardSize - 1;
  
  // Do the shifting
  for (int j = boardSize -1; j >= 0; j--) {
    if (col[j] > 0) {
      newCol[index] = col[j];
      index--;
    }
  }
  
  // Check if moved
  for(int i = 0; i < boardSize; i++) {
    if(col[i] != newCol[i]) {
      moved = true;
    }
  }

  return newCol;
}

// Check if any 2 cells in an array can be combined and combine them
int[] combine(int[] arr) {
  int[] newCol = arr;
  for (int i = arr.length - 1; i > 0; i--) {
    if (arr[i] > 0 && arr[i] == arr[i - 1]) {
      arr[i] *= 2;
      arr[i - 1] = 0;
      moved = true;
    }
  }

  return newCol;
}

// Reverse an array of integers
int[] reverseArr(int[] arr) {
  int[] newArr = new int[arr.length];
  for(int i = 0; i < arr.length; i++) {
    newArr[arr.length - 1 - i] = arr[i];
  }
  
  return newArr;
}

// Shifts and combinations to be applied to a certain arr
int[] applyMovement(int[] arr) {
  arr = shift(arr);
  arr = combine(arr);
  arr = shift(arr);
  return arr;
}

void keyPressed() {
  moved = false;
  switch(keyCode) {
  case DOWN:
    for (int i = 0; i < boardSize; i++) {
      board[i] = applyMovement(board[i]);
    }
    break;
  case UP:
    for (int i = 0; i < boardSize; i++) {
      int[] newList = reverseArr(board[i]);
      newList = applyMovement(newList);
      board[i] = reverseArr(newList);
    }
    break;
  case RIGHT:
    for(int i = 0; i < boardSize; i++) {
      int[] row = new int[boardSize];
      for(int j = 0; j < boardSize; j++) {
        row[j] = board[j][i];
      }
      row = applyMovement(row);
      
      for(int j = 0; j < boardSize; j++) {
        board[j][i] = row[j];
      }
    }
    break;
  case LEFT:
    for(int i = 0; i < boardSize; i++) {
      int[] row = new int[boardSize];
      for(int j = 0; j < boardSize; j++) {
        row[j] = board[j][i];
      }
      row = reverseArr(row);
      row = applyMovement(row);
      row = reverseArr(row);
      
      for(int j = 0; j < boardSize; j++) {
        board[j][i] = row[j];
      }
    }
    break;
  case ENTER:
    if(!canMove()) {
      reset();
    }
  }

  if(moved) {
    insertRandom(1); 
  }
}