import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_anywhere_menus/flutter_anywhere_menus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Floating Menus',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Floating Menus Demo'),
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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
    final menuItems = [
      MenuItem(child: Text('one')),
      MenuItem(child: Text('two')),
      MenuItem(child: Text('three')),
    ];

    final menuBar = MenuBar(menuItems: menuItems);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _counter.toString(),
            ),
            Material(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  hoverColor: Colors.yellow,
                  onTap: () {},
                  child: Container(
                      constraints: BoxConstraints(maxHeight: 50),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Icon(Icons.access_alarms),
                          Icon(Icons.account_circle)
                        ],
                      )),
                )),
            Menu(
              child: MaterialButton(
                child: Text('Show Basic Menu'),
              ),
              menuBar: MenuBar(),
            ),
            Menu(
              child: MaterialButton(
                child: Text('Dem Fancy Menus'),
              ),
              menuBar: MenuBar(
                drawArrow: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                menuItems: [
                  MenuItem(
                    child: Icon(Icons.color_lens, color: Colors.grey[600]),
                    onTap: () => _incrementCounter(),
                  ),
                  MenuItem(
                    child: Menu(
                      offset: Offset(0, 20),
                      child: Icon(Icons.colorize, color: Colors.grey[600]),
                      menuBar: MenuBar(
                          drawArrow: true,
                          drawDivider: true,
                          maxThickness: 68,
                          orientation: MenuOrientation.vertical,
                          menuItems: [MenuItem(child: Icon(Icons.add))]),
                    ),
                  ),
                  MenuItem(
                      child: Icon(Icons.content_copy, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu TL'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.topLeft,
                    ),
                    Menu(
                      tapType: TapType.tap,
                      offset: Offset(0, 10),
                      child: MaterialButton(
                        child: Text('Show Menu T'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.topCenter,
                    ),
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu TR'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.topRight,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu CL'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.centerLeft,
                    ),
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu C'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.center,
                    ),
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu CR'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.centerRight,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu BL'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.bottomLeft,
                    ),
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu BC'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.bottomCenter,
                    ),
                    Menu(
                      tapType: TapType.tap,
                      child: MaterialButton(
                        child: Text('Show Menu BR'),
                      ),
                      menuBar: menuBar,
                      menuAlignmentOnChild: MenuAlignment.bottomRight,
                    ),
                  ],
                ),
                Menu(
                  tapType: TapType.tap,
                  child: Container(
                    width: 300,
                    height: 200,
                    color: Colors.yellow,
                    child: Center(child: Text('Show Menu Over Tap')),
                  ),
                  menuOverTap: true,
                  menuBar: menuBar,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
