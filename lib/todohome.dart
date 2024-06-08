import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolist1/Dialog.dart';

import 'package:todolist1/Todotile.dart';

class Todohome extends StatefulWidget {
  const Todohome({
    super.key,
  });

  @override
  State<Todohome> createState() => _TodohomeState();
}

class _TodohomeState extends State<Todohome> {
  final _controller = TextEditingController();
  List todolist = [
    /* ["Learn Flutter", false],
    ["Learn Dart", false]*/
  ];
  // Update task completion status in Firestore
  void checkboxchanged(bool? value, int index) {
    setState(() {
      todolist[index][1] = !todolist[index][1];
    });

    String taskName = todolist[index][0];

    updatetaskCompleteionStatus(taskName, todolist[index][1]);
  }

  void updatetaskCompleteionStatus(String taskName, taskCompleted) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("NewTask")
        .where('taskname', isEqualTo: taskName)
        .get();
    for (var doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection("NewTask")
          .doc(doc.id)
          .update({'taskCompleted': taskCompleted});
    }
  }

// taan ke  get kita data show hove app run hon te
  @override
  void initState() {
    fetchTaskfromFirestore();
    super.initState();
  }

//get kita data
  void fetchTaskfromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("NewTask").get();

    setState(() {
      todolist = querySnapshot.docs.map((doc) {
        return [doc["taskname"], doc["taskCompleted"]];
      }).toList();
    });
  }
  //get kita data

//save kita data
  void savenewTask() async {
    if (_controller.text.isEmpty) return;
    Map<String, dynamic> newTask = {
      "taskname": _controller.text,
      "taskCompleted": false
    };

    FirebaseFirestore.instance.collection("NewTask").add(newTask);

    setState(() {
      todolist.add([_controller.text, false]);

      _controller.clear();
    });
    Navigator.of(context).pop();
  }

//save kita data
  void deletetask(int index) {
    setState(() {
      todolist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.cyan, Colors.indigo]),
            ),
          ),
          backgroundColor: Colors.black,
          title: const Center(
              child: Text(
            'Todo',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: createnewtask,
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 254, 254, 254),
          ),
        ),
        body: ListView.builder(
          itemCount: todolist.length,
          itemBuilder: (context, index) {
            return Todotile(
              taskname: todolist[index][0],
              taskCompleted: todolist[index][1],
              onChanged: (value) => checkboxchanged(value, index),
              deletefunction: (context) => deletetask(index),
            );
          },
        ));
  }

  void createnewtask() {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          onSave: savenewTask,
          onCancel: () {
            Navigator.of(context).pop();
          },
          controller: _controller,
        );
      },
    );
  }
}
