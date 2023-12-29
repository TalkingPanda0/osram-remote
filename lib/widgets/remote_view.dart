import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osram_controller/widgets/remote_list.dart';
import 'package:osram_controller/utils/ir.dart';
import 'package:osram_controller/utils/remote.dart';

class RemoteView extends StatefulWidget {
  final Remote remote;
  const RemoteView({super.key, required this.remote});

  @override
  RemoteViewState createState() => RemoteViewState();
}

class RemoteViewState extends State<RemoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RemoteList(),
              ));
        },
        child: const Icon(Icons.list),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(widget.remote.name),
      ),
      body: SafeArea(
        child: Center(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: widget.remote.buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) {
              IRButton button = widget.remote.buttons[index];
              return button.isImage
                  ? GestureDetector(
                      child: button.image.startsWith("assets/")
                          ? Image.asset(button.image)
                          : Image.file(File(button.image)),
                      onTap: () {
                        transmit(button.code);
                      },
                    )
                  : TextButton(
                      onPressed: () {
                        transmit(button.code);
                      },
                      child: Text(button.image),
                    );
            },
          ),
        ),
      ),
    );
  }
}
