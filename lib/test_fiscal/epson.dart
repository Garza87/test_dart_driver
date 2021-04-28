import 'dart:convert';
import 'dart:io';
import 'package:driver/dialog/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';

class Epson {
  Epson();

  Future<void> checkStatus(String ip, int port, Duration timeout, BuildContext context) async {

    String command = "01E107401";
    int checksum = 0;
    for(int i = 0; i < command.length; i++) checksum += command.codeUnitAt(i);
    checksum = checksum % 100;
    command = "2$command${(checksum < 10) ? "0$checksum" : checksum}3";
    List<int> bytes = utf8.encode(command);
    try {
      await Socket.connect(ip, port, timeout: timeout).then((Socket socket) {
        socket.add(bytes);
        var returnValue = socket.done;
        print('Risposta ricevuta: $returnValue');
        PlatformAlertDialog(
            title: "Risposta ottenuta:",
            content: returnValue.toString(),
            defaultActionText: "Ok",
        ).show(context);
        socket.destroy();
      });
    } catch (e) {
      await PlatformAlertDialog(
        title: "Errore nel metodo checkStatus per EPSON",
        content: e.toString(),
        defaultActionText: "Ok",
      ).show(context);
    }
  }

}