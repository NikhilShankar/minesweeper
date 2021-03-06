import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/helper/helper.dart';
import 'package:mine_sweeper/cells/cell.dart';
import 'package:mine_sweeper/cells/prefs.dart';

import 'cell_factory.dart';

//Game manager handles all game related logic, like points timer etc.
class GameManager {
  int row;
  int column;
  var list;
  Config config;
  int opened = 0;
  int flagsUsed = 0;
  bool minePressed = false;
  CellFactory factory;
  int points = 0;
  int time = 0;

  GameManager(Config x) {
    this.config = x;
    this.row = x.getMapWidth();
    this.column = x.getMapHeight();
    factory = new CellFactory();
    list = List.generate(row, (i) => List<Cell>(column), growable: false);
  }

  refreshMap() {
    for(int k = 0; k < row ; k ++) {
      for (int l = 0; l < column; l++) {
        list[k][l] = factory.getCell(0);
      }
    }
  }

  List<List<Cell>> getNewMap() {
    refreshMap();
    int row = config.getMapWidth();
    int col = config.getMapHeight();
    Random random = new Random();
    int placedBombs = 0;
    while (placedBombs != config.getMineNumber()) {
      //We are not placing bombs in the corners or fence lines.
      //This greatly reduces conditions that we need to check and hence performance improves.
      int rowNum = random.nextInt(row - 2) + 1;
      int colNum = random.nextInt(col - 2) + 1;
      //generating a bomb node;
      Cell n = list[rowNum][colNum];
      if (!n.isMine()) {
        list[rowNum][colNum] = factory.getCell(9);
        placedBombs++;
        for(int k = rowNum - 1; k <= rowNum + 1; k ++) {
          for(int l = colNum - 1; l <= colNum + 1; l ++) {
            if(k == rowNum && l == colNum) {
              continue;
            }
            Cell n = list[k][l];
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

  mineIsPressed() {
    minePressed = true;
  }

  bool isMinePressed() {
    return minePressed;
  }

  bool gameFinished() {
    bool finished =  minePressed || (flagsUsed + opened) == (config.getMapWidth() * config.getMapHeight());
    if(finished && !minePressed) {
      print("HI SCORE CREATED");
      Helper().setHiScore(time, config.level);
    }
    return finished;
  }

  //Implementation of flood fill algorithm using recursion.
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