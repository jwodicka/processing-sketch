PImage photo;
PImage photo2;
PImage canvas;
PImage target;

void setup() {
  size(800, 600);

  photo2 = loadImage("colors.jpg", "jpg");
  //photo = loadImage("doggo.jpg", "jpg");
  photo = photo2;
  canvas = createImage(width, height, RGB);
  target = createImage(width, height, RGB);
  
  canvas.copy(photo, 0, 0, photo.width, photo.height, 0, 0, width, height);
  target.copy(photo2, 0, 0, photo2.width, photo2.height, 0, 0, width, height);
  target.loadPixels();
  
  image(target, 0, 0, width, height);
  
  thread("bubbleSort");
  //thread("rateLimitedBubbleSort");
  //thread("randomSort");
  //thread("randomTransfer");
  //thread("randomTransferNaive");
  //thread("randomTransferSquare");
  thread("rateLimitedRandomTransferSquare");
}

void bubbleSort() {
  while(true) {
    canvas.loadPixels();
    
    for(int j = 1; j < canvas.pixels.length; j++) {
      int i = j - 1;
      if (canvas.pixels[i] > canvas.pixels[j]) {
        swap(canvas, i, j);
      }
    }
    canvas.updatePixels();
  }
}

void rateLimitedBubbleSort() {
  int frame = 0;
  while(true) {
    if (frameCount > frame) {
      frame = frameCount;
      canvas.loadPixels();
      
      for(int j = 1; j < canvas.pixels.length; j++) {
        int i = j - 1;
        if (canvas.pixels[i] > canvas.pixels[j]) {
          swap(canvas, i, j);
        }
      }
      canvas.updatePixels();
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

// This is not actually randomTransfer. Apply it with source = target to see what I mean.
// What _is_ this?
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
      
      if (swapDelta > currDelta) {
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
  for (int i = 0; i < canvas.pixels.length; i++) {
    indices.append(i);
  }
  int totalSwaps = 0;
  while(true) {
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

void draw() {
  image(canvas, 0, 0, width, height);
}
