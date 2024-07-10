#ifndef MYHEADER_H
#define MYHEADER_H
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"
#include <math.h>

void drawCircle(double radius, Vector2 center, Color color, unsigned int tId, int res);
void drawGrid(int slices, float spacing, Color color);

#endif // MYHEADER_H