import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/AddScreen.dart';
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
        Container(
            child: (result != null)
                ? Center(
                    child: Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'))
                : const Center(
                    child: Text(
                      'Scan a code',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
    if (result == null) {
      controller.resumeCamera();
      setState(() {
        this.controller = controller;
      });
    }

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      controller.stopCamera();
      controller.dispose();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddScreen(orderid: scanData.code!)),
      );
      setState(() {
        result = null;
      });
    });
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
    controller!.pauseCamera();
    controller?.dispose();
    super.dispose();
  }
}
