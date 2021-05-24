class Sort2DThread extends ProcessorThread {
  Sort2DThread(PImage canvas) {
    super(canvas);
  }

  public void run() {
    boolean done = false;
    
    int width = canvas.width;
    int height = canvas.height;
    
    IntList indices = new IntList();
    for (int i = 0; i < this.canvas.pixels.length; i++) {
      indices.append(i);
    }
    
    while(!done) {
      this.canvas.loadPixels();
      
      indices.shuffle();
      done = true;
      
      for(int i = 0; i < this.canvas.pixels.length; i++) {
        int a = indices.get(i);
        
        int row = a / width;
        int col = a % width;
        
        // Any neighbor that doesn't exist will be replaced by the position itself.
        // This will make comparisons with that position a no-op.
        
        int colL = max(col - 1, 0);
        int colR = min(col + 1, width - 1);
        int rowU = max(row - 1, 0);
        int rowD = min(row + 1, height - 1);
        
        int idxL = (row * width) + colL;
        int idxR = (row * width) + colR;
        int idxU = (rowU * width) + col;
        int idxD = (rowD * width) + col;
        
        color l = this.canvas.pixels[idxL];
        color r = this.canvas.pixels[idxR];
        color u = this.canvas.pixels[idxU];
        color d = this.canvas.pixels[idxD];
        
        if (brightness(u) > brightness(this.canvas.pixels[a])) {
          swap(this.canvas, idxU, a);
          done = false;
        }
        if (brightness(d) < brightness(this.canvas.pixels[a])) {
          swap(this.canvas, idxD, a);
          done = false;
        }
        if (hue(l) > hue(this.canvas.pixels[a])) {
          swap(this.canvas, idxL, a);
          done = false;
        }
        if (hue(r) < hue(this.canvas.pixels[a])) {
          swap(this.canvas, idxR, a);
          done = false;
        }
      }

      this.canvas.updatePixels();
    }
    println("Done sorting!");
  }
}

class DistantSort2DThread extends ProcessorThread {
  DistantSort2DThread(PImage canvas) {
    super(canvas);
  }

  public void run() {
    boolean done = false;
    
    int width = canvas.width;
    int height = canvas.height;
    
    IntList indices = new IntList();
    for (int i = 0; i < this.canvas.pixels.length; i++) {
      indices.append(i);
    }
    
    while(!done) {
      this.canvas.loadPixels();
      
      indices.shuffle();
      done = true;
      
      for(int a = 0; a < this.canvas.pixels.length; a++) {
        int b = indices.get(a);
        
        int rowA = a / width;
        int colA = a % width;
        int rowB = b / width;
        int colB = b % width;
        
        color cA = this.canvas.pixels[a];
        color cB = this.canvas.pixels[b];
        
        float deltaRow = abs(rowA - rowB) / (float) height;
        float deltaCol = abs(colA - colB) / (float) width;
        
        if (deltaRow > deltaCol) {
          if (rowA < rowB) {
            if (brightness(cA) > brightness(cB)) {
              swap(this.canvas, a, b);
              done = false;
            }
          } else {
            if (brightness(cA) < brightness(cB)) {
              swap(this.canvas, a, b);
              done = false;
            }
          }
        } else {
          if (colA < colB) {
            if (hue(cA) > hue(cB)) {
              swap(this.canvas, a, b);
              done = false;
            }
          } else {
            if (hue(cA) < hue(cB)) {
              swap(this.canvas, a, b);
              done = false;
            }
          }
        }
      }

      this.canvas.updatePixels();
    }
    println("Done sorting!");
  }
}
