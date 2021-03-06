import 'package:flutter/material.dart';
import 'package:xelafy/pantallas/chat/chat_screen.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';
import 'package:xelafy/servicios/serviciosUsuarios.dart';

var loggedInUser;
String nombreBusqueda;
String filter;

class PerfilCliente extends StatefulWidget {
  @override
  _PerfilClienteState createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //para la busqueta incia el buscador
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  //libera todos los recursos, el de buscar
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  ///para saber que usaruio se logueo hacemos un metodo para reconoces el usuario
  ///lo hacemos con frirebase, u.u es tan facil
  void getCurrentUser() async {
    //como lo fijimos firenbase trabaj con progra asyncrona y por eso se usa await y async
    var user = await Authenticacion().getCurrentUser(); //obtenemos el usaurio
    //le pasamos el usuriuo que trajimos de firebase y la asignamos la loggedInUdser
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //padding: EdgeInsets.only(left: 25, right: 25),
        backgroundColor: Color(0xff247898),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: Text(
                "Músicos Diponibles",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20.0, left: 20.0),
              child: TextField(
                  controller: searchController,                  
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Búscar Músico',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
            ),
            StreamBuilder(
                stream: ServicioUsuario().getCollectionStream('usuarios'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                        child: ListView(
                      children: _getMusicoItem(snapshot.data.documents),
                    ));
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: CircularProgressIndicator())],
                    );
                  }
                })
          ],
        )));
  }
}

//mapeamos los datos del stream
List<MusicoItem> _getMusicoItem(dynamic musicos) {
  List<MusicoItem> musicoItem = [];

  for (var musico in musicos) {
    if (musico.data()["tiposUsuario"] == "Músico") {
      musicoItem.add(MusicoItem(
        id: musico.id,
        nombre: musico.data()["nombres"],
        apellido: musico.data()["apellidos"],
        descripcion: musico.data()["descripcion"],
        correo: musico.data()["correo"],
        telefono: musico.data()["telefono"],
        urlPhoto: musico.data()["FotoPerfil"],
      ));
    }
  }
  return musicoItem;
}

class MusicoItem extends StatelessWidget {
  final String id, nombre, apellido, descripcion, telefono, correo, urlPhoto;

  const MusicoItem({
    this.id,
    this.nombre,
    this.apellido,
    this.descripcion,
    this.correo,
    this.telefono,
    this.urlPhoto,
  });

  @override
  Widget build(BuildContext context) {
    nombreBusqueda = nombre + " " + apellido;
    return filter == null || filter == ""
        ? Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            height: 120,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
              child: Container(
                  child: ListTile(
                leading: urlPhoto == ""
                    ? CircleAvatar(
                        radius: 35.0,
                        child: Text(nombre[0].toUpperCase()),
                        backgroundColor: Theme.of(context).accentColor,
                      )
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).buttonColor,
                        backgroundImage: NetworkImage(urlPhoto),
                        radius: 35.0,
                      ),
                title: Row(
                  children: [Text(nombreBusqueda)],
                ),
                subtitle: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Correo: $correo'),
                    Text('cel: $telefono'),
                    Text("Músico\n$descripcion"),
                  ],
                )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          idDestino: id,
                          nombre: nombre,
                          idEnvia: loggedInUser.uid,
                        ),
                      ));
                },
              )),
            ),
          )
        : nombreBusqueda.toLowerCase().contains(filter.toLowerCase())
            ? Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                height: 120,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Container(
                      child: ListTile(
                    leading: urlPhoto == ""
                        ? CircleAvatar(
                            radius: 35.0,
                            child: Text(nombre[0].toUpperCase()),
                            backgroundColor: Theme.of(context).accentColor,
                          )
                        : CircleAvatar(
                            backgroundColor: Theme.of(context).buttonColor,
                            backgroundImage: NetworkImage(urlPhoto),
                            radius: 35.0,
                          ),
                    title: Row(
                      children: [Text(nombreBusqueda)],
                    ),
                    subtitle: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Correo: $correo'),
                        Text('cel: $telefono'),
                        Text("Músico\n$descripcion"),
                      ],
                    )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              idDestino: id,
                              nombre: nombre,
                              idEnvia: loggedInUser.uid,
                            ),
                          ));
                    },
                  )),
                ),
              )
            : Container();
  }
}
