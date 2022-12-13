import 'package:flutter/material.dart';
import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';

import 'home.dart';

late bool hasIR;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  hasIR = await IrSensorPlugin.hasIrEmitter;
  runApp(const MaterialApp(
    home: Home(),
  ));
}
