final int BLOCK_NUM_ROWS = 10;
final int BLOCK_NUM_COLS = 30;
final int BLOCK_MAX_LINKED = 4;
final int BLOCK_ANIMATION_LINKED_TIME = 1300;
final int MAX_BLOCKS = BLOCK_NUM_ROWS * BLOCK_NUM_COLS;
final int BLOCK_ANIMATION_LINKED = 0x8000;
final float BLOCK_FALL_SPEED = 1.0f;
float[] blockX = new float[MAX_BLOCKS];
float[] blockY = new float[MAX_BLOCKS];
float[] blockOffsetY = new float[MAX_BLOCKS];
int[] blockEffect = new int[MAX_BLOCKS];
float blockWidth = 30.0f;
float blockHeight = 20.0f;
float blockHlfWidth = blockWidth / 2;
float blockHlfHeight = blockHeight / 2;
boolean[] hitFlag = new boolean[MAX_BLOCKS];
int[] blockColor = new int[MAX_BLOCKS];
int[] blockCount = new int[MAX_BLOCKS];
float blocksOffsetX;
float blocksOffsetY = 100;
color[] colorList = {
    #F24C3D,
    #6527BE,
    #00DFA2,
    #0079FF,
    #F6FA70
};

void initBlocks() {
    ArrayList<ArrayList<Integer>> linkedBlocksList;

    for(int i = 0; i < MAX_BLOCKS; i++) {
        blockCount[i] = colorList.length;
        blockColor[i] = (int)random(colorList.length);
    }

    do {
        linkedBlocksList = getLinkedBlock();
        for(ArrayList<Integer> linkedBlocks : linkedBlocksList) {
            for(int i : linkedBlocks) {
                blockColor[i] = (int)random(colorList.length);
            }
        }
    } while(linkedBlocksList.size() > 0);

    blocksOffsetX = (width - (BLOCK_NUM_COLS * blockWidth)) / 2;
}

void checkHitBlock() {
    float ballLeft = ballX - ballRadius;
    float ballTop = ballY - ballRadius;
    int bXi = (int)((ballLeft - blocksOffsetX) / blockWidth);
    int bYi = (int)((ballTop - blocksOffsetY) / blockHeight);
    boolean isHlz = false, isVrt = false;

    for(int y = bYi; y < bYi + ballDiameter / blockHeight; y++) {
        for(int x = bXi; x < bXi + ballDiameter / blockWidth; x++) {
            if(x < 0 || x >= BLOCK_NUM_COLS
            || y < 0 || y >= BLOCK_NUM_ROWS) continue;

            int i = y * BLOCK_NUM_COLS + x;
            float bX = x * blockWidth + blocksOffsetX;
            float bY = y * blockHeight + blocksOffsetY;

            if(blockCount[i] <= 0) continue;

            if(hitBoxBox(bX, bY, blockWidth, blockHeight, ballX - ballRadius, ballY - ballRadius, ballDiameter, ballDiameter)) {
                blockCount[i]--;
                blockColor[i] = (blockColor[i] + 1) % colorList.length;
                if(bX < ballLastX && ballLastX < bX + blockWidth) {
                    isHlz = true;
                    isVrt = false;
                } else if(bY < ballLastY && ballLastY < bY + blockHeight) {
                    isHlz = false;
                    isVrt = true;
                } else if(!isHlz && !isVrt) {
                    isHlz = true;
                    isVrt = true;
                }
            }
        }
    }

    if(isVrt) ballVX = -ballVX;
    if(isHlz) ballVY = -ballVY;
}

void fallBlock() {
    for(int i = MAX_BLOCKS - 1; i >= 0; i--) {
        boolean isFall = false;
        int j;

        for(j = i + BLOCK_NUM_COLS; j < MAX_BLOCKS; j += BLOCK_NUM_COLS) {
            if(blockCount[j] <= 0) {
                isFall = true;
            } else {
                break;
            }
        }

        if(isFall) {
            j -= BLOCK_NUM_COLS;
            blockColor[j] = blockColor[i];
            blockCount[j] = blockCount[i];
            blockCount[i] = 0;
            blockOffsetY[i] = -(j - i) / BLOCK_NUM_COLS * blockHeight;
        }
    }
}

void checkLinkedBlock() {
    ArrayList<ArrayList<Integer>> linkedBlocksList = getLinkedBlock();

    for(ArrayList<Integer> linkedBlocks : linkedBlocksList) {
       for(int i : linkedBlocks) {
            blockEffect[i] = BLOCK_ANIMATION_LINKED;
        }
    }
}
ArrayList<ArrayList<Integer>> getLinkedBlock() {
    ArrayList<ArrayList<Integer>> linkedBlocksList = new ArrayList<ArrayList<Integer>>();
    int[] checkBlocks = new int[MAX_BLOCKS];
    boolean isLinked = false;

    for(int y = 0; y < BLOCK_NUM_ROWS; y++) {
        for(int x = 0; x < BLOCK_NUM_COLS; x++) {
            int i = y * BLOCK_NUM_COLS + x;
            ArrayList<Integer> linkedBlocks = new ArrayList<Integer>();

            if(checkBlocks[i] != 0) continue;
            if(blockCount[i] <= 0) continue;
            if(blockOffsetY[i] != 0) continue;
            if(blockEffect[i] != 0) continue;

            linkedBlocks = checkLinked(x, y, blockColor[i], linkedBlocks, checkBlocks);
            if(linkedBlocks.size() >= BLOCK_MAX_LINKED) {
                linkedBlocksList.add(linkedBlocks);
            }
         
        }
    }

    return linkedBlocksList;
}

ArrayList<Integer> checkLinked(int x, int y, int checkColor, ArrayList<Integer> linkedBlocks, int[] checkBlocks) {
    checkBlocks[y * BLOCK_NUM_COLS + x] = 1;
    linkedBlocks.add(y * BLOCK_NUM_COLS + x);

    if(x - 1 >= 0) {
        int i = y * BLOCK_NUM_COLS + (x - 1);

        if(blockCount[i] > 0
        && checkBlocks[i] == 0
        && blockOffsetY[i] == 0
        && blockColor[i] == checkColor) {
            linkedBlocks = checkLinked(x - 1, y, checkColor, linkedBlocks, checkBlocks);
        }
    }

    if(x + 1 < BLOCK_NUM_COLS) {
        int i = y * BLOCK_NUM_COLS + (x + 1);

        if(blockCount[i] > 0
        && checkBlocks[i] == 0
        && blockOffsetY[i] == 0
        && blockColor[i] == checkColor) {
            linkedBlocks = checkLinked(x + 1, y, checkColor, linkedBlocks, checkBlocks);
        } 
    }

    if(y - 1 >= 0) {
        int i = (y - 1) * BLOCK_NUM_COLS + x;

        if(blockCount[i] > 0
        && checkBlocks[i] == 0
        && blockOffsetY[i] == 0
        && blockColor[i] == checkColor) {
            linkedBlocks = checkLinked(x, y - 1, checkColor, linkedBlocks, checkBlocks);
        }
    }

    if(y + 1 < BLOCK_NUM_ROWS) {
        int i = (y + 1) * BLOCK_NUM_COLS + x;

        if(blockCount[i] > 0
        && checkBlocks[i] == 0
        && blockOffsetY[i] == 0 
        && blockColor[i] == checkColor) {
            linkedBlocks = checkLinked(x, y + 1, checkColor, linkedBlocks, checkBlocks);
        }
    }

    return linkedBlocks;
}

void moveBlock() {
    for(int i = 0; i < MAX_BLOCKS; i++) {
        if(blockOffsetY[i] < 0) {
            blockOffsetY[i] += BLOCK_FALL_SPEED;
            if(blockOffsetY[i] > 0) blockOffsetY[i] = 0;
        }
    }

    checkLinkedBlock();
    fallBlock();
}

void drawBlock() {
    int i = 0;
    for(int y = 0; y < BLOCK_NUM_ROWS; y++) {
        for(int x = 0; x < BLOCK_NUM_COLS; x++) {
            if(blockCount[i] > 0) {
                fill(colorList[blockColor[i]]);

                if((blockEffect[i] & BLOCK_ANIMATION_LINKED) > 0) {
                    int animationValue = blockEffect[i] & 0xFFFF;
                    float s = (float)(0xFFFF - animationValue) / 0xFFFF;
                    animationValue += (float)(millis() - last_time) / BLOCK_ANIMATION_LINKED_TIME * 0xFFFF;
                    blockEffect[i] = BLOCK_ANIMATION_LINKED | (int)(animationValue & 0xFFFF);
 
                    if(animationValue >= 0xFFFF) {
                        blockCount[i] = 0;
                        blockEffect[i] = 0;
                    }

                    rect(
                        (x * 2 - s + 1) * blockHlfWidth + blocksOffsetX,
                        (y * 2 - s + 1) * blockHlfHeight + blocksOffsetY,
                        blockWidth * s,
                        blockHeight * s
                    );
                } else {
                    rect(
                        x * blockWidth + blocksOffsetX,
                        y * blockHeight + blocksOffsetY + blockOffsetY[i],
                        blockWidth,
                        blockHeight);
                }
            }

            i++;
        }
    }
}