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
  Difficulty x;
  NodeFactory factory;

  MapGenerator(Difficulty x) {
    this.x = x;
    this.row = x.getMapWidth();
    this.column = x.getMapHeight();
    factory = new NodeFactory();
    map = List.generate(row, (i) => List<Node>(column), growable: false);
    for(int k = 0; k < row ; k ++) {
      for (int l = 0; l < column; l++) {
        map[k][l] = factory.getNode(0);
      }
    }
  }

  List<List<Node>> getNewMap() {
    int row = x.getMapWidth();
    int col = x.getMapHeight();
    int totalNodes = row * col;
    Random random = new Random();
    int placedBombs = 0;

    while (placedBombs != x.getBombNum()) {
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
            print("Value" + n.getValue().toString() + " hash : " + n.hashCode.toString());
            map[k][l] = n;
          }
        }
      }
    }

    return map;

  }

}