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

  float x_scr;
  float y_scr;

  Player() {
    xo = 10;
    yo = 10;
    x_scr = width/2;
    y_scr = height/2;
  }

  void move (float dx, float dy) {
    xo += dx;
    yo += dy;
  }

  void draw() {
    fill(255, 100, 100);
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
    player.move(-1,0);
  }
  if (key == 'd') {
    player.move(1,0);
  }
  if (key == 'w') {
    player.move(0,-1);
  }
  if (key == 's') {
    player.move(0, 1);
  }
}

void draw() {
  background(10,30,0);

  level.draw(player.xo, player.yo);
  player.draw();
}
