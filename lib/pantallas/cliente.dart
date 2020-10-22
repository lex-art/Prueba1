import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/login.dart';
import 'package:xelafy/pantallas/tabsCliente/publicar.dart';
import 'package:xelafy/pantallas/tabsCliente/inicio.dart';
import 'package:xelafy/pantallas/tabsCliente/perfil.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';

class ViewCliente extends StatefulWidget {
  @override
  _ViewClienteState createState() => _ViewClienteState();
}

class _ViewClienteState extends State<ViewCliente> {

  Drawer getDrawer(BuildContext context) {  
    //opciones
    ListTile getItem(Icon icon, String description, String route) {
      return ListTile(
        leading: icon,
        title: Text(description),
        onTap: () {
          if (route == "salir") {
           Authenticacion().singOut();
            //cerramos todas las pantallas abiertas de la app
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) =>Login()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushNamed(context, route);
          }          
        },
      );
    }

    //lista de opcions
    ListView getList() {
      return ListView(
        children: <Widget>[
          //header,
          Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Opciones",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )),
          getItem(Icon(Icons.edit), "Editar Perfil", "/edit"),
          getItem(Icon(Icons.help_outline), "Ayuda", "/help"),
          getItem(Icon(Icons.exit_to_app), "Cerrar sesión", "salir"),         
        ],
      );
    }

    return Drawer(
      child: getList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xff961916),
              title: Text("Bienvenido cliente"),
  
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    icon: Icon(Icons.music_video),
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              )
              ),
              endDrawer: getDrawer(context),
              body: TabBarView(children: <Widget>[
                Inicio(), PerfilCliente(), Publicar(),
              ]),
        ));
  }
}
