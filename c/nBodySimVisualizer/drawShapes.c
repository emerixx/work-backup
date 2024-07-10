#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"
#include <math.h>

void drawCircle(double radius, Vector2 center, Color color, unsigned int tId,
                int res) {
  float z = 0.5f;
  double angle;
  rlSetTexture(tId);

  rlBegin(RL_TRIANGLES);
  for (int i = 0; i < res * 2 * PI; i++) {

    rlColor4ub(color.r, color.g, color.b, color.a);
    rlVertex3f(center.x, center.y, z);
    rlVertex3f(center.x + cosf(angle) * radius, center.y + sinf(angle) * radius,
               z);
    rlVertex3f(center.x + cosf((angle + 1.0f / res)) * radius,
               center.y + sinf((angle + 1.0f / res)) * radius, z);

    angle += 1.0f / res;
  }
  rlEnd();
}

void drawGrid(int slices, float spacing, Color color) {

  int halfSlices = slices / 2;

  rlBegin(RL_LINES);
  for (int i = -halfSlices; i <= halfSlices; i++) {

    rlColor3f(color.r / 255.f, color.g / 255.f, color.b / 255.f);

    rlVertex3f((float)i * spacing, 0.0f, (float)-halfSlices * spacing);
    rlVertex3f((float)i * spacing, 0.0f, (float)halfSlices * spacing);

    rlVertex3f((float)-halfSlices * spacing, 0.0f, (float)i * spacing);
    rlVertex3f((float)halfSlices * spacing, 0.0f, (float)i * spacing);
  }
  rlEnd();
}
