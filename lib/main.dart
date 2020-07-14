import 'package:flutter/material.dart';
import 'package:mine_sweeper/nodes/map_generator.dart';
import 'package:mine_sweeper/nodes/prefs.dart';
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
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
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
  int _counter = 0;
  Config diff = new Config(level: Level.medium);
  MapGenerator generator;
  List<List<Node>> list;

  _MyHomePageState() {
    generator = new MapGenerator(diff);
    list =  generator.getNewMap();
    print("Hash" + list.hashCode.toString());
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView.builder(
          padding: EdgeInsets.all(5),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: generator.column * generator.row,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: generator.column,
          ),
          itemBuilder: (context, position) {
            int cPos = position - 1;
            int row = (cPos / generator.column).toInt();
            int col = cPos % generator.column;
            return InkWell(
              child: new NodeWidget(node: list[row][col]),
              onLongPress: (() {
                bool isFlag = list[row][col].setFlag();
                generator.longPress(isFlag);
                print("Finished" + generator.gameFinished().toString());
                setState(() {

                });
              }),
              onTap: ((){
                openUp(row, col);
                print("Finished" + generator.gameFinished().toString());
                //list[row][col].onTap();
                if(list[row][col].isBomb()) {
                  print("Game Over");
                }
                setState(() {

                });
              }),
            );

          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startNewGame,
        tooltip: 'Increment',
        child: Icon(Icons.settings_backup_restore),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  openUp(row, col) {
    if(row >= generator.row || row < 0 || col >= generator.column || col< 0) return;
    if(list[row][col].isOpened) return;
    if(list[row][col].getValue() != 0) {
      list[row][col].onTap();
      generator.addOpened();
      return;
    }
    list[row][col].onTap();
    generator.addOpened();
    openUp(row-1, col);
    openUp(row+1, col);
    openUp(row, col -1);
    openUp(row,col+1);
  }

  void startNewGame() {
    list = generator.getNewMap();
    print("Hash" + list.hashCode.toString());
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }
}
