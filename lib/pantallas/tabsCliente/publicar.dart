import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/musico.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';
import 'package:xelafy/servicios/crearUsuario_service.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';
import 'package:xelafy/validarDatos/validarMixins.dart';
import 'package:xelafy/widgets/boton.dart';
import 'package:xelafy/widgets/textField.dart';

class Publicar extends StatefulWidget {
  @override
  _PublicarState createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> with ValidarMixins {
  //un global key permite referenciar a un formulario y desde él tener accesos al estado de un textFormfield
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String telefono, nombre, correo;
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
                  Text("Publica tu solicitud",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white
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
    final usuarios = await UsuarioService().getUsers('usuario');
    for (var usuario in usuarios.docs) {
      //print("-----------------------------------------${usuario.get("rol")}");
      //verificamos que sea el mismo usuario
      if (usuario.id == idUser) {
        //si es el mismo usuairo, ahora vemos que rol tiene
        telefono = usuario.get("telefono");
        nombre = usuario.get("nombres") + " " + usuario.get("apellidos");
        correo = usuario.get("correo");
        break;
      }
    } //else {
    ///print("111-------" + idUser);
    ///print("222-------" + usuario.id);
    // print("Usuario no valido");
    //}
  }

  Widget _publicar() {
    return AppButton(
        color: Colors.blueAccent,
        nombre: "Publicar",
        onPressed: () async {
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
                  "tipoUsuario": "Particular"
                });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewMusico(),
                ));
          } else {
            setState(() {
              setState(() => _autovalidate = true);
            });
          }
        });
  }
}
