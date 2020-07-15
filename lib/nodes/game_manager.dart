import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/helper/helper.dart';
import 'package:mine_sweeper/nodes/node.dart';
import 'package:mine_sweeper/nodes/prefs.dart';

import 'node_factory.dart';

//Game manager handles all game related logic, like points timer etc.
class GameManager {
  int row;
  int column;
  var list;
  Config config;
  int opened = 0;
  int flagsUsed = 0;
  bool bombPressed = false;
  NodeFactory factory;
  int points = 0;
  int time = 0;

  GameManager(Config x) {
    this.config = x;
    this.row = x.getMapWidth();
    this.column = x.getMapHeight();
    factory = new NodeFactory();
    list = List.generate(row, (i) => List<Node>(column), growable: false);
  }

  refreshMap() {
    for(int k = 0; k < row ; k ++) {
      for (int l = 0; l < column; l++) {
        list[k][l] = factory.getNode(0);
      }
    }
  }

  refreshFlags() {
    opened = 0;
    flagsUsed = 0;
    time = 0;
    points = 0;
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
      Node n = list[rowNum][colNum];
      if (!n.isBomb()) {
        list[rowNum][colNum] = factory.getNode(9);
        placedBombs++;
        for(int k = rowNum - 1; k <= rowNum + 1; k ++) {
          for(int l = colNum - 1; l <= colNum + 1; l ++) {
            if(k == rowNum && l == colNum) {
              continue;
            }
            Node n = list[k][l];
            n.incrementValue();
            list[k][l] = n;
          }
        }
      }
    }
    return list;
  }

  longPress(bool isFlag) {
    if(isFlag) {
      flagsUsed++;
      points+=100;
    } else {
      flagsUsed--;
      points-=100;
    }

  }

  addOpened() {
    points += 10;
    opened++;
  }

  bombIsPressed() {
    bombPressed = true;
  }

  bool isBombPressed() {
    return bombPressed;
  }

  bool gameFinished() {
    bool finished =  bombPressed || (flagsUsed + opened) == (config.getMapWidth() * config.getMapHeight());
    if(finished && !bombPressed) {
      print("HI SCORE CREATED");
      Helper().setHiScore(time, config.level);
    }
    return finished;
  }

  openUp(row1, col1) {
    if (row1 >= row || row1 < 0 || col1 >= column || col1 < 0)
      return;
    if (list[row1][col1].isOpened) return;
    if (list[row1][col1].getValue() != 0) {
      list[row1][col1].onTap();
      addOpened();
      return;
    }
    list[row1][col1].onTap();
    addOpened();
    openUp(row1 - 1, col1);
    openUp(row1 + 1, col1);
    openUp(row1, col1 - 1);
    openUp(row1, col1 + 1);
  }

}