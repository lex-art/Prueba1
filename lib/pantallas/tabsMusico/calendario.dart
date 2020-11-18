import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';
import 'package:xelafy/servicios/crearUsuario_service.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';
import 'package:xelafy/validarDatos/validarMixins.dart';
import 'package:xelafy/widgets/boton.dart';
import 'package:xelafy/widgets/textField.dart';

import '../musico.dart';

class CalendarioMusico extends StatefulWidget {
  @override
  _CalendarioMusicoState createState() => _CalendarioMusicoState();
}

class _CalendarioMusicoState extends State<CalendarioMusico>
    with ValidarMixins {
  //un global key permite referenciar a un formulario y desde él tener accesos al estado de un textFormfield
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String id, apellido, tipo, descrip, urlPhoto, telefono, nombre, correo;
  var usuarioLogueado;
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _decripcionController = TextEditingController();
  TextEditingController _enlaceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _decripcionController = TextEditingController();
    _enlaceController = TextEditingController();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff247898),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 50, left: 50),
              child: Column(
                children: <Widget>[
                  Text("Comparte tu contenido",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  _titulo(),
                  SizedBox(
                    height: 15,
                  ),
                  _descripcion(),
                  SizedBox(
                    height: 15,
                  ),
                  _link(),
                  _publicar(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _titulo() {
    return AppTextField(
      controller: _tituloController,
      validator: validar,
      autoValidate: _autovalidate,
      inputText: "Titulo",
      onSaved: (value) {},
    );
  }

  Widget _descripcion() {
    return AppTextField(
      controller: _decripcionController,
      validator: validar,
      autoValidate: _autovalidate,
      inputText: "Descripción ",
      onSaved: (value) {},
    );
  }

  Widget _link() {
    return AppTextField(
      controller: _enlaceController,
      autoValidate: _autovalidate,
      inputText: "Enlace de tu contenido",
      onSaved: (value) {},
    );
  }

  //--------------------------- Metodo para obtener el usaurios en la bd -----------
  void _getUser() async {
    //obtner el id del usuaio
    var user = await Authenticacion().getCurrentUser();
    usuarioLogueado = user;
    String idUser = usuarioLogueado.uid;

    //todos los datos de la coleccion
    final usuarios = await UsuarioService().getUsers('usuarios');
    for (var usuario in usuarios.docs) {
      //print("-----------------------------------------${usuario.get("rol")}");
      //verificamos que sea el mismo usuario
      if (usuario.id == idUser) {
        //si es el mismo usuairo, ahora vemos que rol tiene
        if (usuario.get("tiposUsuario") == "Músico") {
          nombre = usuario.get("nombres");
          apellido = usuario.get("apellidos");
          telefono = usuario.get("telefono");
          tipo = usuario.get("tiposUsuario");
          descrip = usuario.get("descripcion");
          correo = usuario.get("correo");
          urlPhoto = usuario.get("FotoPerfil");

          break;
        }
        print("-----hhhhhh-----" + usuario.id);
        print("-----jjjjjj-----" + idUser);
        print("----------" + nombre);
        print("----------" + telefono);
      } //else {
      ///print("111-------" + idUser);
      ///print("222-------" + usuario.id);
      // print("Usuario no valido");
      //}
    }
  }

  Widget _publicar() {
    return AppButton(
        color: Colors.blueAccent,
        nombre: "Publicar",
        onPressed: () async {
          var now = DateTime.now().toUtc().toLocal();
          if (_formkey.currentState.validate()) {
            ServicioUsuario().creaPublicacionMusico(
                collectionName: "publicaciones",
                collectionValues: {
                  "titulo": _tituloController.text,
                  "descripcion": _decripcionController.text,
                  "enlace": _enlaceController.text,
                  "nombre": nombre,
                  "telefono": telefono,
                  "correo": correo,
                  "fecha": formatDate(now, [dd, '/', mm, '/', yyyy]),
                  "tipoUsuario": "Músico",
                  "timestape": now, 
                });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewMusico(
                      id: id,
                      nombre: nombre,
                      apellido: apellido,
                      telefono: telefono,
                      tipo: tipo,
                      descrip: descrip,
                      correo: correo,
                      urlPhoto: urlPhoto),
                ));
          } else {
            setState(() {
              setState(() => _autovalidate = true);
            });
          }
        });
  }
}
