import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanneur/blocs/qr_code_bloc.dart';

class QrCodeScreen extends StatefulWidget {
  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String oldResult;
  bool flashOn = false;
  QRViewController controller;
  bool isEditTextCollapsed = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 10.0,
              borderLength: 50.0,
              borderWidth: 10.0,
            ),
          ),
          Positioned(
            left: 10.0,
            top: MediaQuery.of(context).padding.top + 10.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.0,
            top: MediaQuery.of(context).padding.top + 10.0,
            child: GestureDetector(
              onTap: () {
                if (controller != null) {
                  controller.toggleFlash();
                  setState(() {
                    flashOn = !flashOn;
                  });
                }
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  flashOn ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.0,
            top: MediaQuery.of(context).padding.top + 70.0,
            child: GestureDetector(
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, PageTransition(child: CodeScreen(), type: PageTransitionType.fade));
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.pen,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (oldResult == null) {
        BlocProvider.of<QrCodeBloc>(context)..add(QrCodeScanned(data: scanData.code));
        Future.delayed(Duration.zero, () {
          Navigator.pop(context);
        });
      }
      oldResult = scanData.code;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
