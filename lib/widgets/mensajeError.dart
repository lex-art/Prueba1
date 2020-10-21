import 'package:flutter/material.dart';

class MensajeError extends StatelessWidget {
  final String errorMessage;
  MensajeError({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Alerta'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(errorMessage, ),
            ],
          ),
        ));
  }
}
