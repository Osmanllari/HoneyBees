public class Bee{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float heading;
  int size;
  float mass;
  static final float maxSpeed = 5;
  static final float maxForce = 0.5;
  final float fieldOfVision = 50;
  
  int collectedPollen;
  int collectedNectar;
  int age;  //in days
  int maxAge;
  boolean toBeRemoved;
  int lastTime = 0; //counter for counting time passed
  
  final int maxPollen = 50;
  final int maxNectar = 50;
  boolean seekingMode = true;
 
  Flower landingFlower;
  
  //honey factor for the calculation
  double honeyShrinkFactor = 0.1; 
  
  Bee(PVector location) {
    size = 40;
    mass = 1; 
    collectedPollen = 0;
    collectedNectar = 0;
    age = 0;
    
    maxAge = (int)random(30,60); //in days
    
    this.location = location; //initial location of a bee is the location of the hive
    velocity = new PVector(0, 0); 
    heading = velocity.heading();
  }
   
  void pollinate(Flower landingFlower){
    
    //if a bee has pollen and lands in another flower, pollinate and drop pollen
    if(this.collectedPollen > 0 && landingFlower.pollinated == false) {
       this.collectedPollen = collectedPollen - (int(random(5,10))); //drop a random amount of pollen
       landingFlower.pollinated = true;
     }
    
    //get nectar 
    if(landingFlower.currentNectar > 0 && this.collectedNectar < maxNectar){
     this.collectedNectar += landingFlower.getNectar();
    }
   
    //get pollen
    if(landingFlower.currentPollen > 0 && this.collectedPollen < maxPollen) {
     this.collectedPollen += landingFlower.getPollen();
    }
  }
   
  //Method that defines the beavior of a bee
  void behave() {  
    PVector flowerPos = checkFlowers(); 
    if(flowerPos != null && seekingMode == true && collectedNectar != maxNectar){
      seek(flowerPos);
      if(PVector.dist(flowerPos, this.location) < 5){
        if(millis() > lastTime + 5000) { //wait 5 seconds and pollinate the flower
          lastTime = millis();
          pollinate(landingFlower);
        }
        if(millis() > lastTime + 10000){ //turn seeking off to move on to another flower
          lastTime = millis();
          seekingMode = false; 
        }
        randomMovement();
      }
    }
    else{        
        randomMovement();
        flowerPos = null;
        flowerPos = checkFlowers();
        if(millis() > lastTime + 3000){ //after leaving a flower, turn seeking on after 3 seconds
          lastTime = millis();
          seekingMode = true;
        }
    }
    if(collectedNectar >= maxNectar){ //check for returning to hive
      collectedNectar = maxNectar;
      returnHome();
      if(PVector.dist(this.location, beeHive.getPosition()) < 2) {
        depositNectar();
        seekingMode = true;
      }
    }
   
    
    if(millis() > lastTime + 10000){ //increasing the age of the bees
          lastTime = millis();
          this.age = this.age + 1;
    }
    checkAge(); 
   }
   
   //Method for checking if a bee has reached max age
   void checkAge() {
     if(this.age >= maxAge){
       this.age = maxAge;
       this.toBeRemoved = true;
     }
   }
   
   void depositNectar() {
     double honeyAmount = nectarToHoney(collectedNectar);
     collectedNectar = 0;
     beeHive.storeHoney(honeyAmount);
   }
   
   //Method for making the bees move randomly when there are no flowers inside their field of view
  void randomMovement() {
     PVector randomVector = new PVector();
        randomVector = PVector.random2D();
        randomVector = randomVector.normalize();
        acceleration = randomVector.mult(0.5);
   }
   
  //Method for checking if a flower is within the field of view of a bee
  PVector checkFlowers(){ 
     for(int i=0; i<flowerGroup.size(); i++){
       PVector myFlowerPos = flowerGroup.get(i).getPosition();
       if(PVector.dist(myFlowerPos,this.location) <= fieldOfVision) {
         landingFlower = flowerGroup.get(i);
         return myFlowerPos;
       }
     }
   return null;
   }
 
  void returnHome(){
    if(this.collectedNectar >= maxNectar){
      seek(beeHive.getPosition());
    } 
  }
  
  //For every 10nectar units, create 1 honey unit
  double nectarToHoney(int collectedNectar){
    return collectedNectar * honeyShrinkFactor;
  }
  
  void seek(PVector target){
    PVector desiredVelocity = PVector.sub(target, location);
    float distanceFromTarget = desiredVelocity.mag();
    
    if(distanceFromTarget > fieldOfVision){
      desiredVelocity.setMag(maxSpeed);  
    }else {
      float speed = map(distanceFromTarget, 0, fieldOfVision, 0,  maxSpeed);
      desiredVelocity.setMag(speed);
    }
     
    desiredVelocity.limit(maxSpeed);
     
    PVector steeringForce = PVector.sub(desiredVelocity, velocity);
    steeringForce.limit(maxForce);
   
    applyForce(steeringForce);
  }
  
   void applyForce(PVector force) {
     
    PVector f = PVector.div(force, mass);
    f.normalize();
    acceleration.add(f);
  }
  
  void step(){
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    heading = velocity.heading();
    acceleration = new PVector(0, 0);
  }
  
  void display(){
    int h = 2;
    fill(yellow);
    
    pushMatrix();
    translate(location.x,location.y);
    ellipse(0,0,5,5);
    
    fill(black);
    ellipse(h,h,2,2);
    
    popMatrix();
  }
  
    void passEdges(){
    if(location.x < 0) location.x = width;
    if(location.x > width) location.x = 0;
    if(location.y < 0) location.y = height;
    if(location.y > height) location.y = 0;
   }
  
   void bounceOnEdges(){
     if(location.x < size/2){
       velocity.x *= -1;
     }
     if(location.x > width-size/2) {
       velocity.x *= -1;
     }
     if(location.y < size/2) {
       velocity.y *= -1;
     }
     if(location.y > height-size/2) {
       velocity.y *= -1;
     }
    }
    
}
