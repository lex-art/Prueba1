import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/cliente.dart';
import 'package:xelafy/pantallas/musico.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';
import 'package:xelafy/servicios/crearUsuario_service.dart';
import 'package:xelafy/validarDatos/validarMixins.dart';
import 'package:xelafy/widgets/boton.dart';
import 'package:xelafy/widgets/logo.dart';
import 'package:xelafy/widgets/mensajeError.dart';
import 'package:xelafy/widgets/textField.dart';

import 'crearUsuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with ValidarMixins {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //paa posicionar el parpadeo del texto esta definio en el archivo app_textField
  FocusNode _focusNode;
  bool showSpinner = false;
  //funcion que nos permitira validar el formulario
  bool _autoValidate = false;
  String _mensajeError = "";
  //un global key permite referenciar a un formulario y desde él tener accesos al estado de un textFormfield
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //guardamos el usuario que nos llega desde firebase, para poder crear una especie de sesion en la app
  var usuarioLogueado;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  //dispose libera los recursos que ya no se usan cuando salimos de la pantalla
  @override
  void dispose() {
    super.dispose();
    //asegurarnos que focus node libere  los recursos cuando ya no se utilice
    _focusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff961916),
      body: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(),
                SizedBox(
                  height: 30,
                ),
                _correo(),
                SizedBox(
                  height: 15,
                ),
                _contra(),
                _enviar(),
                _crearUsuario(),
                _showErrorMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _correo() {
    return AppTextField(
      controller: _emailController,
      autoValidate: _autoValidate,
      validator: validarEmail,
      key: ValueKey('textFielCorreo'),
      inputText: "Ingrese su correo",
      onSaved: (value) {},
    );
  }

  Widget _contra() {
    return AppTextField(
      autoValidate: _autoValidate,
      key: ValueKey('textFielPass'),
      controller: _passwordController,
      inputText: "Ingrese su contraseña",
      validator: validarPassword,
      obscureText: true,
      onSaved: (value) {},
    );
  }

  Widget _enviar() {
    return AppButton(
        color: Colors.blueAccent,
        nombre: "Ingresar",
        onPressed: () async {
          if (_formkey.currentState.validate()) {
            var auth = await Authenticacion().loginUser(
                email: _emailController.text,
                password: _passwordController.text);
            if (auth.exitoso) {
              //si el usuario existe se ve que tipo de usuario es
              _getUser();
            } else {
              //si no es exitoso entra en esta parte, donde muestra el error en un widget
              setState(() {
                _mensajeError = auth.mensajeError;
              });
            }
          } else {
            setState(() {
              setState(() => _autoValidate = true);
            });
          }
        });
  }

  Widget _crearUsuario() {
    return FlatButton(
      child: Text(
        "¿No tienes cuenta?",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearUsurio(),
            ));
      },
    );
  }

  //--------------------------- Metodo para obtener el usaurios en la bd -----------
  void _getUser() async {
    //obtner el id del usuaio
    var user = await Authenticacion().getCurrentUser();
    usuarioLogueado = user;
    String idUser = usuarioLogueado.uid;

    String nombre, apellidos, cel, tipo, descrip, correo;

    //todos los datos de la coleccion
    final usuarios = await UsuarioService().getUsers('usuario');
    for (var usuario in usuarios.docs) {
      //print("-----------------------------------------${usuario.get("rol")}");
      //verificamos que sea el mismo usuario
      if (usuario.id == idUser) {
        //si es el mismo usuairo, ahora vemos que rol tiene
        if (usuario.get("tiposUsuario") == "Músico") {
          nombre = usuario.get("nombres");
          apellidos = usuario.get("apellidos");
          cel = usuario.get("telefono");
          tipo = usuario.get("tiposUsuario");
          descrip = usuario.get("descripcion");
          correo = usuario.get("correo");
          //por ultimo lo redirigimos a la pagina que quiere
          //--redirige la pagina
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewMusico(id: usuario.id, nombre: nombre, apellido: apellidos, telefono: cel, tipo: tipo, descrip: descrip, correo: correo,),
              ));
        }
        if (usuario.get("tiposUsuario") == "Particular") {
          nombre = usuario.get("nombres");
          apellidos = usuario.get("apellidos");
          cel = usuario.get("telefono");
          tipo = usuario.get("tiposUsuario");
          descrip = usuario.get("descripcion");
          correo = usuario.get("correo");
          //--redirige la pagina
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewCliente(id: usuario.id, nombre: nombre, apellido: apellidos, telefono: cel, tipo: tipo, descrip: descrip, correo: correo,),
              ));
        }
      } //else {
      ///print("111-------" + idUser);
      ///print("222-------" + usuario.id);
      // print("Usuario no valido");
      //}
    }
  }

  Widget _showErrorMessage() {
    if (_mensajeError.length > 0 && _mensajeError != null) {
      return MensajeError(errorMessage: _mensajeError);
    } else {
      return Container(height: 0.0);
    }
  }
}
