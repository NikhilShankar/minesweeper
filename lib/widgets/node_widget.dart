import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/game_manager.dart';
import 'package:mine_sweeper/nodes/node.dart';
import 'package:mine_sweeper/nodes/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NodeWidget extends StatefulWidget {
  NodeWidget({Key key, this.node}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final Node node;

  @override
  _NodeWidgetState createState() => _NodeWidgetState(node: node);
}

class _NodeWidgetState extends State<NodeWidget> {

  Node node;
  _NodeWidgetState({this.node});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(node.getPath()),
    );
  }

}
