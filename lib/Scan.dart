import 'dart:async';
import 'dart:io';
//import 'dart:html';
import 'dart:developer';
import 'package:campus/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  String? get id => null;

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final Stream<QuerySnapshot> placeStream =
      FirebaseFirestore.instance.collection('Place').snapshots();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    result.dispose();
    super.dispose();
  }

  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {}
  // }

  clearText() {
    result.clear();
  }

  var result, code = "";

  void _onQRViewCreated(QRViewController controller) {
    bool firstDetection = true;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        this.controller = controller;
      });
      if (firstDetection) {
        firstDetection = false;
        if (result == checkValid()) {
          print(checkValid());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details_page1(
                id: result.code.toString(),
              ),
            ),
          );
        }
        //clearText();
      }
      setState(() {
        result = scanData;
        clearText();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          /*Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Qrcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
                  : Text('Scan a code'),
            ),
          ),*/
        ],
      ),
    );
  }

  String? checkValid() {
    FirebaseFirestore.instance.collection('Place').doc(widget.id).get();
    String? resultId = widget.id;
    return resultId;
  }
}
