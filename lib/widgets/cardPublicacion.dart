import 'package:flutter/material.dart';

class CardPublicacion extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Theme.of(context).accentColor,
     // elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Material(
              //color: Color(0xff006CD9),
              //borderRadius: BorderRadius.circular(10.0),
              //sombra
              elevation: 8.0,
              //tamaño del boton
              child: Container(
                color:Colors.deepPurple,

              )),
          
          
        ])),
      ),
    );
  }
}
