import 'package:flutter/material.dart';

class PerfilMusico extends StatefulWidget {
  @override
  _PerfilMusicoState createState() => _PerfilMusicoState();
}

class _PerfilMusicoState extends State<PerfilMusico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //padding: EdgeInsets.only(left: 25, right: 25),
      body: ListView(
        children: <Widget>[
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
      height: 900,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,           
              backgroundImage: NetworkImage('https://www.pudahuel.cl/wp-content/uploads/2020/05/ed65840db7f27b76abf2431bdcee5e81-768x517.jpg'),
            ),
            title: Row(children: [
              Text("Mon Laferte")
            ],),
            subtitle: Container(
              child: Text("Músico"),
            ) ,
          )
        ),
      ),
    );
  }
}
