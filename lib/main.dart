import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beacon_bus/app.dart';

void main() { SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
    .then((_) => runApp(new BeaconBusApp()));
}