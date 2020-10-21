import 'package:flutter/material.dart';
import 'package:xelafy/widgets/cardPublicacion.dart';

class InicioMusico extends StatefulWidget {
  @override
  _InicioMusicoState createState() => _InicioMusicoState();
}

class _InicioMusicoState extends State<InicioMusico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //padding: EdgeInsets.only(left: 25, right: 25),
      body: ListView(
        children: <Widget>[
          Item(),
          Item(),
          Item(),
        ],
      )


  
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 200,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Proximo Evento", style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 16)),
              Image.network('http://204.11.233.100/la_revista/espectaculos/oficial-Juntos-Concierto-Foto-Facebook_LRZIMA20180418_0070_11.jpg', height: 140, ),
            ],
          ),
        ),
      ),
    );
  }
}
