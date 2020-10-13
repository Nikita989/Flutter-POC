import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
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
  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel('com.nikita/flutterTest/data');

  _MyHomePageState(){
    platform.setMethodCallHandler(_receiveFromHost);
  }

  var jData;
  var jData1;
  String _desc;

  Future<void> _receiveFromHost(MethodCall call) async {
    // To be implemented.
    String desc;
    try{
      print(call.method);
      if(call.method == "fromSwiftToFlutter"){
        final String data = call.arguments;
        print(call.arguments);
        jData = await jsonDecode(data);
        desc = jData['descriptionstr'];
      }
    } on PlatformException catch (error){
      print( error);
    }

    setState(() {
      _desc = desc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Hello World'),
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text(_desc, style: TextStyle(fontSize: 20.0),),
                onPressed: () {},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('Send data to swift', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  _sendResultsToiOS();
                },
              ),
            ),
          ]
          ))
      ),
    );
  }

  void _sendResultsToiOS() {
    //TODO send results to Android/iOS module
    Map<String,String> resultMap = Map();
    resultMap['value'] = 'Hi from Flutter';
    platform.invokeMethod('fromFlutterToSwift',resultMap);
  }
}
