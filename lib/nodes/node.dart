import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class Node implements NodeType {
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

  int getValue() {
    return num.getInt8(0);
  }

  @override
  bool isFlagged() {
    // TODO: implement isFlagged
    return isFlag;
  }

  void setFlag() {
    isFlag = !isFlag;
  }

}

class NodeType{
  bool isBomb(){}
  bool isCorrectlyFlagged(){}
}

class BombNode extends Node{

  BombNode(int n) : super(n);

  @override
  bool isBomb() {
    // TODO: implement isBomb
    return true;
  }

  @override
  bool isCorrectlyFlagged() {
    // TODO: implement isCorrectlyFlagged
    return super.isFlagged();
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
    // TODO: implement isCorrectlyFlagged
    return !super.isFlagged();
  }

}


