import 'package:flutter/material.dart';
import 'package:xelafy/servicios/crearUsuario_service.dart';
import 'package:xelafy/validarDatos/validarMixins.dart';
import 'package:xelafy/widgets/mensajeError.dart';
import 'package:xelafy/widgets/boton.dart';
import 'package:xelafy/widgets/textField.dart';

import 'login.dart';

class EditarCliente extends StatefulWidget {
  final String id, nombre, apellido, telefono, tipo, descrip, correo;
  EditarCliente(
      {this.id,
      this.nombre,
      this.apellido,
      this.telefono,
      this.tipo,
      this.descrip,
      this.correo});
  @override
  _EditarClienteState createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarCliente> with ValidarMixins {
  TextEditingController _nomnbreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _descrController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //paa posicionar el parpadeo del texto esta definio en el archivo app_textField
  FocusNode _focusNode;
  bool showSpinner = false;
  //funcion que nos permitira validar el formulario
  bool _autoValidate = false;
  //un global key permite referenciar a un formulario y desde él tener accesos al estado de un textFormfield
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _lista = ["Músico", "Particular"];
  //seleccion del rol
  String _tiposUsuario = "Músico";
  String _mensajeError = "";

  //guardamos el usuario que nos llega desde firebase, para poder crear una especie de sesion en la app

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    print(widget.id);
    _nomnbreController = TextEditingController(text: widget.nombre);
    _apellidoController = TextEditingController(text: widget.apellido);
    _telController = TextEditingController(text: widget.telefono);
    _descrController = TextEditingController(text: widget.descrip);
    _emailController = TextEditingController(text: widget.correo);
    _passwordController = TextEditingController();
  }

  //dispose libera los recursos que ya no se usan cuando salimos de la pantalla
  @override
  void dispose() {
    super.dispose();
    //asegurarnos que focus node libere  los recursos cuando ya no se utilice
    _focusNode.dispose();
    _nomnbreController.dispose();
    _apellidoController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tiposUsuario = widget.tipo;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff961916),
        title: Text("Edita tus datos "),
      ),
      backgroundColor: Color(0xff247898),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          children: [
            Form(
              key: _formkey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      _nombre(),
                      SizedBox(
                        height: 15,
                      ),
                      _apellido(),
                      SizedBox(
                        height: 15,
                      ),
                      _tel(),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: DropdownButton(
                          items: _lista.map((String a) {
                            return DropdownMenuItem(value: a, child: Text(a));
                          }).toList(),
                          onChanged: (_value) => {
                            setState(() {
                              _tiposUsuario = _value;
                            }),
                          },
                          hint: Text(_tiposUsuario,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      _descripcion(),
                      SizedBox(
                        height: 15,
                      ),
                      _correo(),
                      SizedBox(
                        height: 15,
                      ),
                      _contra(),
                      _resgistrar(),
                      _showErrorMessage()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _nombre() {
    return AppTextField(
      autoValidate: _autoValidate,
      controller: _nomnbreController,
      focusNode: _focusNode,
      validator: validar,
      inputText: "Ingrese sus nombres",
      onSaved: (value) {},
    );
  }

  Widget _apellido() {
    return AppTextField(
      autoValidate: _autoValidate,
      controller: _apellidoController,
      validator: validar,
      inputText: "Ingrese sus apellidos",
      onSaved: (value) {},
    );
  }

  Widget _tel() {
    return AppTextField(
      autoValidate: _autoValidate,
      controller: _telController,
      validator: validar,
      inputText: "Ingrese su número de teléfono",
      onSaved: (value) {},
    );
  }

  Widget _descripcion() {
    return AppTextField(
      autoValidate: _autoValidate,
      controller: _descrController,
      validator: validar,
      inputText: "Descripción breve sobre ti",
      onSaved: (value) {},
    );
  }

  Widget _correo() {
    return AppTextField(
      controller: _emailController,
      autoValidate: _autoValidate,
      validator: validarEmail,
      inputText: "Ingrese su correo",
      onSaved: (value) {},
    );
  }

  Widget _contra() {
    return AppTextField(
      autoValidate: _autoValidate,
      controller: _passwordController,
      inputText: "Ingrese su contraseña",
      validator: validarPassword,
      obscureText: true,
      onSaved: (value) {},
    );
  }

  Widget _resgistrar() {
    return AppButton(
        color: Colors.blueAccent,
        nombre: "Actualizar",
        onPressed: () async {
          if (_formkey.currentState.validate()) {
            //guardamos los datos del usuario creado
            UsuarioService().actualizarUsuario(
              id: widget.id,
              collectionName: 'usuario',
              collectionValues: {
                "nombres": _nomnbreController.text,
                "apellidos": _apellidoController.text,
                "telefono": _telController.text,
                "correo": _emailController.text,
                "descripcion": _descrController.text,
                "tiposUsuario": _tiposUsuario,
              },
              email: _emailController.text,
              pass: _passwordController.text,
            );
            //cerramos todas las pantallas abiertas de la app
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false);

            _nomnbreController.text = "";
            _apellidoController.text = "";
            _telController.text = "";
            _emailController.text = "";
            _passwordController.text = "";
            _descrController.text = "";
            FocusScope.of(context).requestFocus(_focusNode);
          } else {
            setState(() {
              setState(() => _autoValidate = true);
            });
          }
        });
  }

  Widget _showErrorMessage() {
    if (_mensajeError.length > 0 && _mensajeError != null) {
      return MensajeError(errorMessage: _mensajeError);
    } else {
      return Container(height: 0.0);
    }
  }
}
