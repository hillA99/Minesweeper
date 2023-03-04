import de.bezier.guido.*;
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(625, 625);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS]; //first call to new makes apts
  for (int r = 0; r< NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c); //second call to new makes the objects
    }
  }


  setMines();
}
public void setMines()
{
  while (mines.size() < 100)
  {
    int r = (int)(Math.random()*25);
    int c = (int)(Math.random()*25);
    if (!mines.contains(buttons[r][c]))
    {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
        return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  buttons[12][8].setLabel("G");
  buttons[12][9].setLabel("A");
  buttons[12][10].setLabel("M");
  buttons[12][11].setLabel("E");
  buttons[12][12].setLabel(" ");
  buttons[12][13].setLabel("O");
  buttons[12][14].setLabel("V");
  buttons[12][15].setLabel("E");
  buttons[12][16].setLabel("R");
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
      if (mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
        buttons[r][c].mousePressed();
}

public void displayWinningMessage()
{
  buttons[12][9].setLabel("Y");
  buttons[12][10].setLabel("O");
  buttons[12][11].setLabel("U");
  buttons[12][12].setLabel(" ");
  buttons[12][13].setLabel("W");
  buttons[12][14].setLabel("I");
  buttons[12][15].setLabel("N");
  buttons[12][16].setLabel("!");
}
public boolean isValid(int r, int c)
{
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (i == 0 && j == 0)
        j+=1;
      if (isValid(row+i, col+j) && mines.contains(buttons[row + i][col + j]))
        numMines+=1;
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 625/NUM_COLS;
    height = 625/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow-1; r < myRow+2; r++) {
        for (int c = myCol-1; c < myCol+2; c++) {
          if (isValid(r, c) && buttons[r][c].clicked == false) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0,255,0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}

