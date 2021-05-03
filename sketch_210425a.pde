PImage canvas;
PImage target;

// Images in the directory we can use
final String COLORS = "colors.jpg";
final String DOGGO = "doggo.jpg";
final String HOUSE = "gingerbread.jpg";
final String ORANGEMTN = "orange-mtns.jpg";
final String PINKMTN = "pink-mtns.jpg";
final String FOX = "arctic-fox.jpg";
final String COUNTDOWN = "liftoff-launch.jpg";
final String BRIGHT = "rainbow-dust.jpg";

void setup() {
  size(800, 600);
  
  //PImage source = loadImage(FOX, "jpg");
  PImage source = loadImage("SMPTE-Color-Bars.png", "png");
  PImage dest = loadImage(DOGGO, "jpg");

  canvas = createImage(width, height, RGB);
  target = createImage(width, height, RGB);
  
  canvas.copy(source, 0, 0, source.width, source.height, 0, 0, width, height);
  target.copy(dest, 0, 0, dest.width, dest.height, 0, 0, width, height);
  target.loadPixels();
    
  //bubbleSortCanvas = target;
  //thread("bubbleSort");
  //thread("rateLimitedBubbleSort");
  
  //thread("randomSort");
  //thread("randomTransfer");
  //thread("randomTransferNaive");
  
  randomTransferCanvas = canvas;
  randomTransferTarget = target;
  //thread("randomTransferSquare");
  //thread("randomTransferSBSquare");
  thread("randomTransferHSBSquare");

  //thread("rateLimitedRandomTransferSquare");
}

boolean noSwap = true;

void draw() {
  if (noSwap || frameCount % 120 > 60) {
    image(canvas, 0, 0, width, height);
  } else {
    image(target, 0, 0, width, height);
  }
}

PImage bubbleSortCanvas;
void bubbleSort() {
  while(true) {
    bubbleSortCanvas.loadPixels();
    
    for(int j = 1; j < bubbleSortCanvas.pixels.length; j++) {
      int i = j - 1;
      if (bubbleSortCanvas.pixels[i] > bubbleSortCanvas.pixels[j]) {
        swap(bubbleSortCanvas, i, j);
      }
    }
    bubbleSortCanvas.updatePixels();
  }
}

void rateLimitedBubbleSort() {
  int frame = 0;
  while(true) {
    // Remove this. I dare you. Just... test the code afterward, because
    // right now, if this isn't here this thread never runs.
    // I don't know why either. If you figure it out, let me know.
    print("");
    if (frameCount > frame) {
      frame = frameCount;
      bubbleSortCanvas.loadPixels();
      
      for(int j = 1; j < bubbleSortCanvas.pixels.length; j++) {
        int i = j - 1;
        if (bubbleSortCanvas.pixels[i] > bubbleSortCanvas.pixels[j]) {
          swap(bubbleSortCanvas, i, j);
        }
      }
      bubbleSortCanvas.updatePixels();
      print('.');
    }
  }
}

void bubbleSortV2() {
  while(true) {
    canvas.loadPixels();
    
    int swaps = 0;
    
    for(int j = 1; j < canvas.pixels.length; j++) {
      int i = j - 1;
      float iVal = rgbTotal(canvas.pixels[i]);
      float jVal = rgbTotal(canvas.pixels[j]);
      
      if (iVal > jVal) {
        swap(canvas, i, j);
        swaps++;
      }
    }
    canvas.updatePixels();
    println(swaps);
  }
}

void randomSort() {
  IntList indices = new IntList();
  for (int i = 0; i < canvas.pixels.length; i++) {
    indices.append(i);
  }
  
  while(true) {
    indices.shuffle();
    canvas.loadPixels();
    for(int a = 0; a < canvas.pixels.length; a++) {
      int b = indices.get(a);
      
      int i = Math.min(a, b);
      int j = Math.max(a, b);
      
      float iVal = rgbTotal(canvas.pixels[i]);
      float jVal = rgbTotal(canvas.pixels[j]);
      
      if (iVal > jVal) {
        swap(canvas, i, j);
      }
    }
    canvas.updatePixels();
  }
}

PImage randomTransferCanvas;
PImage randomTransferTarget;

void randomTransfer() {
  IntList indices = new IntList();
  for (int i = 0; i < canvas.pixels.length; i++) {
    indices.append(i);
  }
  
  while(true) {
    indices.shuffle();
    canvas.loadPixels();
    target.loadPixels();
    int swaps = 0;
    for(int a = 0; a < canvas.pixels.length; a++) {
      int b = indices.get(a);
      
      float aCVal = rgbTotal(canvas.pixels[a]);
      float bCVal = rgbTotal(canvas.pixels[b]);
      
      float aTVal = rgbTotal(target.pixels[a]);
      float bTVal = rgbTotal(target.pixels[b]);
      
      float currDelta = abs(aCVal - aTVal) + abs(bCVal - bTVal);
      float swapDelta = abs(aCVal - bTVal) + abs(bCVal - aTVal);
      
      // We get very interesting results when this test is reversed!
      if (swapDelta < currDelta) {
        swap(canvas, a, b);
        swaps++;
      }
    }
    canvas.updatePixels();
    println(swaps);
  }
}

void randomTransferNaive() {
  IntList indices = new IntList();
  for (int i = 0; i < canvas.pixels.length; i++) {
    indices.append(i);
  }
  
  while(true) {
    indices.shuffle();
    canvas.loadPixels();
    int swaps = 0;
    for(int a = 0; a < canvas.pixels.length; a++) {
      int b = indices.get(a);
      
      float aCVal = canvas.pixels[a];
      float bCVal = canvas.pixels[b];
      
      float aTVal = target.pixels[a];
      float bTVal = target.pixels[b];
      
      float currDelta = abs(aCVal - aTVal) + abs(bCVal - bTVal);
      float swapDelta = abs(aCVal - bTVal) + abs(bCVal - aTVal);
      
      if (swapDelta < currDelta) {
        swap(canvas, a, b);
        swaps++;
      }
    }
    canvas.updatePixels();
    println(swaps);
  }
}

void randomTransferSquare() {
  IntList indices = new IntList();
  randomTransferCanvas.loadPixels();
  for (int i = 0; i < randomTransferCanvas.pixels.length; i++) {
    indices.append(i);
  }
  int totalSwaps = 0;
  while(true) {
    indices.shuffle();
    randomTransferCanvas.loadPixels();
    int swaps = 0;
    for(int a = 0; a < randomTransferCanvas.pixels.length; a++) {
      int b = indices.get(a);
      
      color aCVal = randomTransferCanvas.pixels[a];
      color bCVal = randomTransferCanvas.pixels[b];
      
      color aTVal = randomTransferTarget.pixels[a];
      color bTVal = randomTransferTarget.pixels[b];
      
      int currDelta = rgbSquareDelta(aCVal, aTVal) + rgbSquareDelta(bCVal, bTVal);
      int swapDelta = rgbSquareDelta(aCVal, bTVal) + rgbSquareDelta(bCVal, aTVal);
      
      if (swapDelta < currDelta) {
        swap(randomTransferCanvas, a, b);
        swaps++;
      }
    }
    randomTransferCanvas.updatePixels();
    totalSwaps += swaps;
    //println(swaps, totalSwaps);
  }
}

void randomTransferSBSquare() {
  IntList indices = new IntList();
  randomTransferCanvas.loadPixels();
  for (int i = 0; i < randomTransferCanvas.pixels.length; i++) {
    indices.append(i);
  }
  int totalSwaps = 0;
  while(true) {
    indices.shuffle();
    randomTransferCanvas.loadPixels();
    int swaps = 0;
    for(int a = 0; a < randomTransferCanvas.pixels.length; a++) {
      int b = indices.get(a);
      
      color aCVal = randomTransferCanvas.pixels[a];
      color bCVal = randomTransferCanvas.pixels[b];
      
      color aTVal = randomTransferTarget.pixels[a];
      color bTVal = randomTransferTarget.pixels[b];
      
      float currDelta = sbSquareDelta(aCVal, aTVal) + sbSquareDelta(bCVal, bTVal);
      float swapDelta = sbSquareDelta(aCVal, bTVal) + sbSquareDelta(bCVal, aTVal);
      
      if (swapDelta < currDelta) {
        swap(randomTransferCanvas, a, b);
        swaps++;
      }
    }
    randomTransferCanvas.updatePixels();
    totalSwaps += swaps;
    //println(swaps, totalSwaps);
  }
}

void randomTransferHSBSquare() {
  IntList indices = new IntList();
  randomTransferCanvas.loadPixels();
  for (int i = 0; i < randomTransferCanvas.pixels.length; i++) {
    indices.append(i);
  }
  int totalSwaps = 0;
  while(true) {
    indices.shuffle();
    randomTransferCanvas.loadPixels();
    int swaps = 0;
    for(int a = 0; a < randomTransferCanvas.pixels.length; a++) {
      int b = indices.get(a);
      
      color aCVal = randomTransferCanvas.pixels[a];
      color bCVal = randomTransferCanvas.pixels[b];
      
      color aTVal = randomTransferTarget.pixels[a];
      color bTVal = randomTransferTarget.pixels[b];
      
      float currDelta = hsbSquareDelta(aCVal, aTVal) + hsbSquareDelta(bCVal, bTVal);
      float swapDelta = hsbSquareDelta(aCVal, bTVal) + hsbSquareDelta(bCVal, aTVal);
      
      if (swapDelta < currDelta) {
        swap(randomTransferCanvas, a, b);
        swaps++;
      }
    }
    randomTransferCanvas.updatePixels();
    totalSwaps += swaps;
    //println(swaps, totalSwaps);
  }
}

void rateLimitedRandomTransferSquare() {
  IntList indices = new IntList();
  for (int i = 0; i < canvas.pixels.length; i++) {
    indices.append(i);
  }
  int totalSwaps = 0;
  int frame = 0;
  while(true) {
    if (frameCount > frame) {
      frame = frameCount + 1;

      indices.shuffle();
      canvas.loadPixels();
      int swaps = 0;
      for(int a = 0; a < canvas.pixels.length; a++) {
        int b = indices.get(a);
        
        color aCVal = canvas.pixels[a];
        color bCVal = canvas.pixels[b];
        
        color aTVal = target.pixels[a];
        color bTVal = target.pixels[b];
        
        int currDelta = rgbSquareDelta(aCVal, aTVal) + rgbSquareDelta(bCVal, bTVal);
        int swapDelta = rgbSquareDelta(aCVal, bTVal) + rgbSquareDelta(bCVal, aTVal);
        
        if (swapDelta < currDelta) {
          swap(canvas, a, b);
          swaps++;
        }
      }
      canvas.updatePixels();
      totalSwaps += swaps;
      println(swaps, totalSwaps);
    }
  }
}

// Presumes that image.pixels is already loaded.
void swap(PImage image, int i, int j) {
  int s = image.pixels[i];
  image.pixels[i] = image.pixels[j];
  image.pixels[j] = s;
}

float rgbTotal(color c) {
  return red(c) + blue(c) + green(c);
}

int rgbSquareDelta(color a, color b) {
  int rD = ceil(pow(red(a) - red(b), 2));
  int gD = ceil(pow(green(a) - green(b), 2));
  int bD = ceil(pow(blue(a) - blue(b), 2));
  return rD + gD + bD;
}

float maxHue = 0;
float sbSquareDelta(color a, color b) {
  float sD = pow(saturation(a) - saturation(b), 2);
  float bD = pow(brightness(a) - brightness(b), 2);
  return sD + bD;
}

float hsbSquareDelta(color a, color b) {
  // Hue appears to be in the range 0-255 by default
  float hD = abs(hue(a) - hue(b));
  hD = pow(min(hD, 255.0 - hD), 2);
  float sD = pow(saturation(a) - saturation(b), 2);
  float bD = pow(brightness(a) - brightness(b), 2);
  return hD + sD + bD;
}
