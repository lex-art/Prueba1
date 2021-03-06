import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioUsuario {
  final _fireStore = FirebaseFirestore.instance;

  //-------------- suscripcion(con snapshot) a firestore para obtener los registros de los niños---------
  Stream<QuerySnapshot> getCollectionStream(String collectionName) {
    return _fireStore.collection(collectionName).snapshots();
  }

  Stream<QuerySnapshot> getPublicacionStream(String collectionName) {
    return _fireStore
        .collection(collectionName)
        .orderBy('timestape', descending: true)
        .snapshots();
  }

  void creaPublicacionMusico({
    String collectionName,
    Map<String, dynamic> collectionValues,
  }) //recibe los datos que son necesarios a guradar en la bd
  {
    ///collection recibe varios parametros para guardar en la bd primero la coleccion
    ///luego llamamos a la funcion add para agregar los datos
    //_fireStore.collection("usuarios").add(collectionValues);
    //guarda un documento con un id personalizado
    _fireStore.collection(collectionName).add(collectionValues);
  }

  void editarPublicacion({
    String collectionName,
    String idpublicacion,
    Map<String, dynamic> collectionValues,
  }) //recibe los datos que son necesarios a guradar en la bd
  {
    ///collection recibe varios parametros para guardar en la bd primero la coleccion
    ///luego llamamos a la funcion add para agregar los datos
    //_fireStore.collection("usuarios").add(collectionValues);
    //guarda un documento con un id personalizado
    _fireStore
        .collection(collectionName)
        .doc(idpublicacion)
        .update(collectionValues);
  }

  void eliminarPublicacion(String collectionName, String id) {
    _fireStore.collection(collectionName).doc(id).delete();
  }
}
