#include "cameraStuff.h"
#include "drawShapes.h"
#include "globalVariables.h"
#include "keybinds.h"
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

void getNumberOfFilesAndLines(FILE *file[]);

void readFiles(FILE *file[], double p[nOfFiles][nOfLines][2]);

int main(void) {
  FILE *file[maxFiles];
  SetTraceLogLevel(4); // disable info

  printf("Detecting files, please wait\n");
  getNumberOfFilesAndLines(file);
  printf("Detected %d files, each containing %d lines\n", nOfFiles, nOfLines);
  nOfBodies = nOfFiles;
  double position[nOfFiles][nOfLines][2];

  printf("Reading files, please wait\n");
  readFiles(file, position);
  printf("Reading files finished\n");
  sleep(1);

  //  set up the window
  InitWindow(windowWidth, windowHeight, &windowTitle);
  SetTargetFPS(fps);

  img = GenImageColor(32, 32, WHITE);
  texture_usr = LoadTextureFromImage(img);
  UnloadImage(img);

  setUpCamera();
  setUpTrajectoriesDrawing();

  // game loop
  while (!WindowShouldClose()) {
    // drawing
    BeginDrawing();
    ClearBackground(bgColor);
    DrawFPS(0, 0);
    if (drawTrajectories) {
      
      DrawTexture(trajectoriesDisplayTexture, 0, 0, WHITE);
    }
    BeginMode3D(camera);

    // draw an XY grid just so we know we are sane
    rlPushMatrix();
    rlRotatef(90, 1, 0, 0); // rotate it so its not going in the Z,Y direction
                            // (depth, height) but X,Y (width, height)
    drawGrid(1000, gridSpacing, gridColor);
    rlPopMatrix();

    currentLine = (int)round(currentLinef);
    for (int i = 0; i < nOfBodies; i++) {

      drawCircle(bodyRadius,
                 (Vector2){position[i][currentLine][0] * drawScale.x,
                           position[i][currentLine][1] * drawScale.y},
                 bodyColors[i], texture_usr.id, circleResolution);
      ImageDrawPixel(&trajectoriesImageBuffer,
                     (int)((float)windowWidth / 2 +
                           (position[i][currentLine][0]) * drawScale.x),
                     (int)((float)windowHeight / 2 -
                           (position[i][currentLine][1]) * drawScale.y),
                     bodyColors[i]);
    }
    UpdateTexture(trajectoriesDisplayTexture, trajectoriesImageBuffer.data);

    

    EndMode3D();

    

    EndDrawing();
    if (currentLinef + speed / 100 * isRunning >= 0) {
      currentLinef += speed / 100 * isRunning;
    } else {
      currentLine = 1;
      isRunning = 0;
    }

    // keybinding stuff
    setAll_kb();
  }
  // cleanup
  UnloadImage(trajectoriesImageBuffer);
  UnloadTexture(texture_usr);
  UnloadTexture(trajectoriesDisplayTexture);
  CloseWindow();
  return 0;
}

void getNumberOfFilesAndLines(FILE *file[]) {
  char filename[maxFilenameLenght];

  for (int i = 0; i < maxFiles; i++) {
    snprintf(filename, maxFilenameLenght, "outputFiles/%d.txt", i + 1);

    file[i] = fopen(filename, "r");

    if (file[i] == NULL) {

      // printf("No more files to open. Stopped at %d.txt\n", i);

      nOfFiles = i;

      break;
    }

    // printf("Opened file: %s\n", filename);
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
