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
        if (this.canvas.pixels[i] > this.canvas.pixels[j]) {
          swap(this.canvas, i, j);
          done = false;
        }
      }

      this.canvas.updatePixels();
    }
    println("Done sorting!");
  }
}
