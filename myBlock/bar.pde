float barX = 500.f;
float barY = 600.f;
float barVX = 11.0f;
float barWidth = 200.0f;
float barHeight = 30.0f;
float barHlfWidth = barWidth /2;
float barHlfHeight = barHeight / 2;
color barColor = #00000000;

void moveBar() {
    if(keyPressed){
        float barNewX = barX;
        if(keyCode == RIGHT){
            barNewX = barX + barVX;
        }else if(keyCode == LEFT){
            barNewX = barX - barVX;
        }

        if(0 < barNewX && barNewX < width - barWidth){
            barX = barNewX;
        }
    }
}

void drawBar() {
    fill(barColor);
    rect(barX, barY, barWidth, barHeight);
}

