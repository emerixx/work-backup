#include "globalVariables.h"
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"
#include <stdbool.h>
#include <unistd.h>

void setUpCamera(){
  camera.position = camera_startPosition;
  camera.target = camera_startTarget;
  camera.up = camera_up;
  camera.fovy = camera_fovy;
  camera.projection = CAMERA_PERSPECTIVE;
}
void setUpTrajectoriesDrawing(){
  trajectoriesImageBuffer = GenImageColor(GetScreenWidth(), GetScreenHeight(), BLACK);
  trajectoriesDisplayTexture = LoadTextureFromImage(trajectoriesImageBuffer);
}