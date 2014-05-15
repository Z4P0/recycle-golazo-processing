/*
  Recycle Goal
*/

String titleText = "RECYCLE GOLAZO";
String description = "Practice your skills while saving the world";


// levels
int[] level = { 1, 2, 3, 4 };

// level strings
String[] difficultyStrings = {
  "Beginner",
  "Amateur",
  "Semi-Pro",
  "Legend"
};

// level goals
int[] goals = { 5, 5, 3, 3 };

// level time limits
int[] limits = { 8, 5, 3, 2 };






// app settings
int _w = 960;
int _h = 480;
int centerX;
int centerY;
int em = 16;

// app states
/*
0 - start screen
1 - progress screen
2 - game screen - where we countdown
3 - summary screen
*/
int state = 0;


// button things
int btnWidth = 120;
int btnHeight = 40;


// color / img bkgd 
color bkgdColor = color(39, 174, 96);


// font stuff
PFont f;



// timer things
// ---------------
boolean countdownStarted = false;
float timer = 0;
float loadingTime = 10;
float levelTime;

void resetTimer() {
  timer = 0;
}







void setup() {
  size(_w, _h);
  centerX = _w / 2;
  centerY = _h / 2;
  
  noStroke();
  background(bkgdColor);
  
  
  f = createFont("Helvetica", 16, true); // Arial, 16 point, anti-aliasing on
}




















// let's do it
// =======================
void draw() { 

  if (state == 0) startScreen();
  if (state == 1) levelScreen();
  if (state == 2) loadingScreen();
  if (state == 3) gameScreen();
  if (state == 4) summaryScreen();
}
























// START SCREEN
// =======================


boolean startBtn_daemon = false;


void startScreen(){
  
  background(bkgdColor);
  title(); // recycle golazo
  
  // description
  fill(255);
  textAlign(CENTER);
  textFont(f, 1.25*em);
  text(description, centerX, centerY - centerY/10);

  startBtn_daemon = new btn(f, "Start", centerX - btnWidth/2, centerY + btnHeight/2, btnWidth, btnHeight, em, 75, 225, true).listen();
}












// level screen
// ===================================

int currentLevel = 0;
int selectedLevel = 0;

// button daemons
boolean[] level_daemon = new boolean[4];




void levelScreen(){
  // basics
  background(bkgdColor);
  title();

  
  // show progress bar
  progressBar();

  
  
  // draw buttons
  //----------------
  
  // position the buttons
  float margin = 1.5*em;
  // center the buttons
  int buttonsWidth = btnWidth * level.length;
  float marginSpace = margin * (level.length - 1);
  int totalSpace = int(buttonsWidth + marginSpace);
  int x = (width - totalSpace) / 2;
  
  // button colors
  int idleColor = 150;
  int activeColor = 250;
  int fontColor = 50;
  
  for(int i = 0; i < level.length; i++) {
    // only certin buttons active
    if (i <= currentLevel) {
      level_daemon[i] = new btn(f, difficultyStrings[i], x, centerY + 2*em, btnWidth, btnHeight, em, fontColor, activeColor, true).listen();
    } else {
      new btn(f, difficultyStrings[i], x, centerY + 2*em, btnWidth, btnHeight, em, fontColor, idleColor, false).listen();
    }

    x += margin + btnWidth;
  }
}





void progressBar() {
  // draw faded bkgd
  fill(color(175));
  float bar_w = ((btnWidth + 1.5 * em) * level.length) - 1.5;
  rect((width - bar_w) / 2, centerY, bar_w, em / 2);
  
  // draw color indicator
  float ratio = bar_w / level.length;
  fill(color(225));
  rect((width - bar_w) / 2, centerY, ratio * level[currentLevel], em / 2);
}

void pickLevel(int index) {
  selectedLevel = index;
  resetTimer();
  state++;
}























void loadingScreen(){

  background(bkgdColor);
   
  // "Make 5 cans in 40 seconds!"  
  String feedbackText = "Make " + goals[selectedLevel] + " cans in " + limits[selectedLevel] + " seconds!";

  fill(250);
  textFont(f, 2*em);
  text(feedbackText, centerX, centerY - 2*em);
  
  countdown();

  println(timer);
  if (timer / 100000 > loadingTime) {
    resetTimer();
    state++;
  }
}


void countdown() {
  // [bad synth riff]
  timer += millis();
  
  textAlign(CENTER);
  text(String.format("%.2f", timer), centerX, centerY);
}













// Game screen
// =================


int currentGoals = 0;
void gameScreen(){
  background(bkgdColor);
  
  // countdown
  text("gooall", centerX, centerY);
}















void summaryScreen(){
  background(bkgdColor);
}






void mousePressed() {
  
  
  if (state == 0) {
    if (startBtn_daemon) state++;
  }


  if (state == 1) {
    for(int i = 0; i < level_daemon.length; i++) {
      if (level_daemon[i]) {
        println(difficultyStrings[i]);
        pickLevel(i);
      }
    }
  }

  
  if (state == 2) {
    
  }
  
  
}






void keyPressed() {
  println("pressed " + int(key) + " " + keyCode);
  
  if (state == 0) {
    if (int(key) == 10) state++;
  }
  
  if (state == 1) {
    if (int(key) == 49) {
      pickLevel(0);
    }
    if (int(key) == 50) {
      if (currentLevel <= 1) pickLevel(1);
    }
    if (int(key) == 51) {
      if (currentLevel <= 2) pickLevel(2);
    }
    if (int(key) == 52) {
      if (currentLevel <= 3) pickLevel(3);
    }
  }
  
}

void keyTyped() {
  println("typed " + int(key) + " " + keyCode);
}

void keyReleased() {
  println("released " + int(key) + " " + keyCode);
}























// generic, all-around things
// -------------------------

void title() {
  fill(255);
  textAlign(CENTER);
  
  // title
  textFont(f, 3*em); // 3em
  text(titleText, centerX, centerY - centerY/4);
}








class btn {
  int bkgd;
  String btn_text;
  int btn_x, btn_y;
  int btn_w, btn_h;
  PFont btn_font;
  int btn_fz;
  int btn_fColor, btn_bgColor;
  boolean btn_active;
  
  btn(PFont _f, String text, int x, int y, int w, int h, int fz, int fontColor, int _bkgdColor, boolean active) {
    btn_font = _f;
    btn_text = text;
    bkgd = _bkgdColor;
    btn_x = x;
    btn_y = y;
    btn_w = w;
    btn_h = h;
    btn_fz = fz;
    btn_fColor = fontColor;
    btn_bgColor = _bkgdColor;
    btn_active = active;
  }
  
  boolean listen() {
    boolean hoverOver = false;
    
    // determine if hover state
    if (btn_active) {
      if (mouseX >= btn_x && mouseX <= btn_x + btn_w && mouseY >= btn_y && mouseY <= btn_y + btn_h) {
        bkgd -= bkgd / 14; // darken bkgd
        hoverOver = true;
      }
    }
    
    drawBtn();
    
    return hoverOver;
  }
  
  void drawBtn() {
    /* button background */
    // -------------
    fill(color(bkgd));
    rect(btn_x, btn_y, btn_w, btn_h);
  
  
    /* button text */
    // -------------
    // center align text, set font, color, & size, draw text
    fill(color(btn_fColor));
    textAlign(CENTER);
    textFont(btn_font, btn_fz);
    text(btn_text, btn_x + btn_w/2, btn_y + btn_fz*1.5);
  }
}

