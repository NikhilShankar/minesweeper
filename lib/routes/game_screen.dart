import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/map_generator.dart';
import 'package:mine_sweeper/nodes/node.dart';
import 'package:mine_sweeper/nodes/prefs.dart';
import 'package:mine_sweeper/widgets/node_widget.dart';

import 'dart:async';

import 'package:path/path.dart';

class GameScreenPage extends StatefulWidget {
  static final routeName = "/gamescreen";

  GameScreenPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _GameScreenPageState createState() => _GameScreenPageState();
}

class _GameScreenPageState extends State<GameScreenPage> {
  int _counter = 0;
  Config diff = new Config(level: Level.medium);
  MapGenerator generator;
  List<List<Node>> list;
  int seconds = 0;

  _GameScreenPageState() {}

  @override
  void initState() {
    super.initState();
    generator = new MapGenerator(diff);
    list = generator.getNewMap();
    Timer.periodic(Duration(seconds: 1), (timer) {
      seconds++;
      setState(() {});
      if (generator.gameFinished()) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: new EdgeInsets.fromLTRB(0, 72, 0, 12),
              child: Text(
                'MINESWEEPER',
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: new EdgeInsets.fromLTRB(0, 24, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'POINTS SCORED',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        '123',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'TIME ELAPSED',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        seconds.toString() + 's',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ]),
              ],
            ),
          ),
          Expanded(
            child: Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Opacity(
                    opacity: generator.gameFinished() ? 0.5 : 1,
                    child: IgnorePointer(
                        ignoring: generator.gameFinished(),
                        child: GridView.builder(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: generator.column * generator.row,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: generator.column,
                          ),
                          itemBuilder: (context, position) {
                            int cPos = position;
                            int row = (cPos / generator.column).toInt();
                            int col = cPos % generator.column;
                            return InkWell(
                              child: new NodeWidget(node: list[row][col]),
                              onLongPress: (() {
                                bool isFlag = list[row][col].setFlag();
                                generator.longPress(isFlag);
                                print("Finished" +
                                    generator.gameFinished().toString());
                                setState(() {});
                              }),
                              onTap: (() {
                                if (list[row][col].isBomb()) {
                                  list[row][col].onTap();
                                  generator.bombIsPressed();
                                } else {
                                  openUp(row, col);
                                }
                                print("Finished" +
                                    generator.gameFinished().toString());
                                //list[row][col].onTap()
                                setState(() {});
                              }),
                            );
                          },
                        )),
                  ),

                  Center(
                    child: Opacity(
                      opacity: generator.gameFinished() ? 1 : 0,
                      child: IgnorePointer(
                        ignoring: !generator.gameFinished(),
                        child: FlatButton.icon(
                            padding: EdgeInsets.fromLTRB(6,6,16,6),
                            splashColor: Colors.tealAccent,
                          color: Colors.teal,
                          label: Text(
                            'MAIN MENU',
                            style: TextStyle(
                                fontFamily: 'oswald',
                                fontWeight: FontWeight.normal,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                          icon: Icon(Icons.adb),
                          textColor: Colors.white,
                          onPressed: (() {
                            mainMenu(context);
                          })
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  openUp(row, col) {
    if (row >= generator.row || row < 0 || col >= generator.column || col < 0)
      return;
    if (list[row][col].isOpened) return;
    if (list[row][col].getValue() != 0) {
      list[row][col].onTap();
      generator.addOpened();
      return;
    }
    list[row][col].onTap();
    generator.addOpened();
    openUp(row - 1, col);
    openUp(row + 1, col);
    openUp(row, col - 1);
    openUp(row, col + 1);
  }

  void startNewGame() {
    list = generator.getNewMap();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  mainMenu(BuildContext context) {
    Navigator.of(context).pop();
  }
}
