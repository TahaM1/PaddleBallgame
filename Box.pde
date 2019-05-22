class Box {

  public PVector pos, grav, siz, speed;
  public int transparency = 1000;
  boolean checked = false;
  float floor; //where the box stops at
  PImage block; //image
  
  Box(PVector pos, PVector speed){
   this(pos, speed, new PVector(50, 50), height);
  }
  
   Box(PVector pos, PVector speed, PVector size){
   this(pos, speed, size, height);
  }
  Box(PVector pos, PVector speed, PVector size, float floor){
   this(pos, speed, size, floor, null);
  }
  
  
  Box(PVector pos, PVector speed, PVector size, float floor, PImage block){
    
   this.pos = pos;
   this.grav = new PVector(0, 0);
   this.siz = size;
   this.speed = speed;
   this.floor = floor;
   this.block = block;
  }
  
  public void updateBox(ArrayList<Box> listOfBoxes){
    //updating speed and gravity
    speed.add(grav);
    pos.add(speed);
    
    checkHitdetection(listOfBoxes);
    
    checkBoundries();
    
   
  }
  
  public void checkHitdetection(ArrayList<Box> listOfBoxes){
    //checking to see if touching another box then 
      for(Box comparedBox : listOfBoxes){
        if(withinX(comparedBox) && withinY(comparedBox) && this != comparedBox){
          this.pos.y = comparedBox.pos.y - this.siz.y; //resets pos to the block below it - its siz so its right on top
          
        
        } 
      
      }
  
  }
  
  public void checkBoundries(){
      //dont go beyond the floor variable
      if(pos.y > floor - siz.x/2){
        pos.y = floor - siz.x/2;
        speed.y *= 0; //stops box
        
      } 
      //checks is off screen and resets position
      if(pos.x > width - siz.x/2){
        pos.x = width- siz.x/2;
        
      } else if (pos.x < 0 + siz.x/2){
        pos.x = 0 + siz.x/2;
        
      }
    }
  
  public void drawBox(){
    if(this.block == null){ //if no image was given draw a rect
      fill(255, 255, 255, transparency);
      
      rect(pos.x, pos.y, siz.x, siz.y);
    } else {  //draw image
      image(block, pos.x, pos.y, siz.x, siz.y);
    }
    
  }
  
  public boolean withinX(Box comparedbox){ //checks if compared box is with x pos
  
    if(abs(this.pos.x - comparedbox.pos.x) < comparedbox.siz.x){
      return true;
    }
    return false;
  }
  
  public boolean withinY(Box comparedbox){ //checks if comparedbox is within y pos
  if(abs(this.pos.y - comparedbox.pos.y) < comparedbox.siz.y){
      return true;
    }
    return false;
  }
  
  boolean ballHitDetection(PVector bPos, PVector bSiz, PVector bVel){
    
    //is ball hitting box?
    if(abs(bPos.x - this.pos.x) < this.siz.x/2 + bSiz.x/2  &&  abs(this.pos.y - bPos.y) < this.siz.y/2 + bSiz.y/2){
    
      
      PVector reflect = new PVector(); //direction ball is gonna reflect
      
      
      if(bPos.x + bSiz.x/2 > this.pos.x - this.siz.x/2){ 
        reflect.set(-1, 0); //reflect left
      }
      
      else if( bPos.x - bSiz.x/2 < this.pos.x + this.siz.x/2){
        reflect.set(1, 0); //reflect right
      }
      
      else if(bPos.y + bSiz.y/2 > this.pos.y - this.siz.y/2){
        reflect.set(0, 1); //reflect down
      }
      
      else if(bPos.y - bSiz.y/2 < this.pos.y + this.siz.y/2){
        reflect.set(0, -1);//reflect up
      }
      
      float angle = PVector.angleBetween(reflect, bVel);
      //change vel by the angle of reflection
      bVel.rotate(-2*angle);
      fill(255,0,0);
      
      bPos.add(bVel);
      
      boxList.remove(this); //remove box
      
      return true;
    }
    
    return false;
    
  }
  
  
  
  
}
