import 'package:carrotmmu/logic/api.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  bool attendance_enabled = false;
  QRViewController controller;
  ConfettiController _controllerCenter;

  @override
  void initState() {
    HapticFeedback.mediumImpact();
    init();
    super.initState();
  }

  init() async {
    MyApp.observer.analytics.setCurrentScreen(
      screenName: '/checkin',
    );
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        attendance_enabled = true;
      });
    }
    _controllerCenter.play();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: (!attendance_enabled)
                    ? Row()
                    : QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: Image(image: AssetImage('assets/icon/icon.png')))
                  .height(100)
                  .clipRRect(all: 35)
                  .boxShadow(
                      color: Colors.amber.shade800.withOpacity(.5),
                      blurRadius: 45,
                      offset: Offset(0, 10))
                  .padding(bottom: 30),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  attendance_enabled
                      ? 'Feed me with QR Code'
                      : 'You found my little secret !\nEnable camera to allow carrot to help you check in attendance',
                  style: TextStyle(
                      color: (!darkModeOn && !attendance_enabled)
                          ? Colors.black
                          : Colors.amber[50],
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              if (!attendance_enabled)
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(108.0),
                    // side: BorderSide(color: Colors.red)
                  ),
                  color: Colors.amber[200],
                  // textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                  onPressed: () async {
                    var status = await Permission.camera.request();
                    if (status.isGranted) {
                      setState(() {
                        attendance_enabled = true;
                      });
                    }
                  },
                  child: Text(
                    "enable camera".toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
            ],
          ).alignment(Alignment.center),
          if (!attendance_enabled)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  canvas: Size(MediaQuery.of(context).size.width * 2,
                      MediaQuery.of(context).size.height),
                  confettiController: _controllerCenter,
                  blastDirection: 6.283,
                  maximumSize: Size(15, 6),
                  minimumSize: Size(10, 5),
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.startsWith('https://mmls.mmu.edu.my/attendance')) {
        controller.dispose();
        HapticFeedback.mediumImpact();
        Get.back();
        await 1.delay();
        Get.snackbar('Wheeeee', 'Checking in your attendance...',
            backgroundColor: Colors.amber[200]);
        
        
        var res = await API.attendanceCheckIn(scanData.split(':').last);
        print('bye');
        print(res);
        Get.snackbar('Info', res['message'] ?? '',
            backgroundColor: Colors.amber[200], duration: Duration(seconds: 6));
      }
    });
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    controller?.dispose();
    super.dispose();
  }
}
