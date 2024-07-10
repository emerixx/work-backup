#include "globalVariables.h"
#include "main.h"
#include "raylib/src/raylib.h"
#include "raylib/src/rlgl.h"

float move = 0;

void setKeyModifier_kb() {

  if (IsKeyDown(KEY_LEFT_SHIFT)) {
    keyModifier = 2.f;
  } else if (IsKeyDown(KEY_LEFT_CONTROL)) {
    keyModifier = 5.f;
  } else {
    keyModifier = 1.f;
  }
}
void setIsRunning_kb() {
  if (IsKeyPressed(KEY_SPACE)) {
    isRunning = !isRunning;
  }
}
void setDrawTrajectories() {
  if (IsKeyPressed(KEY_T)) {
    drawTrajectories = !drawTrajectories;
  }
}

void setSpeed_kb() {
  if (IsKeyPressed(KEY_D)) {
    float add = baseSpeedAdd * keyModifier;
    speed += add;
  }
  if (IsKeyPressed(KEY_A)) {
    float add = baseSpeedAdd * keyModifier;
    speed -= add;
  }
}

void setCameraMoveX_kb() {

  if (IsKeyPressed(KEY_LEFT)) {

    camera.position = (Vector3){camera.position.x - move, camera.position.y,
                                camera.position.z};
    camera.target =
        (Vector3){camera.target.x - move, camera.target.y, camera.target.z};
  }
  if (IsKeyPressed(KEY_RIGHT)) {

    camera.position = (Vector3){camera.position.x + move, camera.position.y,
                                camera.position.z};
    camera.target =
        (Vector3){camera.target.x + move, camera.target.y, camera.target.z};
  }
}
void setCameraMoveY_kb() {

  if (IsKeyPressed(KEY_UP)) {

    camera.position = (Vector3){camera.position.x, camera.position.y + move,
                                camera.position.z};
    camera.target =
        (Vector3){camera.target.x, camera.target.y + move, camera.target.z};
  }
  if (IsKeyPressed(KEY_DOWN)) {

    camera.position = (Vector3){camera.position.x, camera.position.y - move,
                                camera.position.z};
    camera.target =
        (Vector3){camera.target.x, camera.target.y - move, camera.target.z};
  }
}
void setCameraMoveZ_kb() {
  if (IsKeyPressed(KEY_W)) {

    camera.position = (Vector3){camera.position.x, camera.position.y,
                                camera.position.z - move};
    camera.target =
        (Vector3){camera.target.x, camera.target.y, camera.target.z - move};
  }
  if (IsKeyPressed(KEY_S)) {

    camera.position = (Vector3){camera.position.x, camera.position.y,
                                camera.position.z + move};
    camera.target =
        (Vector3){camera.target.x, camera.target.y, camera.target.z + move};
  }
}

void setCameraMove_kb() {
  move = baseMove * keyModifier;
  setCameraMoveX_kb();
  setCameraMoveY_kb();
  setCameraMoveZ_kb();
}

void setAll_kb(){
  setKeyModifier_kb();

    setIsRunning_kb();

    setSpeed_kb();

    setCameraMove_kb();

    setDrawTrajectories();

}
