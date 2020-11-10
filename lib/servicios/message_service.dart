//importar el packge de firestone para guardar datos
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  //una isntacia de firestore para guardar datos
  final _fireStore = Firestore.instance;

  void save(
      {String collectionName,
      String idDestino,
      String idEnvia,
      Map<String, dynamic> collectionValues}) {
    //recibe los datos que son necesarios a guradar en la bd

    ///collection recibe varios parametros para guardar en la bd primero la coleccion
    ///luego llamamos a la funcion add para agregar los datos
    //_fireStore.collection(collectionName).doc().collection("chats").doc(id).collection('mensaje').add(collectionValues);
    //Guarda los mensajes en el que envia 
    _fireStore
       .collection(collectionName)
       .doc(idEnvia)
       .collection('chats')
       .doc(idDestino)
       .collection('mensajes')
       .doc()
       .set(collectionValues);
       //Guarda mensaje al que lo reciba para que podamos leer los msj 
       _fireStore
       .collection(collectionName)
       .doc(idDestino)
       .collection('chats')
       .doc(idEnvia)
       .collection('mensajes')
       .doc()
       .set(collectionValues);
    
  }

  ///metodo para obtener los msj
  Future<QuerySnapshot> getMessage({String idEnvia, String idDestino}) async {
    // ignore: deprecated_member_use
    return await _fireStore
        .collection("usurios/$idEnvia/chats/$idDestino/mensajes")
        .getDocuments();
  }

  //suscripcion(con snapshot) a firestore para que nos envien automaticamente los msj
  Stream<QuerySnapshot> getMessageStream({String idEnvia, String idDestino}) {
    return _fireStore
        .collection("usuarios/$idDestino/chats/$idEnvia/mensajes")
        .orderBy('timestamp')
        .snapshots();
  }
}
