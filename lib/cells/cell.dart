import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/helper/helper.dart';

abstract class Cell implements CellType {

  static Helper helper = new Helper();
  bool isOpened = false;
  bool isFlag = false;
  //for storing the number that it represents.
  var num = new ByteData(1);

  Cell(int n) {
    if(n > 9) {
      throw ("Unsupported value");
    }
    else num.setInt8(0, n);
  }

  onTap() {
    isOpened = true;
  }

  int getValue() {
    return num.getInt8(0);
  }

  int incrementValue() {
    num.setInt8(0, num.getUint8(0) + 1);
  }

  @override
  bool isFlagged() {
    // TODO: implement isFlagged
    return isFlag;
  }

  bool setFlag() {
    isFlag = !isFlag;
    return isFlag;
  }

  @override
  String getPath() {
    // TODO: implement getPath
    if (isFlagged())
      return Cell.helper.getFlaggedImage();

    if (!isOpened) {
      return Cell.helper.getClosedImage();
    }

    return null;
  }

}

class CellType{
  bool isMine(){}
  bool isCorrectlyFlagged(){}
  String getPath(){}
}

//Concrete implementation of Cell
//which is mine.
class MineCell extends Cell{

  String path = "";

  MineCell(int n) : super(n);

  @override
  bool isMine() {
    // TODO: implement isBomb
    return true;
  }

  @override
  bool isCorrectlyFlagged() {
    return super.isFlagged();
  }

  @override
  String getPath() {
    String x = super.getPath();
    return x != null ? x : Cell.helper.getBombImage();
  }

}

//Concrete implementation of Cell
//which is safe.
class SafeCell extends Cell {

  SafeCell(int n) : super(n);

  @override
  bool isMine() {
    // TODO: implement isBomb
    return false;
  }

  @override
  bool isCorrectlyFlagged() {
    return !super.isFlagged();
  }

  @override
  String getPath() {
    String x = super.getPath();
    return x != null ? x : Cell.helper.getSafeCellImage(getValue());
  }

}


