import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherActivityLogScreen extends StatefulWidget {
  @override
  _TeacherActivityLogScreenState createState() => _TeacherActivityLogScreenState();
}

class _TeacherActivityLogScreenState extends State<TeacherActivityLogScreen> {

  TextEditingController keyword = TextEditingController();
  String dropdownValue;
  String searchText;
  String classRoom;

  void _searchChanged(String value) {
    setState(() {
      if (value == '') {
        searchText = null;
      } else {
        searchText = value;
      }
    });
  }

  Widget _buildSearchNum() {
    return Container(
      width: 70.0,
      child: FutureBuilder(
        future: Firestore.instance.collection('Kindergarden').document('hamang').collection('Class').getDocuments(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          List<String> classList = ['전체'];
          snapshot.data.documents.map((DocumentSnapshot document) {
            classList.add(document.documentID.toString());
          }).toList();

          return Container(
            margin: EdgeInsets.only(top: 10.0),
            child: DropdownButton(
              value: dropdownValue,
              onChanged: (String value) {
                setState(() {
                  dropdownValue = value;
                  if(value == '전체') { classRoom = null; }
                  else { classRoom = value; }
                });
              },
              items: classList.map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              )).toList(),
              hint: Text("전체"),
            ),
          );
        },
      ),
    );
  }
  Widget _buildSearchButton() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Color(0xFFC9EBF7),
      ),
      width: 40.0,
      height: 40.0,
      child: IconButton(
        icon: Icon(
          Icons.search,
          size: 20.0,
          semanticLabel: 'search',
        ),
        onPressed: () {
          print(classRoom);
          print(keyword.text);
          _searchChanged(keyword.text);
        },
      ),
    );
  }
  Widget _buildSearchField() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15.0),
              child: TextField(
                controller: keyword,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFC9EBF7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildListTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          _buildListTitleName('이름'),
          _buildListTitleName('날짜'),
          _buildListTitleName('승차시간'),
          _buildListTitleName('하차시간'),
        ],
      ),
    );
  }
  Widget _buildListTitleName(String name) {
    return Expanded(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _buildBody(){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Kindergarden')
          .document('hamang')
          .collection('Log')
          .where('name', isEqualTo: searchText)
          .where('classRoom', isEqualTo: classRoom)
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        print(searchText);
        print(classRoom);
        return _logListContents(context, snapshot.data.documents);
      },
    );
  }

  Widget _logListContents(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top:5.0, left: 10.0, right: 10.0),
      children: snapshot.map((data) => _logListItem(context, data)).toList(),
    );
  }

  Widget _logListItem(BuildContext context, DocumentSnapshot data) {
    String name = data.data['name'];
    Map map = Map.from(data.data['activityRecord']);
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          _buildLogListItem(name),
          _buildLogListItem(map['date']),
          _buildLogListItem(map['in']),
          _buildLogListItem(map['out']),
        ],
      ),
    );
  }

  Widget _buildLogListItem(String name) {
    return Expanded(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.0,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  _buildSearchNum(),
                  _buildSearchField(),
                  _buildSearchButton(),
                ],
              ),
            ),
            _buildListTitle(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

}
