import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    hasIrEmitter().then((value) => {
          if (!value)
            {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('No IR emitter'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('This device does not have an IR emitter'),
                          Text('This app needs an IR emitter to function'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Dismiss'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                      ),
                    ],
                  );
                },
              )
            }
        });

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
