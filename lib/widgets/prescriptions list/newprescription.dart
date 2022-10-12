import 'package:flutter/material.dart';

class NewPrescription extends StatefulWidget {
  Function addrecord;

  NewPrescription({required this.addrecord});

  @override
  State<NewPrescription> createState() => _NewPrescriptionState();
}

class _NewPrescriptionState extends State<NewPrescription> {
  @override
  var _recordNameController = TextEditingController();
  var _recordDosageController = TextEditingController();
  var _recordIntakeController = TextEditingController();

  void submitprescripton() {
    var enteredName = _recordNameController.text;
    var enteredDosage = _recordDosageController.text;
    var enteredIntake = _recordIntakeController.text;
    if (enteredName.isEmpty || enteredIntake.isEmpty || enteredDosage.isEmpty) {
      return;
    }
    widget.addrecord(
      name: enteredName,
      dosage: enteredDosage,
      amount: enteredIntake,
    );
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
                "prescription",
              ),
            ),
            controller: _recordNameController,
            onSubmitted: (value) => submitprescripton(),
          ),
          TextField(
            decoration: const InputDecoration(
              label: Text(
                "Dosage",
              ),
            ),
            controller: _recordDosageController,
            onSubmitted: (value) => submitprescripton(),
          ),
          TextField(
            decoration: const InputDecoration(
              label: Text(
                "Intake Per Day",
              ),
            ),
            controller: _recordIntakeController,
            onSubmitted: (value) => submitprescripton(),
          ),
          TextButton(
            onPressed: submitprescripton,
            child: Text("Add record",
                style: TextStyle(color: Theme.of(context).primaryColor)),
          )
        ]),
      ),
    );
    ;
  }
}
