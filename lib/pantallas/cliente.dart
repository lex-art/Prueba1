import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/ayuda.dart';
import 'package:xelafy/pantallas/editarPublicaciones.dart';
import 'package:xelafy/pantallas/login.dart';
import 'package:xelafy/pantallas/tabsCliente/publicar.dart';
import 'package:xelafy/pantallas/tabsCliente/inicio.dart';
import 'package:xelafy/pantallas/tabsCliente/perfil.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';

import 'editarCliente.dart';

class ViewCliente extends StatefulWidget {
  final String id, nombre, apellido, telefono, tipo, descrip, correo, urlPhoto;
  ViewCliente({
    this.id,
    this.nombre,
    this.apellido,
    this.telefono,
    this.tipo,
    this.descrip,
    this.correo,
    this.urlPhoto,
  });
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
                MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false);
          }
          if (route == "/edit") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarCliente(
                    id: widget.id,
                    nombre: widget.nombre,
                    apellido: widget.apellido,
                    telefono: widget.telefono,
                    tipo: widget.tipo,
                    descrip: widget.descrip,
                    correo: widget.correo,
                  ),
                ));
          }
          if (route == "/help") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Ayuda()));
          } if (route == "/editar") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditarPublicacion(id: widget.id, 
                correo: widget.correo,
                nombre: widget.nombre,
                apellido: widget.apellido,
                telefono: widget.telefono,
                tipo: widget.telefono,
                descrip: widget.descrip,
                urlPhoto: widget.urlPhoto,
                
                )));
          }
          else {
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
          getItem(Icon(Icons.help_outline), "Tus publicaciones", "/editar"),
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
              title: Padding(
                 padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Bienvenido a Xelafy"),
                    widget.urlPhoto == ""
                        ? CircleAvatar(
                            radius: 23.0,
                            child: Text(widget.nombre[0].toUpperCase()),
                            backgroundColor: Theme.of(context).accentColor,
                          )
                        : CircleAvatar(
                            backgroundColor: Theme.of(context).buttonColor,
                            backgroundImage: NetworkImage(widget.urlPhoto),
                            radius: 23.0,
                          ),
                  ],
                ),
              ),
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
              )),
          endDrawer: getDrawer(context),
          body: TabBarView(children: <Widget>[
            Inicio(),
            PerfilCliente(),
            Publicar(),
          ]),
        ));
  }
}
