float ballX; 
float ballY;
float ballLastX = ballX;
float ballLastY = ballY;

float ballV = 6.0f;
float ballVX = cos(PI / 4) * ballV;
float ballVY = sin(PI / 4) * ballV;
float ballMaxDir = PI / 3;

float ballRadius = 10.0f;
float ballDiameter = ballRadius * 2;

color ballColor = #00000000;

void initBall() {
    ballX = barX + barWidth / 2;
    ballY = barY - ballRadius * 2;
}

void moveBall() {
    if(ballX < ballRadius) {
        ballVX = -ballVX;
        ballX = ballRadius;
    } else if(width - ballRadius < ballX) {
        ballVX = -ballVX;
        ballX = width - ballRadius;
    }
    if(ballY < ballRadius){
        ballVY = -ballVY;
        ballY = ballRadius;
    }

    if(hitBoxBox(barX, barY, barWidth, barHeight, ballX - ballRadius / 2, ballY - ballRadius / 2, ballRadius * 2, ballRadius * 2)) {
        float refAngle = (ballX - barX - barHlfWidth) / barHlfWidth * ballMaxDir + PI + PI / 2;
        ballVX = cos(refAngle) * ballV;
        ballVY = sin(refAngle) * ballV;
    }

    if(ballY > height + ballRadius) {
        println("miss!");
        initBall();
    }

    ballX = ballX + ballVX;
    ballY = ballY + ballVY;
}

void drawBall() {
    fill(ballColor);
    ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);
}

