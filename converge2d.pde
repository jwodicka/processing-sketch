import java.util.TreeSet;

class Converge2DThread extends ProcessorThread {
  Converge2DThread(PImage canvas) {
    super(canvas);
  }

  public void run() {
    boolean done = false;
        
    IntList indices = new IntList();
    for (int i = 0; i < this.canvas.pixels.length; i++) {
      indices.append(i);
    }
    
    while(!done) {
      this.canvas.loadPixels();
      
      indices.shuffle();
      done = true;
      
      for(int i = 0; i < canvas.pixels.length; i++) {
        int a = indices.get(i);
        ArrayList<Point> neighbors =
          Point.fromIndex(a, canvas.width).orthogonalNeighbors(canvas.width, canvas.height);
        
        for (Point n : neighbors) {
          int b = n.index(canvas.width);
        
          color cA = canvas.pixels[a];
          color cB = canvas.pixels[b];
          
          float currentDelta = calculateQuality(a, cA) + calculateQuality(b, cB);
          float swapDelta = calculateQuality(a, cB) + calculateQuality(b, cA);
          
          if (swapDelta < currentDelta) {
            swap(this.canvas, a, b);
            done = false;
          }
        }
      }

      this.canvas.updatePixels();
    }
    println("Done sorting!");
  }
  
  float calculateQuality(int idx, color c) {
    int width = canvas.width;
    int height = canvas.height;
    
    Point pos = Point.fromIndex(idx, width); 
    ArrayList<Point> neighbors = pos.orthogonalNeighbors(width, height);
    
    //float totalDelta = 0.0;
    //float minDelta = MAX_FLOAT;
    //float maxDelta = 0.0;
    TreeSet<Float> deltas = new TreeSet<Float>();
    for (Point neighbor : neighbors) {
      if (pos.equals(neighbor)) { continue; }

      color neighborColor = canvas.pixels[neighbor.index(width)];
      float delta = hsbSquareDelta(c, neighborColor);
      //totalDelta += delta;
      //minDelta = min(minDelta, delta);
      //maxDelta = max(maxDelta, delta);
      deltas.add(delta);
    }
    
    if (deltas.size() > 1) {
      Float minDelta = deltas.first();
      return deltas.higher(minDelta);
    }
    return deltas.first();
    //return minDelta;
    //return maxDelta;
    //return totalDelta / neighbors.size();
  }
}

static class Point {
  public final int row;
  public final int col;
  
  Point(int row, int col) {
    this.row = row;
    this.col = col;
  }
  
  int index(int width) {
    return (row * width) + col;
  }
  
  boolean equals(Object obj) {
    if (obj instanceof Point) {
      Point other = (Point) obj;
      return row == other.row && col == other.col;
    }
    return false;
  }
  
  ArrayList<Point> orthogonalNeighbors(int width, int height) {
    ArrayList<Point> neighbors = new ArrayList<Point>();
    
    if (row > 0) { neighbors.add(new Point(row-1, col)); }
    if (row < height - 1) { neighbors.add(new Point(row+1, col)); }
    if (col > 0) { neighbors.add(new Point(row, col-1)); }
    if (col < width - 1) { neighbors.add(new Point(row, col+1)); }
    
    return neighbors;
  }
  
  static Point fromIndex(int pos, int width) {
    // This assumes scanline ordering!
    // TODO: Make this a lookup on the image so LUT images can reverse it.
    int row = pos / width;
    int col = pos % width;
  
    return new Point(row, col);
  }
}
