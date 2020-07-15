import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/helper/helper.dart';
import 'package:mine_sweeper/nodes/game_manager.dart';
import 'package:mine_sweeper/nodes/prefs.dart';
import 'package:mine_sweeper/routes/game_screen.dart';
import 'package:mine_sweeper/widgets/node_widget.dart';

import 'nodes/node.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Oswald',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == GameScreenPage.routeName) {
          // Cast the arguments to the correct type: ScreenArguments.
          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          Level level = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return GameScreenPage(level: level,);
            },
          );
        }
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {}

  Level level = Level.easy;


  @override
  void initState() {
    super.initState();
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
    //const Color(0xff38243E), chatTwo: const Color(0xff6F5A77)
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xff064169),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: new EdgeInsets.fromLTRB(0, 128, 0, 12),
                child: Text(
                  'MINESWEEPER',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: FutureBuilder<String>(
                // get the languageCode, saved in the preferences
                  future: Helper().getHighScore(Level.easy),
                  initialData: 'en',
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return   Text(snapshot.hasData ? 'LEVEL EASY\nBEST TIME : ' + snapshot.data + " seconds":'LEVEL EASY \nNO BEST TIME ESTABLISHED', style: TextStyle(color: Colors.white, fontSize: 16),textAlign: TextAlign.center,);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: FutureBuilder<String>(
                // get the languageCode, saved in the preferences
                  future: Helper().getHighScore(Level.medium),
                  initialData: 'en',
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return   Text(snapshot.hasData ? 'LEVEL HARD\nBEST TIME : ' + snapshot.data + " seconds":'LEVEL HARD \nNO BEST TIME ESTABLISHED', style: TextStyle(color: Colors.white, fontSize: 16),textAlign: TextAlign.center,);
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: ChoiceChip(
                            label: Text("EASY"),
                            selected: level == Level.easy,
                            selectedColor: Colors.white,
                            disabledColor: Colors.black54,
                            onSelected: (bool value) {
                              setState(() {
                                level = Level.easy;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                        child: Text(level == Level.easy ? " << DIFFICULTY " : " DIFFICULTY >> ", style: TextStyle(fontSize: 16, color: Colors.white),),
                      ),
                      Flexible(
                        flex: 1,
                        child: ChoiceChip(
                            label: Text("HARD"),
                            selected: level == Level.medium,
                            selectedColor: Colors.white,
                            onSelected: (bool value) {
                              setState(() {
                                level = Level.medium;
                              });
                            }),
                      ),
                    ],
                  ),
                  Padding(
                      padding: new EdgeInsets.fromLTRB(32, 32, 32, 64),
                      child: FlatButton.icon(
                        padding: EdgeInsets.fromLTRB(6,6,16,6),
                    splashColor: Colors.tealAccent,
                    color: Colors.blueAccent,
                    label: Text(
                      'START GAME',
                      style: TextStyle(
                          fontFamily: 'oswald',
                          fontWeight: FontWeight.normal,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                    icon: Icon(Icons.adb),
                    textColor: Colors.white,
                    onPressed: startGame,
                  )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  startGame() {
    Navigator.pushNamed(context, GameScreenPage.routeName, arguments: level);
  }
}
