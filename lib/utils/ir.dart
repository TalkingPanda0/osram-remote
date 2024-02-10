import 'package:flutter/services.dart';

const platform = MethodChannel('org.talkingpanda/irtransmitter');

void transmit(int code) async {
//Ir.transmit(carrierFrequency: 38028, pattern: convertNECtoList(code));
  await platform.invokeMethod("transmit", {"list": convertNECtoList(code)});
}

Future<bool> hasIrEmitter() async {
//Ir.transmit(carrierFrequency: 38028, pattern: convertNECtoList(code));
  return await platform.invokeMethod("hasIrEmitter");
}

// Converts a int code to timing list
List<int> convertNECtoList(int nec) {
  List<int> list = [];

  list.add(9045);
  list.add(4050);

  String str = nec.toRadixString(2);
  str = str.padLeft(32, '0');

  for (int i = 0; i < str.length; i++) {
    list.add(600);
    if (str[i] == "0") {
      list.add(550);
    } else {
      list.add(1650);
    }
  }

  list.add(600);
  return list;
}
