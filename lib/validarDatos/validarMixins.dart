class ValidarMixins {
    //--------------------- Métodos de validación para el formulario de crear usuario ------------
   String validarEmail(String value) {
    if (!value.contains('@') ) return "Correo Invalido";
    return null;
  }

  String validarPassword(String value) {
    if (value.length < 6) return "Contraseña invalida";
    return null;
  }

  String validar(String value) {
    if (value.length <= 0 ) return "Ingrese el dato correspondiente";
    return null;
  }
}