import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:final_qr/models/user_data_model.dart';
import 'package:intl/intl.dart';

class ScanQR extends StatefulWidget {
  late List<String> time;
  late int id;
  ScanQR(String timeString, int id) {
    List<String> parts = timeString.split(':');
    this.time = parts;
    this.id = id;
    // int hour = int.parse(parts[0]);
    // int minute = int.parse(parts[1]);;
  }
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  Future<void> recordAttendance(String qrValue) async {
    TimeOfDay time = TimeOfDay(hour: 14, minute: 30); // Example time
    String formattedTime =
        DateFormat.Hm().format(DateTime(2022, 1, 1, time.hour, time.minute));
    List<String> timeList = formattedTime.split(":");
    int hour1 = int.parse(timeList[0]);
    int minute1 = int.parse(timeList[1]);
    int hour2 = int.parse(widget.time[0]);
    int minutes = int.parse(widget.time[1]);

    //Hardcoded status
    String status;
    print("H $hour1");
    print("H2 $hour2");

    // If attendance is greater than class time span then absent
    if (hour1 >= hour2 + 1) {
      status = "absent";
    } else {
      // if attendance minutes is less than 15 minutes then it is not late.
      if (minute1 < 15) {
        status = "present";
      } else {
        //If attendance is taken after 15 minutes then it is late.
        status = "late";
      }
    }

    print(jsonEncode(
      {
        "student": {
          "id": Provider.of<UserDataProvider>(context, listen: false)
              .getUserData
              .userId,
        },
        "date": DateFormat('MM/dd/yyyy').format(DateTime.now()),
        "time": formattedTime,
        "status": status,
        "classroom": {
          "id": qrValue,
        }
      },
    ));

    final response = await http.post(
      Uri.parse(
        '$server/register-classAttendance',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "student": {
            "id": Provider.of<UserDataProvider>(context, listen: false)
                .getUserData
                .userId,
          },
          "date": DateFormat('MM/dd/yyyy').format(DateTime.now()),
          "time": formattedTime,
          "status": status,
          "classroom": {
            "id": qrValue,
          }
        },
      ),
    );
  }

  MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            print('Barcode found!');
          }
          recordAttendance(barcodes[0].rawValue!);
          Provider.of<UserDataProvider>(context, listen: false)
              .classroomAttended
              .add(widget.id);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              content: Text("Attendance Recorded!"),
            ),
          );
        },
      ),
    );
  }
}
