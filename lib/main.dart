import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/map_generator.dart';
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
          return MaterialPageRoute(
            builder: (context) {
              return GameScreenPage();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: new EdgeInsets.fromLTRB(0, 72, 0, 12),
              child: Text(
                'MINESWEEPER',
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: new EdgeInsets.fromLTRB(32, 0, 32, 64),
                child: FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(6,6,16,6),
              splashColor: Colors.tealAccent,
              color: Colors.teal,
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
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  startGame() {
    Navigator.pushNamed(context, GameScreenPage.routeName);
  }
}
