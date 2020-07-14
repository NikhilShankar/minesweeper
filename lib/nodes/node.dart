import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/helper/helper.dart';

abstract class Node implements NodeType {

  static Helper helper = new Helper();
  bool isOpened = false;
  bool isFlag = false;
  //for storing the number that it represents.
  var num = new ByteData(4);

  Node(int n) {
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
      return Node.helper.getFlaggedImage();

    if (!isOpened) {
      return Node.helper.getClosedImage();
    }

    return null;
  }

}

class NodeType{
  bool isBomb(){}
  bool isCorrectlyFlagged(){}
  String getPath(){}
}

class BombNode extends Node{

  String path = "";

  BombNode(int n) : super(n);

  @override
  bool isBomb() {
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
    return x != null ? x : Node.helper.getBombImage();
  }

}

class SafeNode extends Node {

  SafeNode(int n) : super(n);

  @override
  bool isBomb() {
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
    return x != null ? x : Node.helper.getSafeNodeImage(getValue());
  }

}


