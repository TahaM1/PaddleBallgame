import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
AudioPlayer bounce;
AudioPlayer dirt;

//variables 
//ArrayList<PVector> balls = new ArrayList<PVector>();
ArrayList<Box> boxList = new ArrayList<Box>();
ArrayList<Button> buttonList = new ArrayList<Button>();
PVector mouse, pmouse, bPos, bVel, bSiz, boxSiz, pPos, pDir, pSiz, grav;
float timer, buffer;
PImage block, background;
int numChecks, gameScreen, score, lives;
Button startButton, controlsButton, timedButton, livesButton ;

void setup(){
  size(800, 600);
//fullScreen();
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  gameScreen = 0;
  minim = new Minim(this);
  player = minim.loadFile("mineoddity.mp3"); //loads background music
  player.setGain(-20); //lowers volume
  bounce = minim.loadFile("bounce.wav"); //loads bounce sound effect
  dirt = minim.loadFile("dirt.mp3"); // loads dirt breaking sound effect
  dirt.setGain(40); //increases volume
  //creates buttons for menus
    startButton = new Button(new PVector(width/2,height/2), new PVector(100,40), "START", 0, 3);
    controlsButton = new Button(new PVector(width/2,height/1.5), new PVector(100,40), "CONTROLS", 0, 2);
    livesButton = new Button(new PVector(width/2,height/2 - 40), new PVector(100,40), "LIVES", 3, 1);
    timedButton = new Button(new PVector(width/2,height/1.5 +40), new PVector(100,40), "TIMED", 3, 4);
  //adds buttons to list
    buttonList.add(startButton);
    buttonList.add(controlsButton);
    buttonList.add(timedButton);
    buttonList.add(livesButton);
    
  reset();
  
}

void draw(){
  
  //Main menu
  if(gameScreen == 0){
    background(50);
    fill(255);
    textSize(40);
    text("Mining Away", width/2, height/4); 
    drawButtons();
      
  }
  
  //game over screen
  if(gameScreen == 5){
    background(50);
    fill(255);
    textSize(40);
    text("Game Over!", width/2, height/4);
    text("Your score was: " + score, width/2, height/3);
    textSize(20);
    text("Click anywhere on the screen to go to the menu", width/2, height/2);
    //goes back to main menu and resets variables
    if(mousePressed){
      gameScreen = 0;
      reset();
    }
  }
  
  //screen for selecting gamemodes
  if(gameScreen == 3){
     background(50);
     fill(255);
     textSize(40);
     text("Game Modes", width/2, height/4);
    
    drawButtons();
    
  }
  
  //controls screen
  if(gameScreen == 2){
    background(50);
    textSize(50);
    fill(255);
    text("CONTROLS", width/2, height/6);
    textSize(15);
    text("mouse: moves the paddle", width/2, height/3 );
    text("mouse RightClick: rotates the paddle clockwise", width/2, height/3 + 50);
    text("mouse LeftClick: rotates the paddle counter-clockwise", width/2, height/3 + 100);
    text("mouse ScrollWheelClick: sets paddle back to 90 degrees", width/2, height/3 + 150);
    text("RIGHT click on the screen to return to the main menu", width/2, height/3 + 300);
    //goes to main menu if right click is pressed
    if(mousePressed && mouseButton == RIGHT){
      gameScreen = 0;
    }
    
  }
  
  if(gameScreen == 1 || gameScreen == 4){
    //loops the song mine oddity until gameScreen changes
    if(!player.isLooping()){
      //player.setGain(-10);
      player.loop();
    }
 
    //update 
    mouse = new PVector(mouseX, mouseY);
    pmouse = new PVector(pmouseX, pmouseY);
    image(background, width/2, height/2); //sets image to the background
    //ball
      bVel.add(grav);
      bPos.add(bVel);
    //boxes
      updateBoxes(boxList);
      timer--;
    //paddle
      pPos = new PVector(mouse.x, mouse.y);
      //rotates paddle when mouse buttons are clicked
      if(mousePressed){
        if(mouseButton == LEFT){
          if(pDir.y > -0.35){ //stops the paddle from rotating over a certain amount
            pDir.rotate(-0.02);
          }
          
          
        }
        if(mouseButton == RIGHT){
          if(pDir.y < 0.35){ 
            pDir.rotate(0.02);
          }
          
          
        }
        if(mouseButton == CENTER){ //paddle is back at 90 degrees
          pDir.set(1, 0);
        }
      }
      //constrains paddle to the screen by reseting position 
       if(pPos.x > width - pSiz.x/2){
         pPos.x = width - pSiz.x/2;
       } else if (pPos.x < 0 + pSiz.x/2){
         pPos.x = 0 + pSiz.x/2;
       }
       if(pPos.y > height - pSiz.y/2){
         pPos.y = height - pSiz.y/2;
       } else if(pPos.y < 0 + pSiz.y/2){
         pPos.y = 0 + pSiz.y/2;
       }
       
  
  
  //check
    //ball box hit detect
      checkBoxes(boxList);
  
    //constrains ball by checking if off screen then reseting its position
    //also reverses velocity so it bounces off the sides
    if(bPos.x > width){
      bPos.x = width - bSiz.x/2; 
      bVel.x *= -0.9; // -0.9 is there to slow down the ball when it hits the sides
    } else if(bPos.x < 0){
      bPos.x = 0 + bSiz.x/2;
      bVel.x *= -0.9;
    }
    if(bPos.y > height){
      bPos.y = height - bSiz.y/2;
      bVel.y *= -0.9;
      
      score = 0; //resets score when ball hits the ground
      lives--; // takes away a life when ball hits ground 
    } else if(bPos.y < 0){
      bPos.y = 0 + bSiz.y/2;    
      bVel.y *= -0.9;
    }
    
    //checks if game is over based on what mode is being played
    if(gameScreen == 1 && lives <= 0){ //gameScreen 1 is lives mode
      gameScreen = 5;
    } else if(gameScreen == 4 && timer <= 0){ //gameScreen 4 is timed mode
      gameScreen = 5;
    }
    
    //spawns in a new box in a random position every 100 frames
    if(timer % 100 == 0){
      PVector boxPos = new PVector(random(boxSiz.x/2, width - boxSiz.x/2), boxSiz.x/2);
      boxList.add(new Box(boxPos, new PVector(0, 2), boxSiz, height/3, block));
      //list.addbox(boxPos, new PVector(0, 2), random(70, height/3));
    }
  
  //draw
  fill(0);
  textSize(20);
  //displays time or lives based on gamemode
  if(gameScreen == 1){
    text("Lives: " + lives, 100, 50);
  } else { 
    text("Timer: " + timer, 100, 50);
  }
  text("Score: " + score, width - 100, 50);
  stroke(1);
  drawBoxes(boxList);
  fill(255,255,255, 255);
  //draws ball
  ellipse(bPos.x, bPos.y, bSiz.x, bSiz.y);

  fill(0,255,255);
  drawPaddle();
    
  //paddle hit detection 
  for(int i = -numChecks/2; i <= numChecks/2; i++){
    //splits the paddle into 20 segments 
    float step = pSiz.x/numChecks;
    //creates pos vector for the ellipse of the each segment
    PVector temp = new PVector(pPos.x + i*step*pDir.x, pPos.y + i*step*pDir.y);
    fill(255,0,0, 0);
    noStroke();
    //ellipse used for hit detection 
    ellipse(temp.x, temp.y, 10, 10);
    if(temp.dist(bPos) < pSiz.y/2 + bSiz.y/2){ //if ball is close to paddle
      float angle = PVector.angleBetween(bVel, pDir);
      //change velocity to match how it reflects the paddle
      bVel.rotate(-2*angle);
      
      //increase velocity
      bVel.mult(1.2);
      //limit it so it doesnt go crazy
      bVel.limit(10);
      //play sound effect
        bounce.rewind();
        bounce.play();
      bPos.add(bVel);
      break;
    }
  }
  
 }
 
}


void mousePressed(){
  float buffer = 70;
  //check if buttons that are supposed to on the current gameScreen are being clicked on
  if(gameScreen != 1){
    for(Button button : buttonList){
      if(button.buttonPressed() && button.startScreen == gameScreen){
        gameScreen = button.endScreen;
         break;
      }
    }
    
  }
  
   // list.addBoxes(5):
   
}

void drawBoxes(ArrayList<Box> list){
//draws boxes in the list
  for(Box box : list){
      
      box.drawBox();
      
    }

}
void updateBoxes(ArrayList<Box> list){

 //update boxes
  
  for(int i = 0; i < list.size(); i++){
      
    list.get(i).updateBox(list);
    
    }

}

void checkBoxes(ArrayList<Box> list){
 for(int i = 0; i < list.size(); i++){
      //checks if they are being hit by the ball
    if(list.get(i). ballHitDetection(bPos, bSiz, bVel)){
      //play sound effect
      dirt.rewind();
      dirt.play();
      score++;
    }
    
 }
}

void drawPaddle(){
    //draw paddle with its rotation
    pushMatrix();
    translate(pPos.x, pPos.y);
    rotate(pDir.heading());
    rect(0, 0, pSiz.x, pSiz.y,8);
    popMatrix();

}


public void removeBoxes(PVector mouse, ArrayList<Box> groupOfBoxes){
       
    for(int i = 0; i < groupOfBoxes.size(); i++){
      if(mouse.x > groupOfBoxes.get(i).pos.x  - groupOfBoxes.get(i).siz.x/2 && mouse.x < groupOfBoxes.get(i).pos.x + groupOfBoxes.get(i).siz.x/2){
        println(groupOfBoxes.get(i).pos.x+ " " + groupOfBoxes.get(i).pos.y + " " + mouse.x + " " + mouse.y);
        if(mouse.y > groupOfBoxes.get(i).pos.y - groupOfBoxes.get(i).siz.y/2 && mouse.y < groupOfBoxes.get(i).pos.y + groupOfBoxes.get(i).siz.y/2){
          groupOfBoxes.remove(i);
          
        }
      }
      
    }
    
       
  }
  
void drawButtons(){
//draw button that go on this gameScreen
  for (Button button : buttonList){
    if(gameScreen == button.startScreen){
      button.drawButton();
    }
    
    
  }
  
}  
void reset(){
  boxList.clear(); //emptys box list
  bPos = new PVector(width/2, height/3); //ball position
  bVel = new PVector(5, 5); //ball speed
  bSiz = new PVector(25, 25); //ball size
  timer = 5000; //timer for timed mode
  buffer = 70; 
  boxSiz = new PVector(50, 50); // size of box
  block = loadImage("dirt.png"); // dirt block image
  background = loadImage("background.png"); //minecraft mining image
  background.resize(width, height + 150); // changing size of minecraft image
  pDir = new PVector(1, 0); //stores direction of the paddle and in used in hit detection along the paddle
  pSiz = new PVector(150, 20); // paddle size
  numChecks = 20;
  grav = new PVector(0, 0.2); //gravity
  score = 0;
  lives = 3;
}
