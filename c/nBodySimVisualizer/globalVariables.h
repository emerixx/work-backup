#ifndef VARS_H
#define VARS_H
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"
#include <math.h>

// window setup
extern const int windowWidth;
extern const int windowHeight;
extern const char windowTitle;

// graphics setup
extern const int circleResolution;
extern const int fps;
extern const Vector2 drawScale;
extern Image img;
extern Texture2D texture_usr;
extern Camera camera;
extern const Color bgColor;
extern const Color gridColor;
extern const int gridSpacing;
extern const Color bodyColors[];
extern const float bodyRadius;
extern Image trajectoriesImageBuffer;
extern Texture trajectoriesDisplayTexture;

// camera setup
extern const int camera_fovy;
extern const Vector3 camera_up;
extern const Vector3 camera_startPosition;
extern const Vector3 camera_startTarget;

// file related stuff
extern const int maxFilenameLenght;
extern const int maxFiles;
extern int nOfFiles;
extern int nOfLines;
extern int nOfBodies;

// controlling stuff
extern const int baseMove;
extern const float baseSpeedAdd;
extern double currentLinef;
extern int currentLine;
extern double speed;
extern bool isRunning;
extern float keyModifier;
extern bool drawTrajectories;

#endif // VARS_H