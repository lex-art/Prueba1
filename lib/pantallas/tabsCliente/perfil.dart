import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/chat/chat_screen.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';

class PerfilCliente extends StatefulWidget {
  @override
  _PerfilClienteState createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //padding: EdgeInsets.only(left: 25, right: 25),
        body: SafeArea(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(            
              child: Text(
            "Músicos Diponibles",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.center,
          )),
        ),
        StreamBuilder(
            stream: ServicioUsuario().getMusicoStream('usuario'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Flexible(
                    child: ListView(
                  children: _getMusicoItem(snapshot.data.documents),
                ));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(child: CircularProgressIndicator())],
                );
              }
            })
      ],
    )));
  }
}

//mapeamos los datos del stream
List<MusicoItem> _getMusicoItem(dynamic musicos) {
  List<MusicoItem> musicoItem = [];

  for (var musico in musicos) {
    if (musico.data()["tiposUsuario"] == "Músico") {
      musicoItem.add(MusicoItem(
        id: musico.id,
        nombre: musico.data()["nombres"],
        apellido: musico.data()["apellidos"],
        descripcion: musico.data()["descripcion"],
      ));
    }
  }
  return musicoItem;
}

class MusicoItem extends StatelessWidget {
  final String id, nombre, apellido, descripcion;
  const MusicoItem({
    this.id,
    this.nombre,
    this.apellido,
    this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 115,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                child: Text(nombre[0].toUpperCase()),
                backgroundColor: Theme.of(context).accentColor,
              ),

              //leading: CircleAvatar(
              //  radius: 25,
              //  //child: Text(nombre[0].toUpperCase()),
              //backgroundColor: Theme.of(context).buttonColor,
              //backgroundImage: NetworkImage(
              //  'https://www.pudahuel.cl/wp-content/uploads/2020/05/ed65840db7f27b76abf2431bdcee5e81-768x517.jpg'),
              // ),
              title: Row(
                children: [Text("$nombre $apellido")],
              ),
              subtitle: Container(
                child: Text("Músico\n$descripcion"),
              ),
              onTap: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(id: id, nombre: nombre,),
              ));
                
              },
            )),
      ),
    );
  }
}
