public class Hive {
  
  final double maxHoney = 100;
  double currentHoney;
  
  PVector position;
    
  Hive(float x, float y){
    //give coordinates where to place the hive
    position = new PVector(x,y);
    currentHoney = 0.0;
    
  }
  
  PVector getPosition(){
    PVector copyPosition;
    copyPosition = position.copy();
    return copyPosition;
  } 
  
  void storeHoney(double amount) {
    setHoney(getHoney() + amount);
  }
  
  double getHoney() {
   return currentHoney; 
  }
  
  void setHoney(double amount) {
    currentHoney = amount;
  }
  
 double percentageOfHoney(){
   return currentHoney;
 }
  
  double takeHoney(double amount) {
   double total = getHoney();
   amount = Math.min(amount, total);
   total -= amount;
   setHoney(total);
   return amount;
  }
  
   void drawHive() {
    fill(255,255,0);
    stroke(0,0,0);
    ellipse(position.x, position.y, 45,55);
    fill(0,0,0);
    ellipse(position.x, position.y+10, 15,20);
    
  }


 
}
