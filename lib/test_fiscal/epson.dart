import 'dart:io';
import 'package:driver/dialog/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';

class Epson {
  Epson();

  Future<void> checkStatus(String ip, int port, Duration timeout, BuildContext context) async {
    String command = "01E107401";
    int checksum = 0;
    for(int i = 0; i < command.length; i++) checksum += command.codeUnitAt(i);
    checksum = checksum % 100;
    command = String.fromCharCode(02) + "$command${(checksum < 10) ? "0$checksum" : checksum}" + String.fromCharCode(03);
    //print(command);
    try {
      final socket = await Socket.connect(ip, port, timeout: timeout);
      socket.listen(

        // handle data from the server
            (Uint8List data) {
          final serverResponse = String.fromCharCodes(data);
          print('Server: $serverResponse');
          PlatformAlertDialog(
            title: "Risposta ottenuta:",
            content: '$serverResponse',
            defaultActionText: "Ok",
          ).show(context);
        },

        // handle errors
        onError: (error) {
          print(error);
          socket.destroy();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          socket.destroy();
        },
      );
      socket.write(command);
      /*
      List<int> bytes = utf8.encode(command);
      await Socket.connect(ip, port, timeout: timeout).then((Socket socket) async {
        socket.add(bytes);
        var returnValue = await socket.flush();
        print('Risposta ricevuta: $returnValue');
        PlatformAlertDialog(
            title: "Risposta ottenuta:",
            content: returnValue.toString(),
            defaultActionText: "Ok",
        ).show(context);
        socket.destroy();
      });
      */
    } catch (e) {
      await PlatformAlertDialog(
        title: "Errore nel metodo checkStatus per EPSON",
        content: e.toString(),
        defaultActionText: "Ok",
      ).show(context);
    }
  }

}