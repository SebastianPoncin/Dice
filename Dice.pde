// i might be the goat
PImage dice1, dice2, dice3, dice4, dice5, dice6, thing;
//int scale = 100;


float rotationX = 0;
float rotationY = 0;
double wx = 0;
double wy = 0;
double wz = 0;
int sum = 0;

PVector[] faceNormals = { // NGL THERES SOME [1] AND [5] JANKNESS BUT WE BALL IT WORKS
  new PVector(0, 0, 1),  // Front face
  new PVector(0, -1, 0), // bottom face
  new PVector(1, 0, 0),  // Right face
  new PVector(-1, 0, 0), // Left face
  new PVector(0, 1, 0),  // Top face
  new PVector(0, 0, -1)  // back face
};
PVector camDir = new PVector(0, 0, -1); // camera (-z);

Die [] dice;

int rows = 3;
int collumns = 3;
int unitx = 640/(collumns*2);
int unity = 640/(rows*2);


void setup() {
  size(640,640,P3D);
  background(0);
  stroke(150);
  /*dice1 = loadImage("dice1.jpg");
  dice2 = loadImage("dice2.jpg");
  dice3 = loadImage("dice3.jpg");
  dice4 = loadImage("dice4.jpg");
  dice5 = loadImage("dice5.jpg");
  dice6 = loadImage("dice6.jpg");*/
  
  dice = new Die[collumns*rows];
  for (int i = 0; i < collumns; i++) {
    for (int j = 0; j < rows; j++) {
      dice[i*3+j] = new Die(unitx+j*unitx*2, unity+i*unity*2);
    }
  }
  //for (int i = 0; i < dice.length; i++) {
  //  println(dice[i].x, dice[i].y);
  //}
}


void draw() {
  background(0);
  lights();
    
  sum = 0; 
  for (int i = 0; i < dice.length; i++) {
    dice[i].show();
    sum += closestFace(dice[i].rx, dice[i].ry);
  }
  
  textSize(20);
  textAlign(CENTER);
  text("sum of closest" + "\n" + "faces = " + sum, 320, 600);

}

void mousePressed() {
  //println("uwu");
  for (int i = 0; i < dice.length; i++) {
    dice[i].roll();
  }
}

int closestFace(float rx, float ry) {
  int bestFace = 0;
  
  float highestDot = -Float.MAX_VALUE;
  
  for (int i = 0; i < faceNormals.length; i++) {
    PVector normal = faceNormals[i].copy();
    pushMatrix();
    rotateX(rx); 
    rotateY(ry);
    
    // Transform the face normal using modelX(), modelY(), and modelZ()
    PVector rotatedNormal = new PVector(
      modelX(normal.x, normal.y, normal.z),
      modelY(normal.x, normal.y, normal.z),
      modelZ(normal.x, normal.y, normal.z)
    );
    
    popMatrix();
    
    float dot = rotatedNormal.dot(camDir);
    if (dot > highestDot) {
      highestDot = dot;
      bestFace = i+1;
    }
  }
  return bestFace;
}

class Die {
  float x, y, rx, ry, wx, wy;
  
  Die(float whoax, float whoay) {
    x = whoax;
    y = whoay;
    rx = 0;
    ry = 0;
    wx = 0;
    wy = 0;
  }
  
  void roll() {
    wx = (float)Math.random()*pow(-1, (int)(Math.random()*2)); // truly the best way for it to randomly be negative
    wy = (float)Math.random()*pow(-1, (int)(Math.random()*2));
  }
  
  void show() {
    rx += wx;
    wx *= 0.9;
    ry += wy;
    wy *= 0.9;
  
    pushMatrix();
    translate(x, y, -100);
    rotateY(rx);
    rotateX(ry);
    scale(40);
    noStroke();
   
    //shape(cube);
    beginShape();
   
    textureMode(NORMAL);
    // +Z "front" face
    //texture(dice6);
    vertex(-1, -1,  1, 0, 0);
    vertex( 1, -1,  1, 1, 0);
    vertex( 1,  1,  1, 1, 1);
    vertex(-1,  1,  1, 0, 1);
    endShape();
  
    // -Z "back" face
    beginShape();
    //texture(dice1);
    vertex( 1, -1, -1, 0, 0);
    vertex(-1, -1, -1, 1, 0);
    vertex(-1,  1, -1, 1, 1);
    vertex( 1,  1, -1, 0, 1);
    endShape();
   
    // +Y "bottom" face
    beginShape();
    //texture(dice3);
    vertex(-1,  1,  1, 0, 0);
    vertex( 1,  1,  1, 1, 0);
    vertex( 1,  1, -1, 1, 1);
    vertex(-1,  1, -1, 0, 1);
    endShape();
    // -Y "top" face
    beginShape();
    //texture(dice4);
    vertex(-1, -1, -1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1, -1,  1, 1, 1);
    vertex(-1, -1,  1, 0, 1);
    endShape();
    // +X "right" face
    beginShape();
    //texture(dice5);
    vertex( 1, -1,  1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1,  1, -1, 1, 1);
    vertex( 1,  1,  1, 0, 1);
    endShape();
  
    // -X "left" face
    beginShape();
    //texture(dice2);
    vertex(-1, -1, -1, 0, 0);
    vertex(-1, -1,  1, 1, 0);
    vertex(-1,  1,  1, 1, 1);
    vertex(-1,  1, -1, 0, 1);
    endShape();
   
    endShape();
    popMatrix();
  } 
}
