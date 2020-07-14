import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/node.dart';

class NodeFactory {

  NodeFactory(){}

  Node getNode(int num) {
    if(num < 8)
      return new SafeNode(num);
    return new BombNode(num);

  }

}