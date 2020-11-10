import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:xelafy/servicios/crearUsuario_service.dart';
import 'package:xelafy/validarDatos/validarMixins.dart';
import 'package:xelafy/widgets/mensajeError.dart';
import 'package:xelafy/widgets/boton.dart';
import 'package:xelafy/widgets/textField.dart';

import 'login.dart';

class EditarUsuario extends StatefulWidget {
  final String id, nombre, apellido, telefono, tipo, descrip, correo;
  EditarUsuario(
      {this.id,
      this.nombre,
      this.apellido,
      this.telefono,
      this.tipo,
      this.descrip,
      this.correo});
  @override
  _EditarUsuarioState createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> with ValidarMixins {
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
  var _lista = ["Músico", "Usuario"];
  //seleccion del rol
  String _tiposUsuario = "Usuario";
  String _mensajeError = "";
  File sampleImage; // va obtner la images de la galeria

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

//metodo para la barra de progreso
  void setSpinnerStatus(bool status) {
    //re-renderizar la app para que muestre el progres bar
    setState(() {
      showSpinner = status;
    });
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
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Form(
                key: _formkey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: sampleImage == null
                                  ? Text(
                                      "Selecciona una imagen de perfil",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : enableUpload(),
                            ),
                            FloatingActionButton(
                              onPressed: getImage,
                              tooltip: "Add Image",
                              child: Icon(Icons.add_a_photo),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                        SizedBox(
                          height: 15,
                        ),
                        _actualizar(),
                        _showErrorMessage()
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget enableUpload() {
    return Image.file(sampleImage, width: 150);
  }

  Future getImage() async {
    //escoja la foto de su galeria
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
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

  Widget _actualizar() {
    return AppButton(
        color: Colors.blueAccent,
        nombre: "Actualizar",
        onPressed: () async {
          if (_formkey.currentState.validate()) {
            setSpinnerStatus(true);

            //primero guardamos la imagen que se subio

            if (sampleImage != null) {
              var imgUrl;
              Reference imageReferencia = FirebaseStorage.instance.ref().child(
                  _emailController
                      .text); //carpeta en firebase storage donde guardara las fotos
              //para subir la imagen a storage
              UploadTask uploadTask = imageReferencia.putFile(sampleImage);

              uploadTask.whenComplete(() async {
                try {
                  imgUrl = await imageReferencia.getDownloadURL();
                  // await Future.delayed(Duration(seconds: 15));
                  print(imgUrl.toString() + "-------------awqui-555----------");

                  UsuarioService().actualizarUsuario(
                    id: widget.id,
                    collectionName: 'usuarios',
                    collectionValues: {
                      "nombres": _nomnbreController.text,
                      "apellidos": _apellidoController.text,
                      "telefono": _telController.text,
                      "correo": _emailController.text,
                      "descripcion": _descrController.text,
                      "tiposUsuario": _tiposUsuario,
                      "FotoPerfil": imgUrl.toString(),
                    },
                    email: _emailController.text,
                    pass: _passwordController.text,
                  );
                  //cerramos todas las pantallas abiertas de la app
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                } catch (onError) {
                  print("Error");
                }
              });
            } else {
              //guardamos los datos del usuario creado

              UsuarioService().actualizarUsuario(
                id: widget.id,
                collectionName: 'usuarios',
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
            }

            // _nomnbreController.text = "";
            // _apellidoController.text = "";
            // _telController.text = "";
            // _emailController.text = "";
            // _passwordController.text = "";
            // _descrController.text = "";
            FocusScope.of(context).requestFocus(_focusNode);
            setSpinnerStatus(false);
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
