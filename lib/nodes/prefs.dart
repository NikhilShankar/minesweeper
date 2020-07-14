import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/node.dart';

class Config {
  Level level;

  Config({this.level});

  int getBombNum() {
    switch(level) {
      case Level.medium:
        return 40;
      case Level.easy:
        return 10;
    }
  }

  int getMapWidth() {
    switch(level) {
      case Level.medium:
        return 13;
      case Level.easy:
        return 8;
    }
  }

  int getMapHeight() {
    switch(level) {
      case Level.medium:
        return 13;
      case Level.easy:
        return 8;
    }
  }
}

enum Level {
  medium,
  easy
}

