import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/rendering.dart';

Future<List<Post>> fetchPost(http.Client client) async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var data = json.decode(response.body).cast<Map<String, dynamic>>();

    var list = data.map<Post>((json) => Post.fromJson(json)).toList();
    return list;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void main() => runApp(MyApp(post: fetchPost(http.Client())));

List<String> activeSources;
bool isSwitched = false;

class MyApp extends StatelessWidget {
  final Future<List<Post>> post;

  MyApp({Key key, this.post}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corona News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Corona News', post: post),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.post}) : super(key: key);

  final String title;
  final Future<List<Post>> post;

  @override
  State<StatefulWidget> createState()
  {
    return StateHome(post: post);
  }
}

class StateHome extends State<MyHomePage>
{
  StateHome({this.post});
  
  final Future<List<Post>> post;

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fontes de notícias")
        ),
        body: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: new GestureDetector(
                  child: Image.asset("assets/WHO.jpg"),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WHOPage(),
                      ),
                    );
                  },
                  onDoubleTap: ()
                  {
                    print(post.toString());
                    if(activeSources.indexWhere((source)=> source=="WHO") == -1)
                      activeSources.add("WHO");
                  },
                ),
              ),
              Expanded(
                child: new GestureDetector(
                  child: Image.asset("assets/CDC.png"),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CDCPage(),
                      ),
                    );
                  },
                  onDoubleTap: ()
                  {
                    if(activeSources.indexWhere((source)=> source=="WHO") == -1)
                      activeSources.add("CDC");
                  },
                ), 
              ),
            ], 
          ),
        ),
      ),
    );
  }
}

class WHOPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return WHOState();
  }
}

class WHOState extends State<WHOPage>
{
  void changeColour(bool isActive)
  {

  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      theme: ThemeData
      (
        primarySwatch: Colors.green,
      ),
      home: Scaffold
      (
        appBar: AppBar
        (
          title: Text("WHO")
        ),
        body: Card
        (
          child: Column
          (
            children: <Widget>
            [
              Expanded(child: Image.asset("assets/WHO.jpg"),),
              Text("The World Health Organization (WHO) is a specialized agency of the United Nations responsible for international public health."),
              Switch(
                value: isSwitched,
                onChanged: (value){
                  setState(() {
                    isSwitched=value;
                    print(isSwitched);
                  });
                  if (isSwitched)
                  {
                    if(activeSources.indexWhere((source)=> source=="WHO") == -1)
                      activeSources.add("WHO");
                  }
                  else
                  {
                    activeSources.remove("WHO");
                  }
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CDCPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return CDCState();
  }
}

class CDCState extends State<CDCPage>
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      theme: ThemeData
      (
        primarySwatch: Colors.red,
      ),
      home: Scaffold
      (
        appBar: AppBar
        (
          title: Text("CDC")
        ),
        body: Card
        (
          child: Column
          (
            children: <Widget>
            [
              Expanded(child: Image.asset("assets/CDC.png"),),
              Text("The Centers for Disease Control and Prevention (CDC) is the leading national public health institute of the United States."),
              Switch(
                value: isSwitched,
                onChanged: (value){
                  setState(() {
                    isSwitched=value;
                    print(isSwitched);
                  });
                  if (isSwitched)
                  {
                    if(activeSources.indexWhere((source)=> source=="WHO") == -1)
                      activeSources.add("CDC");
                  }
                  else
                  {
                    activeSources.remove("CDC");
                  }
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
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
}*/
