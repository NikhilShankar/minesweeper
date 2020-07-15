import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/game_manager.dart';
import 'package:mine_sweeper/nodes/node.dart';
import 'package:mine_sweeper/nodes/prefs.dart';
import 'package:mine_sweeper/widgets/node_widget.dart';

import 'dart:async';

import 'package:path/path.dart';

class GameScreenPage extends StatefulWidget {
  static final routeName = "/gamescreen";

  Level level = Level.easy;

  GameScreenPage({Key key, this.title, this.level}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _GameScreenPageState createState() => _GameScreenPageState(level: level);
}

class _GameScreenPageState extends State<GameScreenPage> {
  Level level = Level.easy;
  Config diff;
  GameManager gameManager;
  List<List<Node>> list;
  Timer timer1;
  _GameScreenPageState({this.level}) ;

  @override
  void initState() {
    super.initState();
    diff = new Config(level: level);
    gameManager = new GameManager(diff);
    list = gameManager.getNewMap();
    timer1 = Timer.periodic(Duration(seconds: 1), (timer) {
      gameManager.time++;
      if (gameManager.gameFinished()) {
        timer.cancel();
        return;
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    gameManager = null;
    timer1.cancel();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.blueAccent,
                const Color(0xff064169),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
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
                          gameManager.points.toString(),
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
                          gameManager.time.toString() + 's',
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
                    Center(
                      child: Opacity(
                        opacity: gameManager.gameFinished() ? 0.2 : 1,
                        child: IgnorePointer(
                            ignoring: gameManager.gameFinished(),
                            child: GridView.builder(
                              padding: EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: gameManager.column * gameManager.row,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gameManager.column,
                              ),
                              itemBuilder: (context, position) {
                                int cPos = position;
                                int row = (cPos / gameManager.column).toInt();
                                int col = cPos % gameManager.column;
                                return InkWell(
                                  child: new NodeWidget(node: list[row][col]),
                                  onLongPress: (() {
                                    bool isFlag = list[row][col].setFlag();
                                    gameManager.longPress(isFlag);
                                    print("Finished" +
                                        gameManager.gameFinished().toString());
                                    setState(() {});
                                  }),
                                  onTap: (() {
                                    if (list[row][col].isBomb()) {
                                      list[row][col].onTap();
                                      gameManager.bombIsPressed();
                                    } else {
                                      gameManager.openUp(row, col);
                                    }
                                    print("Finished" +
                                        gameManager.gameFinished().toString());
                                    //list[row][col].onTap()
                                    setState(() {});
                                  }),
                                );
                              },
                            )),
                      ),
                    ),

                    Center(
                      child: IgnorePointer(
                        ignoring: !gameManager.gameFinished(),
                        child: Opacity(
                          opacity: gameManager.gameFinished() ? 1 : 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Align(
                                child: Text(gameManager.isBombPressed() ? 'YOU LOSE' :'YOU WIN', style: TextStyle(color: Colors.white, fontSize: 32),),
                                alignment: Alignment.center,
                              ),

                              FlatButton.icon(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  mainMenu(BuildContext context) {
    Navigator.of(context).pop();
  }
}
