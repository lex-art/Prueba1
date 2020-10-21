//importar el packge de firestone para guardar datos
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  //una isntacia de firestore para guardar datos
  final _fireStore = Firestore.instance;

  void save(
      {String collectionName,
      Map<String, dynamic>
          collectionValues}){
            //recibe los datos que son necesarios a guradar en la bd

    ///collection recibe varios parametros para guardar en la bd primero la coleccion
    ///luego llamamos a la funcion add para agregar los datos
    _fireStore.collection("message").add(collectionValues);
  }

  ///metodo para obtener los msj
  Future<QuerySnapshot> getMessage() async {
    // ignore: deprecated_member_use
    return await _fireStore.collection('usuarios').getDocuments();
  }

  //suscripcion(con snapshot) a firestore para que nos envien automaticamente los msj
  Stream<QuerySnapshot> getMessageStream() {
    return _fireStore.collection("usuriaos").orderBy('timestamp').snapshots();
  }
}
