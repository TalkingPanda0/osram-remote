import 'package:flutter/material.dart';
import 'package:osram_controller/widgets/create_remote.dart';
import 'package:osram_controller/main.dart';
import 'package:osram_controller/utils/remote.dart';
import 'package:osram_controller/widgets/remote_view.dart';

class RemoteList extends StatefulWidget {
  const RemoteList({super.key});

  @override
  State<RemoteList> createState() => _RemoteListState();
}

class _RemoteListState extends State<RemoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeRemotelist(remotes).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Remotes have been saved")));
          });
        },
        child: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: ReorderableListView.builder(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex > remotes.length || newIndex > remotes.length) {
                return;
              }
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              Remote old = remotes.removeAt(oldIndex);
              remotes.insert(newIndex, old);
            });
          },
          itemCount: remotes.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < remotes.length) {
              return Card(
                key: Key(index.toString()),
                child: ListTile(
                  // Add a icon button to remove the remote
                  trailing: Wrap(children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateRemote(
                                  remote: remotes[index],
                                ),
                              ));
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          remotes.removeAt(index);
                        });
                      },
                    ),
                  ]),
                  title: Text(remotes[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RemoteView(
                          remote: remotes[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return ReorderableDragStartListener(
                  enabled: false,
                  key: Key(index.toString()),
                  index: index,
                  child: TextButton(
                      onPressed: () async {
                        try {
                          Remote remote = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateRemote(),
                              ));
                          setState(() {
                            remotes.add(remote);
                          });
                          writeRemotelist(remotes);
                        } catch (e) {
                          return;
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text("Add a remote"),
                          ])));
            }
          },
        ),
      ),
    );
  }
}
