import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioUsuario {
  final _fireStore = FirebaseFirestore.instance;

  //-------------- suscripcion(con snapshot) a firestore para obtener los registros de los niños---------
  Stream<QuerySnapshot> getMusicoStream(String collectionName) {
    return _fireStore.collection(collectionName).snapshots();
  }
}