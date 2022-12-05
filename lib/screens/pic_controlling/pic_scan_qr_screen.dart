import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/exceptions/app_general_exception.dart';
import 'package:netraya/models/line_condition.dart';
import 'package:netraya/screens/pic_controlling/pic_controlling_screen.dart';
import 'package:netraya/services/pic_controlling_service.dart';
import 'package:netraya/widgets/absensi/camera_screen.dart';
import 'package:netraya/widgets/widget_functions.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PICScanQrScreen extends StatefulWidget {
  const PICScanQrScreen({Key? key}) : super(key: key);

  @override
  State<PICScanQrScreen> createState() => _PICScanQrScreenState();
}

class _PICScanQrScreenState extends State<PICScanQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final picControllingService = PicControllingService();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 16,
            left: 16,
            child: CustomBackButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Scan Kode QR',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
                margin: const EdgeInsets.only(top: 500),
                child: const Text(
                  "Scan kode QR perangkat",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 350) ? MediaQuery.of(context).size.width - 50 : MediaQuery.of(context).size.width - 100;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.white, borderRadius: 10, borderLength: 30, borderWidth: 2, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    await controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      if (result == null) {
        result = scanData;
        loadingDialog(context);
        try {
          LineCondition lineCondition = await picControllingService.inquiry(result!.code ?? "");
          Navigator.of(context).pop();

          controller.pauseCamera();
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PICControlling(
              lineCondition: lineCondition,
            ),
          ));
          controller.resumeCamera();
        } on AppGeneralException catch (e) {
          Navigator.of(context).pop();
          await showValidationError(context, e.cause);
        } catch (e) {
          Navigator.of(context).pop();
          await showValidationError(context, ErrorMessage.general);
        }
        result = null;
      }
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
    controller?.dispose();
    super.dispose();
  }
}
