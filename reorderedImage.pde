abstract class ReorderedImage extends PImage {
  private PImage base;
  
  ReorderedImage(PImage source) {
    super(source.width, source.height, source.format);
    base = source;
  }
  
  public void loadPixels() {
    System.out.println("Loading pixels in ReorderedImage");
    base.loadPixels();
    this.pixels = transform(base.pixels);
  }
  
  public void updatePixels() {
    base.pixels = restore(this.pixels);
    base.updatePixels();
  }
  
  // Reorder default pixel ordering to their altered positions
  abstract color[] transform(color[] source);
  
  // Reorder altered pixel ordering to default positions
  abstract color[] restore(color[] target);  
}

abstract class SymmetricReorderedImage extends ReorderedImage {
  SymmetricReorderedImage(PImage source) {
    super(source);
  }
  
  color[] transform(color[] source) {
    return reorder(source); 
  }
  color[] restore(color[] target) {
    return reorder(target); 
  }
  
  abstract color[] reorder(color[] source);
}

class ReversedImage extends SymmetricReorderedImage {
  ReversedImage(PImage source) {
    super(source);
  }
  
  color[] reorder(color[] source) {
    color[] result = new color[source.length];
    for (int i = 0; i < source.length; i++) {
      result[i] = source[source.length - (i+1)];
    }
    return result;
  }
}

class LUTReorderedImage extends ReorderedImage {
  int[] lut;
  
  LUTReorderedImage(PImage source, int[] lut) {
    super(source);
    this.lut = lut;
  }
  
  color[] transform(color[] source) {
    color[] result = new color[source.length];
    for(int i = 0; i < source.length; i++) {
      result[lut[i]] = source[i];
    }
    return result;
    
  }
  color[] restore(color[] target) {
    color[] result = new color[target.length];
    for(int i = 0; i < target.length; i++) {
      result[i] = target[lut[i]];
    }
    return result;
  }
  
  
}

int[] TRANSPOSED_LUT(int width, int height) {
  int[] lut = new int[width * height];
  for(int i = 0; i < lut.length; i++) {
    int sourceX = i % width;
    int sourceY = i / width;
    int targetWidth = height;
    int targetX = sourceY;
    int targetY = sourceX;
    int targetI = (targetY * targetWidth) + targetX;
    lut[i] = targetI;
  }
  return lut;
}
