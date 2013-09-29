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
    float scale = 20.0;
    draw(xo, yo, 
        int(xo) - 10, int(yo) - 10, 
        int(xo) + 10, int(yo) + 10, scale);
  }

  void draw(float xo, float yo,
      int xmin, int ymin, int xmax, int ymax, float sc) {
    //println("road draw");
    if (map_im == null) {
      println("no level loaded");
      return;
    }
    map_im.loadPixels();
    for (int y = ymin; y < ymax; y++) {
      for (int x = xmin; x < xmax; x++) {

        if ((x >= 0) && (x < map_im.width) &&
            (y >= 0) && (y < map_im.height)) {

          final int ind = y * map_im.width + x;

          final float x_scr = ( (x - xmin) * sc);
          final float y_scr = ( (y - ymin) * sc);

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

Level level;
float xo;
float yo;

void setup() {
  size(800, 600);
  level = new Level(); 
  xo = 10;
  yo = 10;
}

void keyPressed() {
  if (key == 'a') {
    xo -= 1;
  }
  if (key == 'd') {
    xo += 1;
  }
  if (key == 'w') {
    yo -= 1;
  }
  if (key == 's') {
    yo += 1;
  }
}

void draw() {
  background(0);

  level.draw(xo, yo);
}
