import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/database.dart';
import 'package:todo/models.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

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
        title: const Text('notes&todo'),
        backgroundColor: Colors.pink,
      ),
      body: Expanded(
        child: FutureBuilder(
          future: Sqflite().getFromNote(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, indx) {
                  return Card(
                    child: Column(
                      children: [
                        Text(snapshot.data![indx]['id']),
                        Text(snapshot.data![indx]['title']),
                        Text(snapshot.data![indx]['content']),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return Material(
                  color: Colors.white.withOpacity(0.3),
                  child: CupertinoAlertDialog(
                    title: Text('add new not'),
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
                        child: Text("cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("add"),
                        onPressed: () async {
                          titlecontroller.clear();
                          contentcontroller.clear();
                          ;
                        },
                      ),
                    ],
                  ),
                );
              })
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
