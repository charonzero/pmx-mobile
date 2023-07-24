import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/AddScreenPage.dart';
import 'package:pmx/models/modals.dart';
import 'package:pmx/models/package.dart';
import 'package:pmx/models/server.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanningEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print(
          'resumed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      if (_isScanningEnabled) {
        Future.delayed(const Duration(seconds: 2), () {
          _controller?.resumeCamera();
        });
      }
    } else if (state == AppLifecycleState.paused) {
      _controller?.pauseCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
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
    final scanArea = MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500
        ? 250.0
        : 400.0;
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.redAccent,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 12.5,
        cutOutSize: scanArea,
      ),
      onPermissionSet: _onPermissionSet,
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    try {
      print('QR created');
      setState(() {
        _controller = controller;
      });
      controller.scannedDataStream.listen((scanData) async {
        await controller.pauseCamera();
        print(scanData.code);
        final segments = scanData.code!.split('/');
        final packageSecret = segments.length > 4 ? segments.last : null;
        print(packageSecret);
        if (packageSecret != null) {
          // Pause the camera before navigation
          if (mounted) {
            setState(() {
              _isScanningEnabled = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddScreenPage(
                  packageSecret: packageSecret,
                ),
              ),
            ).then((_) {
              Future.delayed(const Duration(seconds: 10), () {
                if (mounted) {
                  setState(() {
                    _isScanningEnabled = true;
                  });
                }
                _controller?.resumeCamera();
              });
              // Resume the camera after navigation
            });
          }
        }
      });
    } catch (e) {
      log('QR scan error: $e');
    }
  }

  void _onPermissionSet(QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera permission')),
      );
    }
  }
}
