import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/database.dart';
import 'package:todo/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titlecontroller = TextEditingController();

  TextEditingController contentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'notes&todo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Sqflite().getFromNote(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, indx) {
                        return Card(
                          color: Colors.pink[400],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'id:  ${snapshot.data![indx]['id'].toString()}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      ' title ${snapshot.data![indx]['title']}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'content: ${snapshot.data![indx]['content']}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () => {
                                          showEditdialog(
                                            context,
                                            snapshot.data![indx]['title'],
                                            snapshot.data![indx]['content'],
                                            snapshot.data![indx]['id'],
                                          ),
                                        },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          ///////////////todo
          Expanded(
            child: FutureBuilder(
              future: Sqflite().getFromToDo(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, indx) {
                        bool isdone =
                            snapshot.data![indx]['value'] == 0 ? false : true;
                        return Card(
                          color: isdone==false
                              ? Colors.purple[400] 
                              :Colors.green[400],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                    value: isdone,
                                    onChanged: (bool? val) {
                                      Sqflite()
                                          .updatcheckBox(
                                              snapshot.data![indx]["id"],
                                              snapshot.data![indx]["value"])
                                          .whenComplete(() => setState(() {}));
                                    }),
                                Text(
                                  ("title: ") +
                                      (snapshot.data![indx]["title"])
                                          .toString(),style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return Material(
                        color: Colors.white.withOpacity(0.3),
                        child: CupertinoAlertDialog(
                          title: const Text('add new not'),
                          content: Column(
                            children: [
                              TextField(
                                controller: titlecontroller,
                              ),
                              TextField(
                                controller: contentcontroller,
                              ),
                            ],
                          ),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              child: const Text("cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text("add"),
                              onPressed: () async {
                                Sqflite()
                                    .insertnote(Note(
                                        content: contentcontroller.text,
                                        title: titlecontroller.text))
                                    .whenComplete(() => setState(() {}));
                                titlecontroller.clear();
                                contentcontroller.clear();
                              },
                            ),
                          ],
                        ),
                      );
                    })
              },
              backgroundColor: Colors.pink,
              child: const Icon(Icons.add),
            ),
            /////////////////////todo
            FloatingActionButton(
              onPressed: () => {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return Material(
                        color: Colors.white.withOpacity(0.3),
                        child: CupertinoAlertDialog(
                          title: const Text('add todo'),
                          content: Column(
                            children: [
                              TextField(
                                controller: titlecontroller,
                              ),
                            ],
                          ),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              child: const Text("cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text("add"),
                              onPressed: () async {
                                Sqflite()
                                    .insertToDo(ToDo(title: titlecontroller.text))
                                    .whenComplete(() => setState(() {}));
                                titlecontroller.clear();
                              },
                            ),
                          ],
                        ),
                      );
                    })
              },
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void showEditdialog(context, String title, String content, int id) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.white.withOpacity(0.3),
            child: CupertinoAlertDialog(
              title: const Text('edit not'),
              content: Column(
                children: [
                  TextFormField(
                    initialValue: title,
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextFormField(
                    initialValue: content,
                    onChanged: (val) {
                      content = content;
                    },
                  ),
                ],
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text("cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("edit"),
                  onPressed: () async {
                    Sqflite()
                        .UpdateFromNote(
                            Note(content: content, title: title, id: id))
                        .whenComplete(() => setState(() {}));
                    titlecontroller.clear();
                    contentcontroller.clear();
                  },
                ),
              ],
            ),
          );
        });
  }
}
