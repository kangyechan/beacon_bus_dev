import 'package:flutter/material.dart';

class UHomePage extends StatefulWidget {
  @override
  _UHomePageState createState() => _UHomePageState();
}

class _UHomePageState extends State<UHomePage> {

  List<BottomNavigationBarItem> _items;
  int _currentIndex = 0;
  String _value = "";

  @override
  void initState() {
    _items = new List();
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.directions_bus), title: new Text("승하차 상태")));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.directions_run), title: new Text("탑승유무")));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.note), title: new Text("기록")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("School Bus"),
        backgroundColor: Colors.yellow,
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(_value),
            ],
          ),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: _items,
        fixedColor: Colors.yellow,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _value = "Current value is: ${_currentIndex.toString()}";
    });
  }
}