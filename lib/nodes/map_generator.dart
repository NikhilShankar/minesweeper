import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/node.dart';
import 'package:mine_sweeper/nodes/prefs.dart';

import 'node_factory.dart';


class MapGenerator {
  int row;
  int column;
  var map;
  Config config;
  int opened = 0;
  int flagsUsed = 0;
  bool bombPressed = false;
  NodeFactory factory;

  MapGenerator(Config x) {
    this.config = x;
    this.row = x.getMapWidth();
    this.column = x.getMapHeight();
    factory = new NodeFactory();
    map = List.generate(row, (i) => List<Node>(column), growable: false);
  }

  refreshMap() {
    for(int k = 0; k < row ; k ++) {
      for (int l = 0; l < column; l++) {
        map[k][l] = factory.getNode(0);
      }
    }
  }

  refreshFlags() {
    opened = 0;
    flagsUsed = 0;
  }

  List<List<Node>> getNewMap() {
    refreshMap();
    int row = config.getMapWidth();
    int col = config.getMapHeight();
    int totalNodes = row * col;
    Random random = new Random();
    int placedBombs = 0;
    while (placedBombs != config.getBombNum()) {
      //We are not placing bombs in the corners or fence lines.
      //This greatly reduces conditions that we need to check and hence performance improves.
      int rowNum = random.nextInt(row - 2) + 1;
      int colNum = random.nextInt(col - 2) + 1;
      //generating a bomb node;
      Node n = map[rowNum][colNum];
      if (!n.isBomb()) {
        map[rowNum][colNum] = factory.getNode(9);
        placedBombs++;
        for(int k = rowNum - 1; k <= rowNum + 1; k ++) {
          for(int l = colNum - 1; l <= colNum + 1; l ++) {
            if(k == rowNum && l == colNum) {
              continue;
            }
            Node n = map[k][l];
            n.incrementValue();
            map[k][l] = n;
          }
        }
      }
    }
    return map;
  }

  longPress(bool isFlag) {
    if(isFlag)
      flagsUsed++;
    else
      flagsUsed--;
  }

  addOpened() {
    opened++;
  }

  bombIsPressed() {
    bombPressed = true;
  }

  bool gameFinished() {
    return bombPressed || (flagsUsed + opened) == (config.getMapWidth() * config.getMapHeight());
  }

}