import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xelafy/modelo/auth_respuesta.dart';

class UsuarioService {
  //una isntacia de firestore para guardar datos
  // ignore: deprecated_member_use
  final _fireStore = Firestore.instance;
   final _auth = FirebaseAuth.instance;

  ///Map <String, dynamic> asigna una  clave String con el  valor dinámico. Dado que la
  ///clave es siempre una cadena y el valor puede ser de cualquier tipo , se mantiene tan
  ///dinámica para estar en el lado más seguro. Es muy útil para leer un objeto JSON, ya
  /// que el objeto JSON representa un conjunto de pares clave-valor donde la clave es de
  /// tipo String, mientras que el valor puede ser de cualquier tipo, incluyendo String,
  /// List <String>, List <Object> o List <Map >. Eche un vistazo al siguiente ejemplo:

  void crearUsuarior(
      {String collectionName,
      Map<String, dynamic> collectionValues,
      String id}) //recibe los datos que son necesarios a guradar en la bd
  {
    ///collection recibe varios parametros para guardar en la bd primero la coleccion
    ///luego llamamos a la funcion add para agregar los datos
    //_fireStore.collection("usuarios").add(collectionValues);
    //guarda un documento con un id personalizado
    _fireStore.collection(collectionName).doc(id).set(collectionValues);
  }

  void actualizarUsuario(
      {String id,
      String collectionName,
      Map<String, dynamic> collectionValues, String email, String pass}) {

      _auth.currentUser.updateEmail(email);
      _auth.currentUser.updatePassword(pass);
    _fireStore.collection(collectionName).doc(id).update(collectionValues);
  }

  ///metodo para obtener los usuarios
  Future<QuerySnapshot> getUsers(String collectionName) async {
    // ignore: deprecated_member_use
    return await _fireStore.collection(collectionName).getDocuments();
  }

  ///metodo para obtener los usuarios
  Future<DocumentSnapshot> getUser(String collectionName, String id) async {
    // ignore: deprecated_member_use
    return await _fireStore.collection(collectionName).doc(id).get();
  }

  //suscripcion(con snapshot) a firestore para que nos envien automaticamente los msj
  Stream<QuerySnapshot> getUserStream() {
    return _fireStore.collection("usuarios").snapshots();
  }

  Future<AutenticacionRespuesta> updateDataUser({
    String id,
    Map<String, dynamic> collectionValues,
  }) async {
    AutenticacionRespuesta authenticationRequest = AutenticacionRespuesta();
    try {
      await _fireStore.collection('usuarios').doc(id).update(collectionValues);
      authenticationRequest.exitoso = true;
    } catch (e) {
      _mapErrorMessage(authenticationRequest, e.code);
    }
    return authenticationRequest;
  }

  Future<AutenticacionRespuesta> deleteDataUser({String id}) async {
    AutenticacionRespuesta authenticationRequest = AutenticacionRespuesta();
    try {
      await _fireStore.collection('usuarios').doc(id).delete();
      authenticationRequest.exitoso = true;
    } catch (e) {
      _mapErrorMessage(authenticationRequest, e.code);
    }
    return authenticationRequest;
  }

  //para el manejo de errores (mapero de errores) de firebase
  void _mapErrorMessage(AutenticacionRespuesta authRequest, String code) {
    //code es el msj de errorde
    //firebase y la tenemos que mapear
    switch (code) {
      case 'not-found':
        authRequest.mensajeError = "Usuario no encontrado";
        break;
      case 'wrong-password':
        authRequest.mensajeError = "Contraseña incorrecta";
        break;
      case 'network-request-failed':
        authRequest.mensajeError = "Error de red";
        break;
      case 'email-already-in-use':
        authRequest.mensajeError = "El usuario ya está registrado";
        break;
      case 'invalid-email':
        authRequest.mensajeError = "El correo es incorrecto";
        break;
      case 'unknown':
        authRequest.mensajeError = "Ingrese todos los datos";
        break;
      case 'weak-password':
        authRequest.mensajeError = "Su contraseña es muy débil";
        break;

      default:
        authRequest.mensajeError = code;
    }
  }
}
