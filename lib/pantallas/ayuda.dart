import 'package:flutter/material.dart';

class Ayuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff961916),
        title: Text("Para mas información"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text("CasaNoj\nZona 1 Quetzaltenago"),
      ),
    );
  }
}
