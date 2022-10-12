import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

class LabRecordList extends StatefulWidget {
  @override
  _LabRecordListState createState() => _LabRecordListState();
}

class _LabRecordListState extends State<LabRecordList> {
  // ignore: deprecated_member_use, prefer_collection_literals
  List<Asset> images = <Asset>[];

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImages() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: const MaterialOptions(
          actionBarTitle: "Lab Records",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lab Records'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: pickImages,
              child: const Text("Choose Records"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(images.length, (index) {
                  Asset asset = images[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
