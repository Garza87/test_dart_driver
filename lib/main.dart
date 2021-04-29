import 'package:driver/dialog/driver_textfield.dart';
import 'package:driver/dialog/section_wrapper.dart';
import 'package:driver/printer_manager/manager.dart';
import 'package:driver/test_fiscal/custom.dart';
import 'package:driver/test_fiscal/epson.dart';
import 'package:driver/ticket/ticket.dart';
import 'package:driver/utils/barcode.dart';
import 'package:driver/utils/capability_profile.dart';
import 'package:driver/utils/enums.dart';
import 'package:driver/utils/pos_column.dart';
import 'package:driver/utils/pos_styles.dart';
import 'package:flutter/material.dart';
import 'dialog/platform_alert_dialog.dart';
import 'ethernet_wifi/enums.dart';

void main() async {
  runApp(MaterialApp(home: MyApp()));
  /*
  final PrinterNetworkManager printerManager = PrinterNetworkManager();
  // To discover network printers in your subnet, consider using
  // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
  // Note that most of ESC/POS printers are available on port 9100 by default.
  printerManager.selectPrinter('172.31.20.207', port: 9100);

  final PosPrintResult res = await printerManager.printTicket(await testTicket());
  print('Print result: ${res.msg}');
   */
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoading = false;
  bool first = true;
  TextEditingController ipCtl;
  TextEditingController portCtl;
  PrinterNetworkManager printerManager;
  FocusScopeNode node;

  @override
  Widget build(BuildContext context) {

    if(first) {
      ipCtl = new TextEditingController();
      ipCtl.text = '';
      portCtl = new TextEditingController();
      portCtl.text = '';
      printerManager = new PrinterNetworkManager();
      first = false;
    }

    return SectionWrapper(
      width: 900,
      height: 900,
      background: Color(0xffe4faff),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DriverTextField(
              textCtl: ipCtl,
              width: 860,
              fieldName: "Indirizzo IP",
              titleCorrection: 99,
              blackTitle: true,
            ),
            DriverTextField(
              textCtl: portCtl,
              width: 860,
              fieldName: "Numero di porta",
              titleCorrection: 99,
              blackTitle: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 75,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => testEscPos(context),
                    child: Center(
                      child: SizedBox(
                        child: Text(
                          "TEST\nESC POS",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 75,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => statusEpson(context),
                    child: Center(
                      child: SizedBox(
                        child: Text(
                          "STATO\nEPSON",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 75,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => statusRTCustom(context),
                    child: Center(
                      child: SizedBox(
                        child: Text(
                          "STATO RT\nCUSTOM",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<int> getPortNumber(TextEditingController portCtl, BuildContext context) async {
    String port = portCtl.text.trim();
    try {
      int returnValue = int.parse(port);
      return returnValue;
    } catch (e) {
      print(e);
      await PlatformAlertDialog(
        title: "Errore nel numero di porta",
        content: "Il numero di porta inserito non risulta accettabile.\nIl valore che risulta inserito e\': ${portCtl.text}",
        defaultActionText: "Ok",
      ).show(context);
    }
    return -1;
  }

  Future<void> setManager(int portNumber, String ip, BuildContext context) async {
    try {
      setState(() {
        printerManager.selectPrinter(ip, port: portNumber);
      });
    } catch (e) {
      print(e);
      await PlatformAlertDialog(
          title: "Errore nell'impostazione del manager",
          content: e.toString(),
          defaultActionText: "Ok",
      ).show(context);
    }
  }

  Future<void> statusEpson(BuildContext context) async {
    try {
      if (isLoading) return null;
      setState(() {
        isLoading = true;
      });
      int portNumber = await getPortNumber(portCtl, context);
      if (portNumber < 0) {
        setState(() {
          isLoading = false;
        });
        return null;
      }
      String ipAdd = ipCtl.text.trim();
      await setManager(portNumber, ipAdd, context);
      Epson eps = new Epson();
      await eps.checkStatus(
        printerManager.getIP(),
        printerManager.getPort(),
        printerManager.getTimeout(),
        context,
      );
    } catch (e) {
      print(e);
      await PlatformAlertDialog(
        title: "Errore nel metodo statusEpson",
        content: e.toString(),
        defaultActionText: "Ok",
      ).show(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> statusRTCustom(BuildContext context) async {
    try {
      if (isLoading) return null;
      setState(() {
        isLoading = true;
      });
      int portNumber = await getPortNumber(portCtl, context);
      if (portNumber < 0) {
        setState(() {
          isLoading = false;
        });
        return null;
      }
      String ipAdd = ipCtl.text.trim();
      await setManager(portNumber, ipAdd, context);
      Custom custom = new Custom();
      await custom.checkRTStatus(
        printerManager.getIP(),
        printerManager.getPort(),
        printerManager.getTimeout(),
        context,
      );
    } catch (e) {
      print(e);
      await PlatformAlertDialog(
        title: "Errore nel metodo statusRTCustom",
        content: e.toString(),
        defaultActionText: "Ok",
      ).show(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> testEscPos(BuildContext context) async {
    if(isLoading) return null;
    setState(() {
      isLoading = true;
    });
    try {
      int portNumber = await getPortNumber(portCtl, context);
      if (portNumber < 0) {
        setState(() {
          isLoading = false;
        });
        return null;
      }
      String ipAdd = ipCtl.text.trim();
      await setManager(portNumber, ipAdd, context);
      final profile = await CapabilityProfile.load();
      final Ticket ticket = Ticket(PaperSize.mm80, profile);
      ticket.text(
          'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
      ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
          styles: PosStyles(codeTable: 'CP1252'));
      ticket.text(
          'Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

      ticket.text('Bold text', styles: PosStyles(bold: true));
      ticket.text('Reverse text', styles: PosStyles(reverse: true));
      ticket.text('Underlined text',
          styles: PosStyles(underline: true), linesAfter: 1);
      ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
      ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
      ticket.text('Align right',
          styles: PosStyles(align: PosAlign.right), linesAfter: 1);

      ticket.row([
        PosColumn(
          text: 'col3',
          width: 3,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'col6',
          width: 6,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'col3',
          width: 3,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
      ]);

      ticket.text('Text size 200%',
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));

      // Print image
      // final ByteData data = await rootBundle.load('assets/logo.png');
      // final Uint8List bytes = data.buffer.asUint8List();
      // final Image image = decodeImage(bytes);
      // ticket.image(image);
      // Print image using alternative commands
      // ticket.imageRaster(image);
      // ticket.imageRaster(image, imageFn: PosImageFn.graphics);

      // Print barcode
      final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
      ticket.barcode(Barcode.upcA(barData));

      // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
      // ticket.text(
      //   'hello ! 中文字 # world @ éphémère &',
      //   styles: PosStyles(codeTable: PosCodeTable.westEur),
      //   containsChinese: true,
      // );

      ticket.feed(2);
      ticket.cut();

      try {
        final PosPrintResult res = await printerManager.printTicket(ticket);
        print('Print result: ${res.msg}');
        await PlatformAlertDialog(
          title: "Messaggio di ritorno:",
          content: res.msg,
          defaultActionText: "Ok",
        ).show(context);
      } catch (e) {
        print(e);
        await PlatformAlertDialog(
          title: "Errore nel metodo testEscPos\n(parte finale)",
          content: e.toString(),
          defaultActionText: "Ok",
        ).show(context);
      }

    } catch (e) {
      print(e);
      await PlatformAlertDialog(
        title: "Errore nel metodo testEscPos",
        content: e.toString(),
        defaultActionText: "Ok",
      ).show(context);
    }
    setState(() {
      isLoading = false;
    });
  }

}

