public class Flower{
  
  final color pink = color(245,121,243);
  final color red = color(252,3,32);
  final color white = color(255,255,255);
  final color lightBlue = color(121,196,245);
  
  color myColor = white;
  
  final int maxPollen = 25;
  final int maxNectar = 25;
  
  int currentPollen;
  int currentNectar;
  
  boolean pollinated;
  PVector position;
  boolean toBeDeleted = false;
  
  
  Flower(PVector hivePos, PVector spawnPos, color flowerColor) {
    
    if(spawnPos == null) {
      position = new PVector(random(30,width-30),random(30,height-30));
   
      for(PVector otherPos : flowerPositions){
        while(PVector.dist(otherPos, this.position) < 50 || PVector.dist(hivePos, this.position) < 200) {
         position.x = random(30,width-30);
         position.y = random(30,height-30);
        }
      }
    }
    else {
     this.position = spawnPos;
    }
    currentPollen = (int)random(10, 20);
    currentNectar = (int)random(10, 20);
    
    
    if(flowerColor == 0) {
      int randomColor = (int)random(1,4);
      switch (randomColor){
       case 1: myColor = pink;break;
       case 2: myColor = red;break;
       case 3: myColor = white;break;
      } 
    }
    else
      myColor = flowerColor;
  }
  
  int getNectar() {
    int flowerNectar = this.currentNectar;
    currentNectar = 0;
    return flowerNectar;
  }
  
  int getPollen() {
     int flowerPollen = this.currentPollen;
     currentPollen = 0;
     return flowerPollen;
  }
  
  PVector getPosition(){
    PVector copyPosition;
    copyPosition = position.copy();
    return copyPosition;
  }
  
  void createNectar(){
    if(!pollinated && currentNectar < maxNectar){ 
     currentNectar++;
    }
  }
  
  void createPollen(){
   if(!pollinated && currentPollen < maxPollen) {
     currentPollen++;
   }
  }
  
  void drawFlower(){
    noStroke();
    //first petal
    fill(myColor);
    pushMatrix();  
    translate(position.x,position.y);
    //translate(36-9-3, 30-10-10-0);
    for (int i =0; i < 9; i++) {
      translate(10, 0);
      ellipse(0, 0, 10, 20);
      rotate (TWO_PI/9);
    }
    //middle
    fill(255, 219, 77);
    circle(5,15,15);
    noStroke();
    popMatrix();
  }
    
  
  
  
}
