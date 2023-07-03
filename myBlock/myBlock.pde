int last_time;

float distance(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
}

void setup() {
    size(1280, 720);
    initBlocks();
    initBall();

    last_time = millis();
}

void draw() {
    background(255, 255, 255);

    ballLastX = ballX;
    ballLastY = ballY;

    moveBar();
    moveBall();
    moveBlock();

    checkHitBlock();

    drawBar();
    drawBall();
    drawBlock();

    last_time = millis();
}
