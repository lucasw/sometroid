/*
   Copyright 2013 Lucas Walter

 --------------------------------------------------------------------
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import java.util.Date;

import java.util.Iterator;
import java.util.Map;

float scale = 32.0;

class Level {

  PImage map_im;
  String filename = "level1.png";

  Level() {
    map_im = loadImage(filename);
    println("level: " + filename + " " + map_im.width + " " + map_im.height);
  }

  // xo and yo are the centers of the view in map_im
  // coordinates 
  void draw(float xo, float yo) {
    int x_ext = int(width/scale * 0.5);
    int y_ext = int(height/scale * 0.5);
    draw(xo, yo, 
        int(xo) - x_ext, int(yo) - y_ext, 
        int(xo) + x_ext, int(yo) + y_ext, 
        scale);
  }

  boolean testCollision(int xo, int yo) {
    if (xo < 0) return true;
    if (yo < 0) return true;
    if (xo >= map_im.width) return true;
    if (yo >= map_im.height) return true;

    map_im.loadPixels();

    int ind = yo * map_im.width + xo;

    if (
        (red(map_im.pixels[ind]) == 0) && 
        (green(map_im.pixels[ind]) == 0) &&
        (blue(map_im.pixels[ind]) == 0)) {
      return false;
    }

    return true; 
  }
  
  void draw(float xo, float yo,
      int xmin, int ymin, int xmax, int ymax, float sc) {
    //println("road draw");
    if (map_im == null) {
      println("no level loaded");
      return;
    }
    map_im.loadPixels();
    
    float x_off = width/2  - (sc * (xmax - xmin))/2;
    float y_off = height/2 - (sc * (ymax - ymin))/2;
    //println(x_off + " " + y_off);

    for (int y = ymin; y < ymax; y++) {
      for (int x = xmin; x < xmax; x++) {

        if ((x >= 0) && (x < map_im.width) &&
            (y >= 0) && (y < map_im.height)) {

          final int ind = y * map_im.width + x;

          final float x_scr = x_off + ( (x - xmin) * sc);
          final float y_scr = y_off + ( (y - ymin) * sc);

          //println(str(x) + " " + str(x_scr) + " " + str(y_scr));

          noStroke();
          fill(map_im.pixels[ind]);
          //println(str(ind) + " " + hex(map_im.pixels[ind]));
          rect(x_scr, y_scr, sc, sc + 1);
        }

      } // x
    } // y

  } // draw

}

class Player {
  
  float xo;
  float yo;

  float x_vel;
  float y_vel;
  
  float x_scr;
  float y_scr;

  Player() {
    xo = 10;
    yo = 10;
    x_scr = width/2;
    y_scr = height/2;
  }

  void walk(float dx) {
    x_vel += dx;
  }

  void jump() {
    // can only jump if above solid ground
    if (level.testCollision(int(xo), int(yo + 1))) {
      //println("jump");
      y_vel = -0.3;
    } else {
      //println("no jump");
    } 
  }

  void move(float dx, float dy) {
    // TBD if xo + dx, yo works or the other case then allow it
    if (!level.testCollision(int(xo + dx), int(yo + dy))) {
      xo += dx;
      yo += dy;
    }
  }

  void update() {
    // gravity 
    y_vel += 0.01;
    if (y_vel > 0.1) y_vel = 0.1;
    if (x_vel > 0.1) x_vel = 0.1;
    if (x_vel < -0.1) x_vel = -0.1;
    //if (y_vel < -0.1) y_vel = 0.1;
    
    // collided with floor
    if (level.testCollision(int(xo), int(yo + 1))) {
      if (y_vel > 0)
        y_vel = 0;
      // floor friction
      x_vel *= 0.95;
    } 
    // collided with ceilng
    if (level.testCollision(int(xo), int(yo - 1))) {
      if (y_vel < 0)
        y_vel = 0;
      // ceiling friction
      x_vel *= 0.95;
    } 
    if (level.testCollision(int(xo + 1), int(yo))) {
      if (x_vel > 0)
        x_vel = 0;
    } 
    if (level.testCollision(int(xo - 1), int(yo))) {
      if (x_vel < 0)
        x_vel = 0;
    }
    
    move(x_vel, y_vel);

  } // update

  void draw() {
    fill(255, 100, 100);
    float x_off = xo - int(xo);
    float y_off = yo - int(yo);
    println(x_off + " " +  y_off);
    rect(x_scr, y_scr, scale, scale );
  }
}

Level level;
Player player;

void setup() {
  size(800, 600);
  level = new Level(); 
  player = new Player();
}

void keyPressed() {
  if (key == 'a') {
    player.walk(-0.1);
    //player.move(-1,0);
  }
  if (key == 'd') {
    player.walk(0.1);
    //player.move(1,0);
  }
  if (key == 'w') {
    player.jump();
    //player.move(0,-1);
  }
  if (key == 's') {
    //player.move(0, 1);
  }
}

void draw() {
  background(10,30,0);

  player.update();

  level.draw(player.xo, player.yo);
  player.draw();
}
