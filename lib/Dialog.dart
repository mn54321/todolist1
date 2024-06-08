import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  DialogBox(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.controller});
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: controller,
                enabled: true,
                decoration: const InputDecoration(
                    hintText: 'Add Todo',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
                  onPressed: onSave,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Color.fromARGB(255, 248, 248, 249)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.cyan)),
                    onPressed: onCancel,
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 254, 253)),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
