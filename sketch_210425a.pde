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
final String COLORBARS = "SMPTE-Color-Bars.png";

// Canvases added to this list will be iterated through while drawing.
ArrayList<PImage> drawCanvases = new ArrayList();
// How many frames to draw each canvas before moving to the next.
int drawDuration = 60;

void setup() {
  size(800, 600);
  
  PImage source = loadImage(BRIGHT);
  PImage dest = loadImage(COUNTDOWN);

  canvas = createImage(width, height, RGB);
  target = createImage(width, height, RGB);
  
  //PImage reorderedCanvas = new ReversedImage(canvas);
  PImage reorderedCanvas = new LUTReorderedImage(canvas, TRANSPOSED_LUT(canvas.width, canvas.height));
  reorderedCanvas.width = canvas.height;
  reorderedCanvas.height = canvas.width;
 
  drawCanvases.add(canvas);
  //drawCanvases.add(target);
  
  canvas.copy(source, 0, 0, source.width, source.height, 0, 0, width, height);
  target.copy(dest, 0, 0, dest.width, dest.height, 0, 0, width, height);
  target.loadPixels();
  
  //new Sort2DThread(canvas).start();
  //new DistantSort2DThread(canvas).start();
  //new Converge2DThread(canvas).start();
  
  ColorDelta deltaAlgorithm = new HSBSquareDelta();
  new RandomTransferThread(canvas, target, deltaAlgorithm).start();
  
  //new BubbleSortThread(canvas).start();
  //new RandomSortThread(canvas).start();
  
  //thread("runTransferAfterSort");
  //thread("rateLimitedBubbleSort");
  
  //thread("randomSort");
  //thread("randomTransfer");
  //thread("randomTransferNaive");
  
  randomTransferCanvas = canvas;
  randomTransferTarget = target;
  //thread("randomTransferSquare");
  //thread("randomTransferSBSquare");
  //thread("randomTransferHSBSquare");
  //thread("randomTransferInverseHSBSquare");

  //thread("rateLimitedRandomTransferSquare");
}

void draw() {
  if(drawCanvases.size() > 0) {
    int cycleLength = drawDuration * drawCanvases.size();
    int currentCanvas = (frameCount % cycleLength) / drawDuration;
    image(drawCanvases.get(currentCanvas), 0, 0, width, height);
  }
}

void runTransferAfterSort() {
  Thread sort1 = new Sort2DThread(canvas);
  sort1.start();
  Thread sort2 = new DistantSort2DThread(canvas);
  sort2.start();
  
  try {
    sort2.join();
    sort1.join();
  } catch (InterruptedException e) {
    System.out.println("Interrupted!");
  }
  System.out.println("Beginning transfer");
  thread("randomTransferHSBSquare");
}

PImage bubbleSortCanvas;
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

void randomTransferInverseHSBSquare() {
  IntList indices = new IntList();
  randomTransferCanvas.loadPixels();
  for (int i = 0; i < randomTransferCanvas.pixels.length; i++) {
    indices.append(i);
  }
  while(true) {
    indices.shuffle();
    randomTransferCanvas.loadPixels();
    for(int a = 0; a < randomTransferCanvas.pixels.length; a++) {
      int b = indices.get(a);
      
      color aCVal = randomTransferCanvas.pixels[a];
      color bCVal = randomTransferCanvas.pixels[b];
      
      color aTVal = randomTransferTarget.pixels[a];
      color bTVal = randomTransferTarget.pixels[b];
      
      float currDelta = inverseHsbSquareDelta(aCVal, aTVal) + inverseHsbSquareDelta(bCVal, bTVal);
      float swapDelta = inverseHsbSquareDelta(aCVal, bTVal) + inverseHsbSquareDelta(bCVal, aTVal);
      
      if (swapDelta < currDelta) {
        swap(randomTransferCanvas, a, b);
      }
    }
    randomTransferCanvas.updatePixels();

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
