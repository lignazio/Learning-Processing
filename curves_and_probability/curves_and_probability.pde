size(1650, 1100);
float p = 0.00;

for (int i = 0; i<100; i++) {
  float h =  pow( 1-p, 4);
  //float h =   pow( p, 4);
  rect(25+i*5, 180, 3, -h*100); 
  p+= 0.01;
}

p = 0.00;
for (int i = 0; i<100; i++) {
  float h =  pow( p, 4);
  //float h =   pow( p, 4);
  rect(25+i*5, 380, 3, -h*100); 
  p+= 0.01;
}
float[] rects = new float[100];
for (int i = 0; i< 5000; i++) {
 float xloc = randomGaussian();

  float sd = 10;                // Define a standard deviation
  float mean = 50;         // Define a mean value (middle of the screen along the x-axis)
  xloc = (( xloc * sd ) + mean);
  //print(xloc,",");
  if (xloc >0 && xloc < 100){
  rects[(int)xloc]+= 0.005;
  }
}
for (int i = 0; i<100; i++) {
  rect(25+i*5, 580, 3, -rects[i]*100); 
  
}

float a = PI;


for (int i = 0; i<100; i++) {
    float s = pow(sin(i*a/100),5);
   rect(25+i*5, 780, 3, -s*100); 
  
}

for (int i = 0; i<100; i++) {
  float s = pow(1-sin(i*a/100),2);
   rect(25+i*5, 980, 3, -s*100); 
  
}


p = 0;
for (int i = 0; i<100; i++) {
  float x = i*a/100;
  float s = pow(sin(x),2)*pow(p,4);
  //print(x,",");
   rect(575+i*5, 180, 3, -s*100); 
    p+= 0.015;
}

p = 0;
for (int i = 0; i<100; i++) {
  float x = i*a/100;
  float s = pow(sin(x),2)*pow(1-p,4);
   rect(575+i*5, 380, 3, -s*600); 
    p+= 0.01;
}

p = 0;
for (int i = 0; i<100; i++) {
  float x = noise(p);
   rect(575+i*5, 580, 3, -x*100); 
    p+= 0.05;
}

for (int i = 0; i<100; i++) {
  float x = random(1);
   rect(575+i*5, 780, 3, -x*100); 
}

for (int i = 0; i<100; i++) {
   float x = 0;
  while(true){
     p = random(1);
     x = random(1);
    if (p < x){
      break;
    }
  }
   rect(575+i*5, 980, 3, -x*100); 
}

p = 0.00;
for (int i = 0; i<100; i++) {
  float h =  log(p);
  
  //float h =   pow( p, 4);
  rect(1125+i*5, 180, 3, h*25); 
  p+= 0.01;
}

fill(0);
noStroke();
text("(1-x)^n", 25, 200); 
text("x^n", 25, 400); 
text("gaussian 1000 samples", 25, 600); 
text("(sin(x))^n", 25, 800); 
text("(1-sin(x))^n", 25, 1000); 
text("(sin(x))^n * x^n", 575, 200); 
text("(sin(x))^n * (1-x)^n", 575, 400); 
text("perlin noise", 575, 600); 
text("random", 575, 800); 
text("montecarlo", 575, 1000); 