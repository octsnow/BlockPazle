import processing.sound.*;

String[] files = {
    "./sounds/hit.wav",
    "./sounds/linked1.mp3",
    "./sounds/linked2.mp3",
    "./sounds/linked3.mp3",
    "./sounds/linked4.mp3"
};

SoundFile[] player = new SoundFile[files.length];

void initAudio() {
    for(int i = 0; i < files.length; i++) {
        player[i] = new SoundFile(this, files[i]);
    }
} 

void play(int i) {
    player[i].play(1.0f, 0.5, 1.0f);
}

