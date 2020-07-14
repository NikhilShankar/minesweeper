import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/node.dart';
import 'package:mine_sweeper/nodes/prefs.dart';


class MapGenerator {
  int row;
  int column;
  var map;
  Difficulty x;

  MapGenerator(int row, int column, Difficulty x) {
    map = List.generate(row, (i) => List(column), growable: false);
  }

  List getNewMap() {
    int row = x.getMapWidth();
    int col = x.getMapHeight();
    int totalNodes = row * col;
    Random random = new Random();
    int placedBombs = 0;
    while (placedBombs != x.getBombNum()) {
      int rowNum = random.nextInt(row);
      int colNum = random.nextInt(col);
    }

  }


}