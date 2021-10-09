import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'QrAddscreen.dart';

class Qrscanner extends StatefulWidget {
  @override
  _QrscannerState createState() => _QrscannerState();
}

class _QrscannerState extends State<Qrscanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildqr(context),
          ],
        ),
      ),
    );
  }

  Widget buildqr(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(borderWidth: 10, borderRadius: 10),
      );

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      print(result!.code);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => QRAdd(result!.code)));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
