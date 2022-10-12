import 'package:Medify/widgets/prescriptions%20list/newprescription.dart';
import 'package:flutter/material.dart';
import '../../models/dissmissible_widget.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  @override
  List<Map<String, Object>> prescriptionList = [
    {
      'name': "ibuprofen",
      'dosage': 250,
      'amount': 2,
      'id': "t1",
    },
    {
      'name': "dolo650",
      'dosage': 650,
      'amount': 3,
      'id': "t2",
    },
    {'name': "Levothyroxine", 'dosage': 80, 'amount': 3, 'id': "t3,"},
  ];

  void _addPrescription(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewPrescription(
          addrecord: _addRecord,
        );
      },
    );
  }

  void _addRecord({name, dosage, amount}) {
    setState(() {
      prescriptionList.add({
        'name': name,
        'dosage': dosage,
        'amount': amount,
        'id': 't${prescriptionList.length + 1}'
      });
    });
  }

  void _removeRecord(String id) {
    setState(() {
      prescriptionList.removeWhere((rec) => rec['id'] == id);
      print(prescriptionList);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("prescriptions"),
      ),
      body: prescriptionList.isEmpty
          ? Center(
              child: Container(
                  child: const Text(
                "No records found",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            )
          : ListView.builder(
              itemCount: prescriptionList.length,
              itemBuilder: (context, index) {
                var currentAmount = prescriptionList[index]['amount'];
                return DissmissibleWidget(
                  onDismissed: _removeRecord,
                  item: prescriptionList[index]['id'],
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 40,
                          child: FittedBox(child: Text("${currentAmount}x"))),
                      title: Text(
                        prescriptionList[index]['name'] as String,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${prescriptionList[index]['dosage']}mg"),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 50,
        child: FloatingActionButton(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          onPressed: () => _addPrescription(context),
          child: Text("Add Prescription"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
