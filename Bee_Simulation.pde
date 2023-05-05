import java.util.ArrayList;
import java.util.List;

final color red = color(252,3,32);
final color blue = color(38,25,227);
final color lightBlue = color(121,196,245);
final color green = color(121,245,178);
final color pink = color(245,121,243);
final color yellow = color(255,243,5);
final color black = color(0, 0, 0);
final color white = color(255,255,255);

int numOfBees = 10;
int numOfFlowers = 10;

ArrayList<Bee> beeColony;
Hive beeHive; 
ArrayList<Flower> flowerGroup;
ArrayList<PVector> flowerPositions;

PImage img;

void setup() {
  size(1600, 800);
  img = loadImage("easterEgg.png");
  frameRate(30);
  
  beeHive = new Hive(width/2, height/2);
  beeColony = new ArrayList<Bee>(numOfBees);
  
  flowerGroup = new ArrayList<Flower>(numOfFlowers);
  flowerPositions = new ArrayList<PVector>(numOfFlowers);
  
  for(int i=0; i<numOfFlowers; i++) {
    flowerGroup.add(i, new Flower(beeHive.getPosition(), null, 0));
    flowerPositions.add(flowerGroup.get(i).getPosition());
  }
  
  for(int i=0; i<numOfBees; i++) {
    beeColony.add(i, new Bee(beeHive.getPosition())); 
  }
}

//Method that spawns up to 3 new flowers inside the radius of a pollinated flower 
//(there is a chance that 0 new flowers spawn)
void spawnFlowers(Flower parentFlower) {
  int howMany = (int)random(0,4);
  if(howMany == 0) return; 
  
  for(int i = 0; i<howMany; i++) {
    PVector randomPos = getRandomPos(parentFlower);
    if(PVector.dist(randomPos,beeHive.position) > 200) {
      Flower newFlower = new Flower(beeHive.getPosition(), randomPos, parentFlower.myColor);
      flowerGroup.add(newFlower);
      flowerPositions.add(newFlower.position);
    }
  }
}

//Method that gets a random position near a flowers parent for a new flower to spawn
PVector getRandomPos(Flower parentFlower) {
  PVector randomPos = new PVector(random(parentFlower.position.x-100,parentFlower.position.x+100), random(parentFlower.position.y-100,parentFlower.position.y+100));
  PVector parentPos = parentFlower.position;
  if(parentPos.x < 130) {
    randomPos.x = parentPos.x + random(15,100);
  }
  
  if(parentPos.y < 130) {
    randomPos.y = parentPos.y + random(15,100);
  }
  
  if(parentPos.x > width - 130) {
    randomPos.x = parentPos.x - random(15,100);
  }
  
  if(parentPos.y > height - 130) {
    randomPos.y = parentPos.y - random(15,100);
  }
  return randomPos;
}

//Method for creating Bees when honey is filled
void spawnBees() {
  if(beeHive.currentHoney == 100) {
    beeHive.currentHoney = 0;
    beeColony.add(new Bee(beeHive.getPosition()));
  }
}

void draw() {
  if(checkEndGame() == false) {
  background(lightBlue);
  spawnBees();
  beeHive.drawHive();
   //Loop that draws the flowers
   for(int i=0; i<flowerGroup.size(); i++) {
      Flower flower = flowerGroup.get(i);
      if(flower.pollinated == false && flower.currentNectar > 0) {
        flower.drawFlower();
      }
      else {
        flower.toBeDeleted = true;
        spawnFlowers(flower);
      }
   }
   
  drawBee();
 
  //Loop that removes flowers that need to be deleted
  for(int i=0; i<flowerGroup.size(); i++) {
    Flower flower = flowerGroup.get(i);
    if(flower.toBeDeleted == true) {
      flowerGroup.remove(flower);
    }
  }
  
   //Loop that removes the bees that need to die
   for(int i=0; i<beeColony.size(); i++) {
     Bee bee = beeColony.get(i);
     if(bee.toBeRemoved == true) {
      beeColony.remove(bee); 
     }
   }
  
  //statistics
  fill(black);
  textSize(15);
  text("Number of Flowers: " + flowerGroup.size() ,width-200,height-700);
  text("Number of Bees: " + beeColony.size(),width-200,height-725);
  text("Amount of Honey: " + (int)(beeHive.currentHoney) + "%",width-200,height-750);
  int timeElapsed = frameCount / 30;
  text("Time elapsed: " + timeElapsed + "s",width-200,height-675);

  //honeybar
  stroke(0);
  strokeWeight(2);
  fill(64,227,119);
  rect(width-850,height-352,100,15);
  fill(211,40,190);
  rect(width-850+((int)beeHive.currentHoney),height-352,0,15);
  
  if(beeHive.currentHoney >= beeHive.maxHoney) {
      beeHive.currentHoney = beeHive.maxHoney;
  } else if(beeHive.currentHoney < 0) {
     beeHive.currentHoney = 0;
  }
  
  //percentage
  fill(black);
  textSize(11);
  text((int)beeHive.percentageOfHoney() + "%",width-805,height-340);
  }
}

void drawBee() {
    for(Bee b: beeColony) {
      b.behave();
      b.step();
      b.passEdges();
      b.display();  
  }
}

boolean checkEndGame() {
  if(beeColony.size() == 0 || flowerGroup.size() == 0) {
    background(yellow);
    
    fill(black);
    textSize(70);
    textAlign(CENTER);
    text("The simulation has ended!", width/2, height/2);
    textSize(30); 
    text("Press 'e' to exit or 's' for a surprise", width/2, height/2 + 130); 
    textSize(20);
    text("Made by: ", width/2, height/2 + 200);
    text("Tron Baraku, ", width/2, height/2 + 230);
    text("Marino Osmanllari, ", width/2, height/2 + 260);
    text("Chase Taylor, ", width/2, height/2 + 290);
    text("Yusuf Demirhan. ", width/2, height/2 + 320);
    return true;  
  }
  return false;
}

void keyPressed() {
  if (key =='e' || key =='E') {
    exit();
  }
  else if (checkEndGame() && (key =='s' || key =='S')) {
    image(img, 400,5);
    noLoop();
  } 
}
