import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IRTransmitter {
  static const platform = MethodChannel('org.talkingpanda/irtransmitter');
  void transmit(List<int> list) async {
    await platform.invokeMethod("transmit", {"list": list});
  }
}
