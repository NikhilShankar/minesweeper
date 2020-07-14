import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/node.dart';

class Difficulty {
  bool isHard;
  Difficulty({this.isHard});

  int getBombNum() {
    return isHard ? 10 : 5;
  }

  int getMapWidth() {
    return isHard ? 12 : 8;
  }

  int getMapHeight() {
    return isHard ? 12 : 8;
  }
}