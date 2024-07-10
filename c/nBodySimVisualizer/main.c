#include "drawShapes.h"
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"

#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <time.h>

int const circleResolution = 10;
int const fps = 200;

Image img;
Texture2D texture_usr;
Camera camera = {0};
Color bgColor = BLACK;
Color gridColor = GRAY;
Color bodyColors[3] = {RED, GREEN, BLUE};

float width = 100;
float height = 100;

float depth = 0;


// file related stuff
const int maxFilenameLenght = 40;
const int maxFiles = 20;
int nOfFiles = 0;
int nOfLines = 0;
int nOfBodies = 0;

double currentLinef = 1;
int currentLine;
double drawScale = 20;
double speed = 1;
int isRunning = 1;
int frame = 0;

void getNumberOfFilesAndLines(FILE *file[]);

void readFiles(FILE *file[], double p[nOfFiles][nOfLines][2]);


int main(void) {

  SetTraceLogLevel(4); // disable info
  FILE *file[maxFiles];
  printf("Detecting files, please wait\n");
  getNumberOfFilesAndLines(file);
  printf("Detected %d files, each containing %d lines\n", nOfFiles, nOfLines);
  nOfBodies=nOfFiles;
  double position[nOfFiles][nOfLines][2];
  
  printf("Reading files, please wait\n");
  readFiles(file, position);
  printf("Reading files finished\n");
  sleep(1);
  
  //  set up the window
  InitWindow(1600, 900, "");
  SetTargetFPS(fps);

  img = GenImageColor(32, 32, WHITE);
  texture_usr = LoadTextureFromImage(img);
  UnloadImage(img);

  camera.position = (Vector3){0, 0, 100};
  camera.target = (Vector3){0, 0, 0};
  camera.up = (Vector3){0, 1, 0};
  camera.fovy = 45;
  camera.projection = CAMERA_PERSPECTIVE;


  // game loop
  while (!WindowShouldClose()) {
    frame++;
    // drawing
    BeginDrawing();
    ClearBackground(bgColor);
    DrawFPS(0, 0);
    BeginMode3D(camera);
    
    // draw an XY grid just so we know we are sane
    rlPushMatrix();
    rlRotatef(90, 1, 0, 0); // rotate it so its not going in the Z,Y direction (depth, height) but X,Y (width, height) 
    drawGrid(100, 10, gridColor);
    rlPopMatrix();

    
    currentLine = (int) round(currentLinef);
    for(int i=0; i<nOfBodies; i++){
      
      drawCircle(1, (Vector2){position[i][currentLine][0] * drawScale, position[i][currentLine][1] * drawScale}, bodyColors[i], texture_usr.id, circleResolution);
    }
    
    
    EndMode3D();

    EndDrawing();
    if (speed!=0){
      currentLinef+=speed;
    }

    if (currentLinef == nOfLines || currentLinef == 0){speed=-speed;} 
    


    if (IsKeyPressed(KEY_SPACE)) {
      if(isRunning==0){
        isRunning=1;
      }else{
        isRunning=0;
      }
    }
    if(IsKeyPressed(KEY_RIGHT)){
      speed+=0.1;
    }
    if(IsKeyPressed(KEY_LEFT)){
      speed-=0.1;
    }






    if (frame==fps){
      frame=0;
    }
  }
  // cleanup
  UnloadTexture(texture_usr);
  CloseWindow();
  return 0;
}



void getNumberOfFilesAndLines(FILE *file[]) {
  char filename[maxFilenameLenght];

  for (int i = 0; i < maxFiles; i++) {
    snprintf(filename, maxFilenameLenght, "outputFiles/%d.txt", i + 1);

    file[i] = fopen(filename, "r");

    if (file[i] == NULL) {

      //printf("No more files to open. Stopped at %d.txt\n", i);

      nOfFiles = i;

      break;
    }

    //printf("Opened file: %s\n", filename);
  }

  char c;

  for (c = getc(file[0]); c != EOF; c = getc(file[0]))
    if (c == '\n') // Increment count if this character is newline
      nOfLines = nOfLines + 1;
}

void readFiles(FILE *file[], double p[nOfFiles][nOfLines][2]) {
  size_t len = 2;
  char *line = NULL;

  for (int fileNum = 0; fileNum < nOfFiles; fileNum++) {
    // get number of line in file

    char filename[20] = "";
    snprintf(filename, 20, "outputFiles/%d.txt", fileNum + 1);
    char *out = LoadFileText(filename);

    char *token = strtok(out, "\n");

    // Keep printing tokens while one of the
    // delimiters present in str[].

    token = strtok(NULL, "\n");
    double x, y;

    for (int lineNum = 0; token != NULL; lineNum++) {

      sscanf(token, "[%lf,%lf]", &x, &y);

      p[fileNum][lineNum][0] = x;
      p[fileNum][lineNum][1] = y;

      token = strtok(NULL, "\n");
    }

  }
}
