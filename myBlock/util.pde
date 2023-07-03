boolean hitPointBox(float x1, float y1, float x2, float y2, float w, float h) {
    return (x2 < x1 && x1 < x2 + w) && (y2 < y1 && y1 < y2 + h);
}

boolean hitBoxBox(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    float hlfw1 = w1 / 2;
    float hlfh1 = h1 / 2;
    float hlfw2 = w2 / 2;
    float hlfh2 = h2 / 2;
    float x1c = x1 + hlfw1;
    float y1c = y1 + hlfh1;
    float y2c = y2 + hlfh2;
    float x2c = x2 + hlfw2;

    return abs(x1c - x2c) < hlfw1 + hlfw2 && abs(y1c - y2c) < hlfh1 + hlfh2;
}
