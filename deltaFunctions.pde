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

float inverseHsbSquareDelta(color a, color b) {
  // Hue appears to be in the range 0-255 by default
  float hD = abs(hue(a) - hue(b));
  hD = min(hD, 255.0 - hD);
  hD = 128.0 - hD;
  hD = pow(hD, 2);
  float sD = pow(saturation(a) - saturation(b), 2);
  float bD = pow(brightness(a) - brightness(b), 2);
  return hD + sD + bD;
}

abstract class ColorDelta {
  abstract float calculate(color a, color b);
}

class HSBSquareDelta extends ColorDelta {
  float calculate(color a, color b) {
    // Hue appears to be in the range 0-255 by default
    float hD = abs(hue(a) - hue(b));
    hD = pow(min(hD, 255.0 - hD), 2);
    float sD = pow(saturation(a) - saturation(b), 2);
    float bD = pow(brightness(a) - brightness(b), 2);
    return hD + sD + bD;
  }
}
