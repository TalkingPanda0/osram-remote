import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:osram_controller/utils/ir.dart';
import 'package:osram_controller/utils/remote.dart';
import 'package:osram_controller/widgets/remote_view.dart';

List<Remote> remotes = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  remotes = await readRemotes();

  if (remotes.isEmpty) {
    remotes = writeDefaultRemotes();
  }

  runApp(DynamicColorBuilder(
    builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
        title: "Osram Remote",
        theme: ThemeData(colorScheme: lightDynamic, useMaterial3: true),
        darkTheme: ThemeData(colorScheme: darkDynamic, useMaterial3: true),
        home: RemoteView(remote: remotes[0]),
      );
    },
  ));
}
