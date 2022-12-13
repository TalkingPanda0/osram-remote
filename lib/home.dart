import 'package:flutter/material.dart';
import 'package:osram_controller/ir.dart';
import 'package:osram_controller/main.dart';

class IRButton {
  Widget? image;
  List<int>? code;
  IRButton({required this.image, required this.code});
}

List<IRButton> buttons = [
  IRButton(image: Image.asset("assets/UP.png"), code: IRCODE_UP),
  IRButton(image: Image.asset("assets/DOWN.png"), code: IRCODE_DOWN),
  IRButton(image: Image.asset("assets/OFF.png"), code: IRCODE_OFF),
  IRButton(image: Image.asset("assets/ON.png"), code: IRCODE_ON),
  IRButton(image: Image.asset("assets/RED.png"), code: IRCODE_RED),
  IRButton(image: Image.asset("assets/GREEN.png"), code: IRCODE_GREEN),
  IRButton(image: Image.asset("assets/BLUE.png"), code: IRCODE_BLUE),
  IRButton(image: Image.asset("assets/WARM.png"), code: IRCODE_WARM),
  IRButton(image: Image.asset("assets/RED0.png"), code: IRCODE_RED0),
  IRButton(image: Image.asset("assets/GREEN0.png"), code: IRCODE_GREEN0),
  IRButton(image: Image.asset("assets/BLUE0.png"), code: IRCODE_BLUE0),
  IRButton(image: Image.asset("assets/COOL.png"), code: IRCODE_COOL),
  IRButton(image: Image.asset("assets/RED1.png"), code: IRCODE_RED1),
  IRButton(image: Image.asset("assets/GREEN1.png"), code: IRCODE_GREEN1),
  IRButton(image: Image.asset("assets/BLUE1.png"), code: IRCODE_BLUE1),
  IRButton(image: Image.asset("assets/FLASH.png"), code: IRCODE_FLASH),
  IRButton(image: Image.asset("assets/RED2.png"), code: IRCODE_RED2),
  IRButton(image: Image.asset("assets/GREEN2.png"), code: IRCODE_GREEN2),
  IRButton(image: Image.asset("assets/BLUE2.png"), code: IRCODE_BLUE2),
  IRButton(image: Image.asset("assets/STROBE.png"), code: IRCODE_STROBE),
  IRButton(image: Image.asset("assets/RED3.png"), code: IRCODE_RED3),
  IRButton(image: Image.asset("assets/GREEN3.png"), code: IRCODE_GREEN3),
  IRButton(image: Image.asset("assets/BLUE3.png"), code: IRCODE_BLUE3),
  IRButton(image: Image.asset("assets/SMOOTH.png"), code: IRCODE_SMOOTH),
];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            IRButton button = buttons[index];
            return GestureDetector(
              child: button.image,
              onTap: () {
                transmit(button.code ?? []);
              },
            );
          },
        ),
      ),
    );
  }
}
