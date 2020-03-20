import 'dart:math';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seneca2/paginas/seneca.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio de Sesion',
      home: MyHomePage(title: 'Inicio De Sesion'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<MyHomePage> {
  String _correo;
  String _contra;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static AssetImage assetImage = AssetImage('assets/images/j.png');
  Image image = Image(image: assetImage, width: 50);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:  Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    image,
                    SizedBox(height: 40),
                    Center(child:Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child:  TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Por favor introduzca un correo';
                        }
                      },
                      onSaved: (input) => _correo = input,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    ),
                    ),
                    RaisedButton(
                      onPressed: iniciarsesion,
                      child: Text('Iniciar Sesion'),
                    ),
                  ],
                ),

        ),

    );
  }

  Future<void> iniciarsesion() async {
    //   final formState = _formkey.currentState;
    //  if (formState.validate()) {
    //    formState.save();
    try {
      //  AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _correo, password: _contra);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => seneca()));
    } catch (e) {
      print(e.message);
    }
  }
}
