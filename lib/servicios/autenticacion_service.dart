import 'package:firebase_auth/firebase_auth.dart';
import 'package:xelafy/modelo/auth_respuesta.dart';

class Authenticacion {
  final _auth = FirebaseAuth.instance;

  Future<AutenticacionRespuesta> createUser(
      {String email, String password}) async {
    //creamos una instancia de AuthenticationRequest, Devuelve true si la creación de usuario fue exitosa
    AutenticacionRespuesta authRespuesta = AutenticacionRespuesta();
    //por si hay un error lo envolvemos priumero en un try catch
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        //si el usuario fue creado exitosamente
        authRespuesta.exitoso = true;
      }
    } catch (e) {
      _mapErrorMessage(authRespuesta, e.code);
    }
    //si no hay un resultado enviamos null
    return authRespuesta;
  }

  ///ahora hacemos lo mismo para la sesion del usuario

//------------------------- Metodo para obtener los datos del usuario ----------------------
  // ignore: deprecated_member_use
  ///ahora hacemos lo mismo para la sesion del usuario
  Future getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///----------------------- metodo para loguear al usuario --------------------------------
  Future<AutenticacionRespuesta> loginUser(
      {String email, String password}) async {
    //hacemos a crear una instancia de AuthenticationRequest
    AutenticacionRespuesta authRespuesta = AutenticacionRespuesta();
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password); //funcion de firebase para autenticacion del user
      if (user != null) {
        //si el usuario fue logueado exitosamente
        authRespuesta.exitoso = true;
      }
    } catch (e) {
      _mapErrorMessage(authRespuesta, e.code);
    }
    return authRespuesta;
  }

//---------------------------- funcion para poder salir de sesion ------------------
  Future<void> singOut() async {
    try {
      return await _auth.signOut(); //con esto cerramos sesion
    } catch (e) {
      print(e);
    }
    return null;
  }

  //para el manejo de errores (mapero de errores) de firebase
  void _mapErrorMessage(AutenticacionRespuesta authRespuesta, String code) {
    //code es el msj de errorde
    //firebase y la tenemos que mapear
    switch (code) {
      case 'user-not-found':
        authRespuesta.mensajeError = "Usuario no encontrado";
        break;
      case 'wrong-password':
        authRespuesta.mensajeError = "Contraseña incorrecta";
        break;
      case 'network-request-failed':
        authRespuesta.mensajeError = "Error de red";
        break;
      case 'email-already-in-use':
        authRespuesta.mensajeError = "El usuario ya está registrado";
        break;
      case 'invalid-email':
        authRespuesta.mensajeError = "El correo es incorrecto";
        break;
      case 'unknown':
        authRespuesta.mensajeError = "Ingrese todos los datos";
        break;
      case 'weak-password':
        authRespuesta.mensajeError = "Su contraseña es muy débil";
        break;
      case 'requires-recent-login':
        authRespuesta.mensajeError = "Inicia sesión de neuvo";
        break;

      default:
        authRespuesta.mensajeError = code;
    }
  }
}
