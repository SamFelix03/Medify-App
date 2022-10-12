import 'package:flutter/material.dart';

class NewRecord extends StatefulWidget {
  Function addrecord;

  NewRecord({required this.addrecord});

  @override
  State<NewRecord> createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  @override
  var _recordNameController = TextEditingController();
  void submitillnessData() {
    var enteredName = _recordNameController.text;
    if (enteredName.isEmpty) {
      return;
    }
    widget.addrecord(name: enteredName);
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
            decoration: const InputDecoration(
              label: Text(
                "illness",
              ),
            ),
            controller: _recordNameController,
            onSubmitted: (value) => submitillnessData(),
          ),
          TextButton(
            onPressed: submitillnessData,
            child: Text("Add record",
                style: TextStyle(color: Theme.of(context).primaryColor)),
          )
        ]),
      ),
    );
    ;
  }
}
