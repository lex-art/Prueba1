import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';

class InicioMusico extends StatefulWidget {
  @override
  _InicioMusicoState createState() => _InicioMusicoState();
}

class _InicioMusicoState extends State<InicioMusico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //padding: EdgeInsets.only(left: 25, right: 25),
        backgroundColor: Color(0xff247898),
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
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )),
            ),
            StreamBuilder(
                stream: ServicioUsuario().getPublicacionStream('publicaciones'),
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
      fecha: publicacion.data()["fecha"],
      tipo: publicacion.data()["tipoUsuario"],
    ));
  }
  return publicaionItem;
}

class ItemPulicacion extends StatelessWidget {
  final String titulo, descripcion, enlace, correo, tel, nombre, fecha, tipo;

  const ItemPulicacion(
      {this.nombre,
      this.titulo,
      this.descripcion,
      this.enlace,
      this.correo,
      this.tel,
      this.fecha,
      this.tipo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 180,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(titulo,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("$fecha"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      child: Icon(
                        Icons.link,
                        color: Color(0xff961916),
                        size: 120,
                      ),
                      onTap: () => launch(enlace)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nombre: $nombre",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        Text("Cel: $tel",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        Text("E-mail: $correo",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        Text("Profesión: $tipo",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
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
