import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PrintQR extends StatefulWidget {
  final String id;
  const PrintQR({Key? key, required this.id}) : super(key: key);

  @override
  _PrintQRState createState() => _PrintQRState();
}

class _PrintQRState extends State<PrintQR> {
  @override
  final _formKey = GlobalKey<FormState>();
  var code = "";

  CollectionReference place = FirebaseFirestore.instance.collection('Place');

  Future<void> printQR(
    id,
    code,
  ) {
    return place
        .doc(id)
        .update({
          'code': code,
        })
        .then((value) => print("Print QR Code"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print QR "),
      ),
      body: Form(
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('Place').doc(widget.id).get(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            print('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            print(widget.id);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.data();
          var code = widget.id;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: code,
                    readOnly: true,
                    enabled: false,
                    autofocus: false,
                    onChanged: (value) => code = value,
                    decoration: const InputDecoration(
                      labelText: 'code',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Column(children: <Widget>[
                  Center(
                    child: Card(
                      child: RepaintBoundary(
                        key: _formKey,
                        child: QrImage(
                          data: code,
                          version: QrVersions.auto,
                          size: 165.0,
                          backgroundColor: Colors.white,
                          errorStateBuilder: (cxt, err) {
                            return Container(
                              child: const Center(
                                child: Text(
                                  "Something gone wrong ...",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _captureAndSharePng();
                      });
                    },
                    child: Text('Save'),
                  ),
                ]),
              ],
            ),
          );
        },
      )),
    );
  }

  Future<void> _captureAndSharePng() async {
    RenderRepaintBoundary? boundary =
        _formKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getExternalStorageDirectory();
    final file = await new File('${tempDir!.path}/code.png').create();
    await file.writeAsBytes(pngBytes);
    await Share.shareFiles([file.path]);
  }
}
