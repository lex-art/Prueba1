import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xelafy/pantallas/cliente.dart';
import 'package:xelafy/pantallas/musico.dart';
import 'package:xelafy/pantallas/tabsCliente/editar_publicar.dart';
import 'package:xelafy/pantallas/tabsMusico/editar_calendario.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';

String correo2, id, correo, nombre, apellido, telefono, tipo, descrip, urlPhoto;

class EditarPublicacion extends StatefulWidget {
  String id, correo, nombre, apellido, telefono, tipo, descrip, urlPhoto;
  EditarPublicacion(
      {this.id,
      this.correo,
      this.nombre,
      this.apellido,
      this.telefono,
      this.tipo,
      this.descrip,
      this.urlPhoto});
  @override
  _EditarPublicacionState createState() => new _EditarPublicacionState();
}

class _EditarPublicacionState extends State<EditarPublicacion> {
  @override
  void initState() {
    super.initState();
    correo2 = widget.correo;
    id = widget.id;
    correo = widget.correo;
    nombre = widget.nombre;
    apellido = widget.apellido;
    telefono = widget.telefono;
    tipo = widget.tipo;
    descrip = widget.descrip;
    urlPhoto = widget.urlPhoto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff961916),
            title: Text("Historial de tus publicaciones")),
        //padding: EdgeInsets.only(left: 25, right: 25),
        backgroundColor: Color(0xff247898),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: Text(
                "Tus publicaciones",
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
    if (publicacion.data()["correo"] == correo2) {
      publicaionItem.add(ItemPulicacion(
        idpublicacion: publicacion.id,
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
  }

  return publicaionItem;
}

class ItemPulicacion extends StatefulWidget {
  final String idpublicacion,
      titulo,
      descripcion,
      enlace,
      correo,
      tel,
      nombre,
      fecha,
      tipo;

  const ItemPulicacion(
      {this.idpublicacion,
      this.nombre,
      this.titulo,
      this.descripcion,
      this.enlace,
      this.correo,
      this.tel,
      this.fecha,
      this.tipo});

  @override
  _ItemPulicacionState createState() => _ItemPulicacionState();
}

class _ItemPulicacionState extends State<ItemPulicacion> {
  //cuanbdo se presiona el boton se ejecuta essta funcion
  void alertaDialogo(String value) {
    //asi se crea un alert dialog classic esta en la documentacion, matarialcomponet hats a abajo
    AlertDialog dialog = AlertDialog(
      //contenido del dialog
      content: Text(value,
          //style: TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center),
      //puede aplicarse varias acciones del dialog con actions y esta recibe una lista de widgets
      actions: <Widget>[
        //flat buton es un boton parecido al de raisebuton
        FlatButton(
            onPressed: () {
              ServicioUsuario()
                  .eliminarPublicacion("publicaciones", widget.idpublicacion);
              Navigator.pop(context);
            },
            child: Text("Si")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"))
      ],
    );
    //y debemos retornar un showDialog para que aparezaca
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 190,
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
                  Text(widget.titulo,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      Text("${widget.fecha} "),
                      InkWell(
                          child: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        widget.tipo == "Músico"
                                            ? EditarCalendarioMusico(
                                                id: widget.idpublicacion,
                                                titulo: widget.titulo,
                                                descripcion: widget.descripcion,
                                                enlace: widget.enlace)
                                            : EditarPublicar(
                                                id: widget.idpublicacion,
                                                titulo: widget.titulo,
                                                descripcion: widget.descripcion,
                                                enlace: widget.enlace)));
                          }),
                      InkWell(
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          alertaDialogo(
                              '¿Está seguro de eliminar esta publicación');
                        },
                      )
                    ],
                  ),
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
                      onTap: () => launch(widget.enlace)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nombre: ${widget.nombre}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        Text("Cel: ${widget.tel}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        Text("Contacto: ${widget.correo}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        Text("Profesión: ${widget.tipo}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        SizedBox(height: 15.0),
                        Text(widget.descripcion,
                            style: TextStyle(fontSize: 12)),
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
