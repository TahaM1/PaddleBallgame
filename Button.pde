class Button {
  
  PVector pos, siz;
  String name; 
  int startScreen, endScreen;
  
  
  Button(PVector pos, PVector siz, String name, int num, int num2){
    this.pos = pos;
    this.name = name;
    this.siz = siz;
    this.startScreen = num; //where the button displays at
    this.endScreen = num2;  //where the screen changes to when button is clicked
  }
  
  void drawButton(){
    fill(255);
    textSize(10);
    rect(pos.x, pos.y, siz.x, siz.y, 15);  
    fill(0);
    text(name, pos.x, pos.y);
    
  }
  
  boolean buttonPressed(){
  
   //checks if mouse is on the button    
    if(mouseX > pos.x - siz.x/2 && mouseX < pos.x +siz.x/2){
      if(mouseY> pos.y - siz.y/2 && mouseY < pos.y + siz.y/2){
        return true;
      }
    }
    return false;
  }
  

}
