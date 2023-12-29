import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osram_controller/widgets/code_test.dart';
import 'package:osram_controller/utils/remote.dart';

class CreateButton extends StatefulWidget {
  final IRButton? button;
  const CreateButton({super.key, this.button});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  @override
  void initState() {
    if (widget.button != null) {
      codeController.value =
          TextEditingValue(text: widget.button!.code.toRadixString(16));
      if (widget.button!.isImage) {
        imagePath = widget.button!.image;
        image = imagePath!.startsWith("assets")
            ? Image.asset(
                imagePath!,
                fit: BoxFit.contain,
              )
            : Image.file(
                File(imagePath!),
                fit: BoxFit.contain,
              );
      } else {
        nameController.value = TextEditingValue(text: widget.button!.image);
      }
    }
    super.initState();
  }

  Widget? image;
  String? imagePath;
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (codeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Code can not be empty")));
              return;
            }
            IRButton button = IRButton(
                code: int.parse(codeController.text, radix: 16),
                image: imagePath ?? nameController.text,
                isImage: imagePath != null);
            Navigator.pop(context, button);
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Add a button"),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTabController(
                  length: 2,
                  child: SizedBox(
                    height: 250,
                    child: Builder(builder: ((context) {
                      final TabController tabController =
                          DefaultTabController.of(context);
                      tabController.addListener(() {
                        if (tabController.index == 1) {
                          setState(() {
                            image = null;
                            imagePath = null;
                          });
                        }
                      });
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        const TabBar(tabs: [
                          Text(
                            "Image",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Text",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ]),
                        const Padding(padding: EdgeInsets.all(5)),
                        Expanded(
                            child: TabBarView(children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            getImage().then((value) {
                                              imagePath = value;
                                              if (value != null) {
                                                File fimg = File(value);
                                                setState(() {
                                                  image = Image.file(
                                                    fimg,
                                                    fit: BoxFit.contain,
                                                  );
                                                });
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("From gallery")),
                                      TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    content: SizedBox(
                                                        width: 300,
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      2),
                                                          itemCount:
                                                              defaultImages
                                                                  .length,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    image = Image.asset(
                                                                        defaultImages[
                                                                            index]);
                                                                    imagePath =
                                                                        defaultImages[
                                                                            index];
                                                                  });
                                                                },
                                                                child: Image.asset(
                                                                    defaultImages[
                                                                        index]));
                                                          },
                                                        )));
                                              },
                                            );
                                          },
                                          child: const Text("From assets")),
                                    ],
                                  ));
                                },
                              );
                            },
                            child: image ??
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      size: 50,
                                    )),
                          ),
                          Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                      helperText: "Name of the button"),
                                ),
                              ),
                            ),
                          ),
                        ]))
                      ]);
                    })),
                  ),
                ),
                //Divider(),
                const Row(children: []),
                const Padding(padding: EdgeInsets.all(5)),
                const Text(
                  "Code",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.start,
                ),
                const Divider(),
                const Padding(padding: EdgeInsets.all(5)),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: codeController,
                      maxLength: 8,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-fA-F]")),
                      ],
                      decoration: InputDecoration(
                          helperText: "Code of the button",
                          suffixIcon: IconButton(
                              onPressed: () async {
                                try {
                                  String a = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CodeTest(
                                            code: codeController.value.text
                                                .padLeft(8, '0')),
                                      ));
                                  codeController.text = a.replaceAll(" ", "");
                                } catch (e) {
                                  return;
                                }
                              },
                              icon: const Icon(Icons.search))),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
