import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';

class BoardStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);

    return Scaffold(
      body: _buildBody(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, ParentBloc bloc) {
    return Container(
      width: 1000.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDateText(bloc),
          SizedBox(
            height: 50.0,
          ),
          _buildStateIndicator(),
        ],
      ),
    );
  }

  Widget _buildDateText(ParentBloc bloc) {
    String currentDate = bloc.getCurrentDate();
    bloc.getOneWeekDate();
    return Text(
      currentDate,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35.0,
          color: Colors.grey.shade600),
    );
  }

  Widget _buildStateIndicator() {
    return Container(
      width: 300.0,
      height: 300.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150.0),
        color: Colors.blue,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'images/background.JPG',
                width: 100.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text('00시 00분', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text('탑승 완료', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ],
      ),
    );

//    return Container(
//      width: 300.0,
//      height: 300.0,
//      alignment: Alignment.center,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(150.0),
//        color: Colors.grey,
//      ),
//      child: Column(
//        children: <Widget>[
//          Expanded(
//            child: Padding(
//              padding: const EdgeInsets.only(top: 50.0),
//              child: Image.asset(
//                'images/background.JPG',
//                width: 100.0,
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(bottom: 5.0),
//            child: Text('00시 00분', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(bottom: 30.0),
//            child: Text('하차 완료', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
//          ),
//        ],
//      ),
//    );
  }
}
