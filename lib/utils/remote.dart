import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class IRButton {
  final int code;
  final String image;
  final bool isImage;
  const IRButton({
    required this.code,
    required this.image,
    required this.isImage,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'image': image,
        'isImage': isImage,
      };
}

class Remote {
  final List<IRButton> buttons;
  String name;
  Remote({
    required this.buttons,
    required this.name,
  });
  Map<String, dynamic> toJson() => {
        'buttons': buttons.map((button) => button.toJson()).toList(),
        'name': name,
      };
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _remotesFile async {
  final path = await _localPath;
  return File('$path/remotes.json');
}

Future<File> writeRemotelist(List<Remote> remotes) async {
  final file = await _remotesFile;

  return file.writeAsString(
      jsonEncode(remotes.map((remote) => remote.toJson()).toList()));
}

Future<List<Remote>> readRemotes() async {
  try {
    final file = await _remotesFile;
    final contents = await file.readAsString();

    List<Remote> remotes = (jsonDecode(contents) as List).map((remote) {
      List<IRButton> buttons = (remote["buttons"] as List)
          .map((button) => IRButton(
                code: button['code'],
                image: button['image'],
                isImage: button['isImage'],
              ))
          .toList();

      return Remote(buttons: buttons, name: remote["name"]);
    }).toList();

    return remotes;
  } catch (e) {
    // If encountering an error, return empty list
    return <Remote>[];
  }
}

List<String> defaultImages = [
  "assets/ON.png",
  "assets/OFF.png",
  "assets/UP.png",
  "assets/DOWN.png",
  "assets/STROBE.png",
  "assets/FLASH.png",
  "assets/SMOOTH.png",
  "assets/COOL.png",
  "assets/BLUE.png",
  "assets/BLUE0.png",
  "assets/BLUE1.png",
  "assets/BLUE2.png",
  "assets/BLUE3.png",
  "assets/RED.png",
  "assets/RED0.png",
  "assets/RED1.png",
  "assets/RED2.png",
  "assets/RED3.png",
  "assets/GREEN.png",
  "assets/GREEN0.png",
  "assets/GREEN1.png",
  "assets/GREEN2.png",
  "assets/GREEN3.png",
  "assets/WARM.png",
];

List<Remote> writeDefaultRemotes() {
  Remote osramRemote = Remote(buttons: const [
    IRButton(code: 0xFF00FF, image: "assets/UP.png", isImage: true),
    IRButton(code: 0xFF40BF, image: "assets/DOWN.png", isImage: true),
    IRButton(code: 0xFF609F, image: "assets/OFF.png", isImage: true),
    IRButton(code: 0xFFE01F, image: "assets/ON.png", isImage: true),
    IRButton(code: 0xFF10EF, image: "assets/RED.png", isImage: true),
    IRButton(code: 0xFF906F, image: "assets/GREEN.png", isImage: true),
    IRButton(code: 0xFF50AF, image: "assets/BLUE.png", isImage: true),
    IRButton(code: 0xFFC03F, image: "assets/WARM.png", isImage: true),
    IRButton(code: 0xFF30CF, image: "assets/RED0.png", isImage: true),
    IRButton(code: 0xFFB04F, image: "assets/GREEN0.png", isImage: true),
    IRButton(code: 0xFF708F, image: "assets/BLUE0.png", isImage: true),
    IRButton(code: 0xFFF00F, image: "assets/COOL.png", isImage: true),
    IRButton(code: 0xFF08F7, image: "assets/RED1.png", isImage: true),
    IRButton(code: 0xFF8877, image: "assets/GREEN1.png", isImage: true),
    IRButton(code: 0xFF48B7, image: "assets/BLUE1.png", isImage: true),
    IRButton(code: 0xFFC837, image: "assets/FLASH.png", isImage: true),
    IRButton(code: 0xFF28D7, image: "assets/RED2.png", isImage: true),
    IRButton(code: 0xFFA857, image: "assets/GREEN2.png", isImage: true),
    IRButton(code: 0xFF6897, image: "assets/BLUE2.png", isImage: true),
    IRButton(code: 0xFFE817, image: "assets/STROBE.png", isImage: true),
    IRButton(code: 0xFF18E7, image: "assets/RED3.png", isImage: true),
    IRButton(code: 0xFF9867, image: "assets/GREEN3.png", isImage: true),
    IRButton(code: 0xFF58A7, image: "assets/BLUE3.png", isImage: true),
    IRButton(code: 0xFFD82, image: "assets/SMOOTH.png", isImage: true),
  ], name: "Osram Remote");

  writeRemotelist([osramRemote]);

  return [osramRemote];
}

// Get an image from user using the image_picker library
Future<String?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    // save the image to the app's local directory
    await image.saveTo(await _localPath + image.name);
    return await _localPath + image.name;
  }
  return null;
}
