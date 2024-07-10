#include "globalVariables.h"
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"
#include <stdbool.h>
#include <unistd.h>

// window setup
const int windowWidth = 1600;
const int windowHeight = 900;
const char windowTitle = ' ';

// graphics setup
const int circleResolution = 10;
const int fps = 200;
const Vector2 drawScale = (Vector2) {100, 100};
Image img;
Texture2D texture_usr;
Camera camera = {0};
const Color bgColor = BLACK;
const Color gridColor = GRAY;
const int gridSpacing = 50;
const Color bodyColors[3] = {RED, GREEN, BLUE};
const float bodyRadius = 2.5;

Image trajectoriesImageBuffer;
Texture trajectoriesDisplayTexture;

// camera setup
const int camera_fovy = 60;
const Vector3 camera_up = (Vector3){0, 1, 0};
const Vector3 camera_startPosition = (Vector3){0, 0, 250};
const Vector3 camera_startTarget = (Vector3){0, 0, 0};

// file related stuff
const int maxFilenameLenght = 40;
const int maxFiles = 20;
int nOfFiles = 0;
int nOfLines = 0;
int nOfBodies = 0;

// controlling stuff
const int baseMove = 10;
const float baseSpeedAdd = 10;
int currentLine;
double currentLinef = 1;
float keyModifier;
double speed = 100;
bool isRunning = true;
bool drawTrajectories = true;
