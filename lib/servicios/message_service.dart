//importar el packge de firestone para guardar datos
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  //una isntacia de firestore para guardar datos
  final _fireStore = Firestore.instance;

  void save(
      {String collectionName,
      String idEnvia,
      String idDestino,
      Map<String, dynamic> collectionValues}) {
    //recibe los datos que son necesarios a guradar en la bd

    ///collection recibe varios parametros para guardar en la bd primero la coleccion
    ///luego llamamos a la funcion add para agregar los datos
    //_fireStore.collection(collectionName).doc().collection("chats").doc(id).collection('mensaje').add(collectionValues);
    _fireStore
        .collection(collectionName)
        .doc(idEnvia)
        .collection('chats')
        .doc(idDestino)
        .collection('mensajes')
        .doc()
        .set(collectionValues);
  }

  ///metodo para obtener los msj
  Future<QuerySnapshot> getMessage({String idEnvia, String idDestino}) async {
    // ignore: deprecated_member_use
    return await _fireStore.collection("usuriao/$idEnvia/chats/$idDestino/mensajes").getDocuments();
  }

  //suscripcion(con snapshot) a firestore para que nos envien automaticamente los msj
  Stream<QuerySnapshot> getMessageStream({String idEnvia, String idDestino}) {
    return _fireStore
        .collection("usuario/$idEnvia/chats/$idDestino/mensajes")
        .orderBy('timestamp')
        .snapshots();
  }
}
