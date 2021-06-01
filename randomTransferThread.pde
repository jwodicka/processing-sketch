class RandomTransferThread extends ProcessorThread {
  private PImage target;
  private ColorDelta algorithm;

  RandomTransferThread(PImage canvas, PImage target, ColorDelta algorithm) {
    super(canvas);
    this.target = target;
    this.algorithm = algorithm;
  }

  public void run() {
    IntList indices = new IntList();
    canvas.loadPixels();
    for (int i = 0; i < canvas.pixels.length; i++) {
      indices.append(i);
    }

    while (true) {
      indices.shuffle();
      canvas.loadPixels();
      for (int a = 0; a < canvas.pixels.length; a++) {
        int b = indices.get(a);

        color aCVal = canvas.pixels[a];
        color bCVal = canvas.pixels[b];

        color aTVal = target.pixels[a];
        color bTVal = target.pixels[b];

        float currDelta = algorithm.calculate(aCVal, aTVal) + algorithm.calculate(bCVal, bTVal);
        float swapDelta = algorithm.calculate(aCVal, bTVal) + algorithm.calculate(bCVal, aTVal);

        if (swapDelta < currDelta) {
          swap(canvas, a, b);
        }
      }
      randomTransferCanvas.updatePixels();
    }
  }
}
