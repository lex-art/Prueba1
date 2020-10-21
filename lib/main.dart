import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/login.dart';

Future<void> main() async {
  //nueva actualizacion de agosto necesitamos implementar esto para que funcione firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
  }
}
