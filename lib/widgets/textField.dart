import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  //el placejolder
  final String inputText;
  //Gurdar el valor del input
  final ValueChanged<String> onSaved;
  //para contraseñas
  final bool obscureText;
  //controller del textfield
  final TextEditingController controller;
  //controlar la posición del parpadeo
  final FocusNode focusNode;
  //tipo de teclado
  //para que cuando haya un error y despues se corrija este desaparezca el error
  final bool autoValidate;
  //llave para poder hacer las pruebas
  final Key key;
  final FormFieldValidator<String> validator;

  // constructor
  const AppTextField(
      {this.inputText,
      this.onSaved,
      this.controller,
      this.focusNode,
      this.obscureText,
      this.validator,
      this.autoValidate,
      this.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //para la autovalidacion de los textfield
      autovalidate: autoValidate,
      //para la autovalidacion de los textfield
      // autovalidate: autoValidate,
      validator: validator,
      key: key,
      //pa posicionar el texto en un text field
      focusNode: focusNode, //posiciona el cursor
      controller: controller, //limpiar el texto3
      // keyboardType: textInputType == null ? TextInputType.text : textInputType,
      decoration: InputDecoration(
        ///tamaño del textDield
        isDense: true,
        contentPadding: EdgeInsets.all(10),
        //color de relleno
        filled: true,
        fillColor: Colors.white,

        ///tamaño del textField
        hintText: inputText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: Color(0xff247898), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Color(0xff247898), width: 1)),
      ),
      onSaved: onSaved, //guarda lo que se intruduce en el textfield
      textAlign: TextAlign.center,
      obscureText: obscureText == null ? false : obscureText,
    );
  }
}
