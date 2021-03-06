import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),

      // SET de buuilder para usar dps no router
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        Registration.id: (context) => Registration(),
        Login.id: (context) => Login(),
        Chat.id: (context) => Chat(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const String id = "HOMESCREEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                width: 100.0,
                child: Image.asset("assets/image/logo.png"),
              ),
            ),
            Text(
              "  Unitau Chat",
              style: TextStyle(
                fontSize: 40.00,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50.0,
        ),
        CustomButton(
          text: "Login",
          callback: () {
            Navigator.of(context).pushNamed(Login.id);
          },
        ),
        CustomButton(
            text: "Registrar Nova Conta",
            callback: () {
              Navigator.of(context).pushNamed(Registration.id);
            })
      ],
    ));
  }
}

// BOTOES AUX
class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text})
      : super(key: key); // Constutor

  @override
  Widget build(BuildContext contex) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          color: Colors.blueGrey,
          elevation: 6.0,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: callback,
            minWidth: 200.0,
            height: 45.0,
            child: Text(text),
          )),
    );
  }
}

/*

CRIA PAGINAS

 */

// REGISTRO
class Registration extends StatefulWidget {
  static const String id = "REGISTRATION";

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de registro do usuario

  Future<void> registerUser() async {
    FirebaseUser user =
        (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext contex) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Unitau Chat Registro"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              // O EXPANDED AJUDA A IMAGEM A REDMENSIONAR DE ACORDO COM O APP
              child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset("assets/image/logo.png"),
                  )),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                hintText: "Insira o Email",
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextField(
              autocorrect: false, // nao utiliza corretor automatico
              obscureText: true, // nao mostra a senha
              onChanged: (value) => password = value,
              decoration: InputDecoration(
                hintText: "Insira a Senha",
                border: const OutlineInputBorder(),
              ),
            ),
            CustomButton(
              text: "Registrar",
              callback: () async {
                await registerUser();
              },
            )
          ],
        ));
  }
}

// LOGIN

class Login extends StatefulWidget {
  static const String id = "LOGIN";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Unitau Chat Login"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              // O EXPANDED AJUDA A IMAGEM A REDMENSIONAR DE ACORDO COM O APP
              child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset("assets/image/logo.png"),
                  )),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                hintText: "Email",
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextField(
              autocorrect: false, // nao utiliza corretor automatico
              obscureText: true, // nao mostra a senha
              onChanged: (value) => password = value,
              decoration: InputDecoration(
                hintText: "Senha",
                border: const OutlineInputBorder(),
              ),
            ),
            CustomButton(
              text: "Login",
              callback: () async {
                await loginUser();
              },
            )
          ],
        ));
  }
}

// CHAT
class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final FirebaseUser user;

  const Chat({Key key, this.user}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if(messageController.text.length > 0) {
      await
    _firestore.collection('messages').add({
      'text': messageController.text,
      'from': widget.user.email,
      'date': DateTime.now().toIso8601String().toString(),
    });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve:  Curves.easeOut,
      duration: const Duration(microseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40.0,
            child: Image.asset("assets/image/logo.png"),
          ),
        ),
        title: Text("Unitau Chat"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                List<DocumentSnapshot> docs = snapshot.data.documents;

                List<Widget> messages = docs
                    .map((doc) => Message(
                  from: doc.data['from'],
                  text: doc.data ['text'],
                  me: widget.user.email == doc.data['from']
                ) ).toList();

                return ListView(
                  controller: scrollController,
                  children: <Widget>[
                    ... messages,
                  ],
                );
              },
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onSubmitted: (value) => callback(),
                    decoration: InputDecoration(
                      hintText: "Digite uma mensagem ...",
                      border: const OutlineInputBorder(),
                    ),
                    controller: messageController,
                  ),
                ),
                SendButton(
                  text: "Enviar",
                  callback: callback,
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

// Botao de enviar

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding:  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}


