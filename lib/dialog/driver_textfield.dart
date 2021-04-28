import 'package:driver/dialog/section_wrapper.dart';
import 'package:flutter/material.dart';

class DriverTextField extends StatelessWidget {
  DriverTextField({
    @required this.textCtl,
    @required this.width,
    @required this.fieldName,
    this.upperSeparator = false,
    this.blackTitle = false,
    this.centralText = false,
    this.altFunctionOnEditingCompleted = false,
    this.textScaleFactor = 1.0,
    this.titleCorrection = 0.0,
    this.altFunction,
    this.node,
  });

  final double width;
  final String fieldName;
  final TextEditingController textCtl;
  final bool upperSeparator;
  final bool blackTitle;
  final bool centralText;
  final bool altFunctionOnEditingCompleted;
  final double textScaleFactor;
  final double titleCorrection;
  final Function(BuildContext context) altFunction;
  final FocusNode node;

  @override
  Widget build(BuildContext context) {

    if(textCtl.text == null) textCtl.text = '';

    return SizedBox(
      child: Column(
        children: <Widget>[
          // SEPARATORIA VERTICALE
          if((upperSeparator != null) && upperSeparator)
            SizedBox(height: 10),
          // NOME CAMPO
          Row(
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              SizedBox(
                width: width - (5.0 + titleCorrection),
                child: Text(
                  fieldName.toUpperCase() + ':',
                  textAlign: TextAlign.start,
                  textScaleFactor: textScaleFactor,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: blackTitle ? Colors.black : Colors.blueAccent,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
          // TEXT FIELD PER INSERIMENTO/MODIFICA
          SectionWrapper(
            height: 62,
            width: width,
            padding: 2,
            child: TextFormField(
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              controller: textCtl,
              focusNode: node,
              textDirection: TextDirection.ltr,
              textAlign: centralText ?TextAlign.center : TextAlign.start,
              onEditingComplete: () => (altFunctionOnEditingCompleted)
                  ? altFunction(context)
                  : _onEditingComplete(context),
              style: TextStyle(
                fontSize: 14.0 * textScaleFactor,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Metodo invocato al termine di un inserimento.
  _onEditingComplete(BuildContext context) => FocusScope.of(context).unfocus();
}