import 'dart:io';

import 'package:flutter/material.dart';

import 'package:osram_controller/widgets/create_button.dart';
import 'package:osram_controller/utils/remote.dart';

class CreateRemote extends StatefulWidget {
  final Remote? remote;
  const CreateRemote({super.key, this.remote});

  @override
  State<CreateRemote> createState() => _CreateRemoteState();
}

class _CreateRemoteState extends State<CreateRemote> {
  TextEditingController textEditingController = TextEditingController();
  late Remote remote;
  @override
  void initState() {
    remote = widget.remote ?? Remote(buttons: [], name: "Untitled Remote");
    textEditingController.value = TextEditingValue(text: remote.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (remote.name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Remote name can't be empty")));
            }
            Navigator.pop(context, remote);
          },
          child: const Icon(Icons.save)),
      appBar: AppBar(
        title: TextField(
          controller: textEditingController,
          onChanged: ((value) {
            remote.name = value;
          }),
        ),
      ),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          itemCount: remote.buttons.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            if (index < remote.buttons.length) {
              IRButton button = remote.buttons[index];
              return button.isImage
                  ? GestureDetector(
                      child: button.image.startsWith("assets/")
                          ? Image.asset(button.image)
                          : Image.file(File(button.image)),
                      onLongPress: () {
                        setState(() {
                          remote.buttons.removeAt(index);
                        });
                      },
                      onTap: () async {
                        try {
                          button = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateButton(
                                  button: button,
                                ),
                              ));

                          setState(() {
                            remote.buttons[index] = button;
                          });
                        } catch (e) {
                          return;
                        }
                      },
                    )
                  : TextButton(
                      onLongPress: () {
                        setState(() {
                          remote.buttons.removeAt(index);
                        });
                      },
                      onPressed: () async {
                        try {
                          button = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateButton(
                                  button: button,
                                ),
                              ));
                          setState(() {
                            remote.buttons[index] = button;
                          });
                        } catch (e) {
                          return;
                        }
                      },
                      child: Text(button.image),
                    );
            } else {
              return Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      try {
                        IRButton button = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateButton(),
                            ));

                        setState(() {
                          remote.buttons.add(button);
                        });
                      } catch (e) {
                        print(e);
                        return;
                      }
                    },
                  ));
            }
          },
        ),
      ),
    );
  }
}
