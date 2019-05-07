//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

import 'dart:async';

import 'package:beacons/beacons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'header.dart';

abstract class ListTab extends StatefulWidget {
  Stream<ListTabResult> stream(BeaconRegion region);

  @override
  _ListTabState createState() => new _ListTabState();
}

class ListTabData {}

class _ListTabState extends State<ListTab> {
  List<ListTabResult> _results = [];
  StreamSubscription<ListTabResult> _subscription;
  int _subscriptionStartedTimestamp;
  bool _running = false;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _onStart(BeaconRegion region) {
    setState(() {
      _running = true;
    });

    _subscriptionStartedTimestamp = new DateTime.now().millisecondsSinceEpoch;
    _subscription = widget.stream(region).listen((result) {
      result.elapsedTimeSeconds = (new DateTime.now().millisecondsSinceEpoch -
          _subscriptionStartedTimestamp) ~/
          1000;

      setState(() {
        _results.insert(0, result);
      });
    });

    _subscription.onDone(() {
      setState(() {
        _running = false;
      });
    });
  }

  void _onStop() {
    setState(() {
      _running = false;
    });

    _subscription.cancel();
    _subscriptionStartedTimestamp = null;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Header(
        regionIdentifier: 'test',
        running: _running,
        onStart: _onStart,
        onStop: _onStop,
      ),
    );
  }
}

class ListTabResult {
  ListTabResult({
    @required this.isSuccessful,
  });

  final bool isSuccessful;
  int elapsedTimeSeconds;
}