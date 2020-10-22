import 'package:flutter/material.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';
import 'package:url_launcher/url_launcher.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  
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
            "Publicaciones recientes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Theme.of(context).accentColor,
            ),
            textAlign: TextAlign.center,
          )),
        ),
        StreamBuilder(
            stream: ServicioUsuario().getMusicoStream('publicacionMusico'),
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
List<ItemPulicacion> _getMusicoItem(dynamic publicaciones) {
  List<ItemPulicacion> publicaionItem = [];

  for (var publicacion in publicaciones) {
    publicaionItem.add(ItemPulicacion(
      titulo: publicacion.data()["titulo"],
      nombre: publicacion.data()["nombre"],
      correo: publicacion.data()["correo"],
      descripcion: publicacion.data()["descripcion"],
      enlace: publicacion.data()["enlace"],
      tel: publicacion.data()["telefono"],
    ));
  }
  return publicaionItem;
}

class ItemPulicacion extends StatelessWidget {
  final String titulo, descripcion, enlace, correo, tel, nombre;
  const ItemPulicacion(
      {this.nombre,
      this.titulo,
      this.descripcion,
      this.enlace,
      this.correo,
      this.tel});

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
              Text(titulo,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      child: Icon(
                        Icons.queue_play_next,
                        color: Theme.of(context).accentColor,
                        size: 120,
                      ),
                      onTap: () => launch(
                          "https://www.youtube.com/watch?v=DMrFMuUcM4o&list=TLPQMjIxMDIwMjDdeVLgsySxNg&index=15")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombre,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(tel,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(correo,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 15.0),
                        Text(descripcion, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
