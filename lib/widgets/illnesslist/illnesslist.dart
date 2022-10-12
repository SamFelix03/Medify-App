import 'package:Medify/widgets/labrecord.dart/labrecordlist.dart';
import 'package:flutter/material.dart';
import 'package:Medify/widgets/illnesslist/newrecord.dart';
import '../../models/dissmissible_widget.dart';
import '../prescriptions list/prescriptions.dart';

class IllnessList extends StatefulWidget {
  @override
  State<IllnessList> createState() => _IllnessListState();
}

class _IllnessListState extends State<IllnessList> {
  @override
  List<Map<String, Object>> illnesses = [
    {
      'illness': 'Diabetes',
      'id': 'i1',
    },
    {
      'illness': 'Anaemia',
      'id': 'i2',
    },
    {
      'illness': 'High Blood Pressure',
      'id': 'i3',
    },
    {
      'illness': 'Asthma',
      'id': 'i4',
    },
    {
      'illness': 'COVID-19',
      'id': 'i5',
    },
  ];
  void _addillnessrecord(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewRecord(
          addrecord: _addRecord,
        );
      },
    );
  }

  void _addRecord({name}) {
    setState(() {
      illnesses.add({'illness': name, 'id': 'i${illnesses.length + 1}'});
    });
  }

  void _removeRecord(String id) {
    setState(() {
      illnesses.removeWhere((rec) => rec['id'] == id);
      print(illnesses);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Illness record")),
      body: illnesses.isEmpty
          ? Center(
              child: Container(
                  child: Text(
                "No records found",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            )
          : ListView.builder(
              itemCount: illnesses.length,
              itemBuilder: (context, index) {
                return DissmissibleWidget(
                  onDismissed: _removeRecord,
                  item: illnesses[index]['id'],
                  child: Container(
                    width: double.infinity - 15,
                    height: 150,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Card(
                      elevation: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              illnesses[index]['illness'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: (() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrescriptionPage(),
                                      ))),
                                  child: Text(
                                    "prescriptions",
                                  )),
                              TextButton(
                                  onPressed: (() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LabRecordList(),
                                      ))),
                                  child: Text("lab records")),
                            ],
                          ),
                        ],
                      ),
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
          onPressed: () => _addillnessrecord(context),
          child: Text("Add Record"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
