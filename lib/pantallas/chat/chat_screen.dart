import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xelafy/servicios/autenticacion_service.dart';
import 'package:xelafy/servicios/message_service.dart';

bool tipo = false;

class ChatScreen extends StatefulWidget {
  final String idDestino, idEnvia, nombre;
  ChatScreen({this.idDestino, this.idEnvia, this.nombre});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //para poder usar firebase tenemos que declara una instancia para poder utilizarlo a nivel de nuestro codigo
  ///instance creau un nuevo objeto, pero lo crea a travez de un singelton, lo que hace es que crea una
  ///solamente una instancia de un objeto y no la crea cada vez que se llama un objeto, si no que solo una vez se crea para
  ///varios objetos  y queda disponoble para toda la app vy aqui hacemos uso de esta sin necesidad de crear otro objeto
  final auth = FirebaseAuth.instance;
  //un contralodr para capturar en todo momento los cabios que hagan en el edit text
  TextEditingController _messageController = TextEditingController();

  //guardamos el usuario que nos llega desde firebase, para poder crear una especie de sesion en la app
  // ignore: deprecated_member_use
  var loggedInUser;

  //estilos para el text field
  InputDecoration _messageTextFieldDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      hintText: 'Ingrese su mensaje aqui.....');

  BoxDecoration _messageContainerDecoration = BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xff961916), width: 2.0)));

  TextStyle _sendButtonStryle = TextStyle(
      color: Color(0xff961916), fontWeight: FontWeight.bold, fontSize: 18.0);
  //init satate es como un constructor, es la primera funcion que se gatilla cuando se ejecuta esta pantalla
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _getMessages();
  }

  ///para saber que usaruio se logueo hacemos un metodo para reconoces el usuario
  ///lo hacemos con frirebase, u.u es tan facil
  void getCurrentUser() async {
    //como lo fijimos firenbase trabaj con progra asyncrona y por eso se usa await y async
    var user = await Authenticacion().getCurrentUser(); //obtenemos el usaurio
    //le pasamos el usuriuo que trajimos de firebase y la asignamos la loggedInUdser
    if (user != null) {
      loggedInUser = user;
      //print(widget.idDestino + " destino ++++++++++++++++++++++++++++++++++");
      //print(widget.idEnvia + " envia ++++++++++++++++++++++++++++++++++");
    }
  }

  //metodo para obtener datos desde firestore
  //void _getMessages() async {
  //  final messages = await MessageService().getMessage();
  //  for (var message in messages.documents) {
  //    print(message.data);
  //  }
  //}
//metodo para suscribirnos por medio del stream
  void _getMessages() async {
    await for (var snapshot in MessageService().getMessageStream()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contactar a: ${widget.nombre}"),
        backgroundColor: Color(0xff961916),
      ),
      //pantalla de chat  DIseño
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //implementacion del stream builder
            StreamBuilder(
                //recibe dos parametros
                stream: MessageService().getMessageStream(
                  idEnvia: widget.idEnvia,
                  idDestino: widget.idDestino,
                ), //escucha los datos que llegan del stream
                builder: (context, snapshot) {
                  //este metodo se activa cada vez que el stream esucha algun dato nuevo en el stream y re-renderiza la app
                  //obtenemos los datos desde firestore
                  if (snapshot.hasData) {
                    //hastdata  esta en la documentaacion y trae los datos del stream
                    // var messages = snapshot.data.documents;
                    // List<Text> messageWidgets = [];
                    //messageWidgets.add(Text(
                    //'$messagesValue de $messagesSender'

                    //re renderizar en la app, flexible permite adaptarse al tamaño de nuestro dispositivo
                    //y permita hacer scroll
                    return Flexible(
                        child: ListView(
                      children: _getChatItems(
                          snapshot.data.documents), //messageWidgets,
                    ));
                  }
                  return Container();
                }),

            Container(
                decoration: _messageContainerDecoration,
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: _messageTextFieldDecoration,
                      controller: _messageController,
                    ),
                  ),
                  FlatButton(
                    //es la que se encarga de enviar los datos a firestone
                    child: Text(
                      "Enviar",
                      style: _sendButtonStryle,
                    ),
                    onPressed: () {
                      ///collection recibe varios parametros para guardar en la bd primero la coleccion
                      ///luego llamamos a la funcion add para agregar los datos
                      MessageService().save(
                          collectionName: "usuarios",
                          idEnvia: widget.idEnvia,
                          idDestino: widget.idDestino,
                          collectionValues: {
                            'value': _messageController
                                .text, //unasmos un controler para capturar los datos del estic text
                            'sender': loggedInUser.email,
                            'timestamp': DateTime.now()
                          });
                      setState(() {});
                      _messageController.clear();
                    },
                  )
                ]))
          ],
        ),
      ),
    );
  }

  List<ChatItem> _getChatItems(dynamic messages) {
    //para darle formato al chat
    //aqui es el correo de quien lo envia
    List<ChatItem> chatItems = [];
    for (var message in messages) {
      final messagesSender = message.data()["sender"];
      final messagesValue = message.data()["value"];
      print(messagesValue);
      //style: TextStyle(fontSize: 20.0),
      chatItems.add(ChatItem(
          //con isloggedInUser podemos ver quien manda el msj, comparamos quien envia con el usaurio que incio sesion
          message: messagesValue,
          sender: messagesSender,
          isLoggedInUser: messagesSender == loggedInUser.email));
      //print(message + "-----------------------");
    }
    return chatItems;
  }
}

//chat item, donde se visualiza todo el chat
class ChatItem extends StatelessWidget {
  final String sender;
  final String message;
  final bool isLoggedInUser; //para ver que usario manda el msj

  ChatItem({this.message, this.sender, this.isLoggedInUser});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        //nos permitira poner un msj encima del otro
        child: Column(
          crossAxisAlignment: isLoggedInUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(fontSize: 15.0, color: Colors.black54),
            ), //es el usuario que mando el msj
            //el msj, lo envolevemos en una tipo burbuja con material
            SizedBox(
              height: 5,
            ),
            Material(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30)),
                elevation: 5.0,
                color: isLoggedInUser ? Colors.lightBlueAccent : Colors.white,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              isLoggedInUser ? Colors.white : Colors.black45),
                    )))
          ],
        ));
  }
}
