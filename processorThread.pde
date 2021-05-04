class ProcessorThread extends Thread {
  PImage canvas;
  
  ProcessorThread(PImage canvas) {
    this.canvas = canvas;
  }
}

class BubbleSortThread extends ProcessorThread {
  BubbleSortThread(PImage canvas) {
    super(canvas);
  }

  public void run() {
    boolean done = false;
    while(!done) {
      this.canvas.loadPixels();
      done = true;
      
      for(int j = 1; j < this.canvas.pixels.length; j++) {
        int i = j - 1;
        
        //float iVal = rgbTotal(this.canvas.pixels[i]);
        //float jVal = rgbTotal(this.canvas.pixels[j]);
        float iVal = this.canvas.pixels[i];
        float jVal = this.canvas.pixels[j];
        
        if (iVal > jVal) {
          swap(this.canvas, i, j);
          done = false;
        }
      }

      this.canvas.updatePixels();
    }
    println("Done sorting!");
  }
}

class RandomSortThread extends ProcessorThread {
  RandomSortThread(PImage canvas) {
    super(canvas);
  }

  public void run() {
    IntList indices = new IntList();
    for (int i = 0; i < this.canvas.pixels.length; i++) {
      indices.append(i);
    }

    int swaplessLoops = 0;

    while(swaplessLoops < 5) {
      boolean swapless = true;
      indices.shuffle();
      this.canvas.loadPixels();
      for(int a = 0; a < this.canvas.pixels.length; a++) {
        int b = indices.get(a);
        
        int i = Math.min(a, b);
        int j = Math.max(a, b);
        
        //float iVal = rgbTotal(this.canvas.pixels[i]);
        //float jVal = rgbTotal(this.canvas.pixels[j]);
        float iVal = this.canvas.pixels[i];
        float jVal = this.canvas.pixels[j];
        
        if (iVal > jVal) {
          swap(this.canvas, i, j);
          swapless = false;
        }
      }
      swaplessLoops += swapless ? 1 : 0;
      this.canvas.updatePixels();
    }

    println("Done sorting!");
  }
}
