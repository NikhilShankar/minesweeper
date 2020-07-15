import 'package:mine_sweeper/nodes/node.dart';

//Abstract Factory Implementation for creating different types
//of node based on the value it needs to hold.
class NodeFactory {

  NodeFactory(){}

  Node getNode(int num) {
    if(num < 8)
      return new SafeNode(num);
    return new BombNode(num);

  }

}