// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/AddScreen.dart';
import 'package:pmx/models/server.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _buildQrView(context)),
        const Center(
          child: Text(
            'Scan a code',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.redAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 12.5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    try {
      if (result == null) {
        controller.resumeCamera();
        setState(() {
          this.controller = controller;
        });
      }
      controller.scannedDataStream.listen((scanData) async {
        setState(() {
          result = scanData;
        });
        var orderId = scanData.code!.split('/')[4];
        if (scanData.code!.split('/')[2] == server) {
          AddScreenPageRoute(orderId);
        } else {
          setState(() {
            result = null;
          });
        }
      });
    } catch (err) {
      result = null;
    }
  }

  AddScreenPageRoute(orderId) async {
    controller?.pauseCamera();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddScreen(orderid: orderId);
    })).then((value) => controller?.resumeCamera());
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
