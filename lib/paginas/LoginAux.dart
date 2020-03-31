import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jandulaseneca/first_screen.dart';

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
  Image image = Image(image: assetImage, width: 100);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                image,
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    child: ListView(children: <Widget>[
                      TextFormField(
                        validator: ValidarEmail,
                        onSaved: (input) => _correo = input,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Por favor introduzca una contraseña';
                          }
                        },
                        onSaved: (input) => _contra = input,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                        ),
                      ),
                      RaisedButton(
                        onPressed: iniciarsesion,
                        child: Text('Iniciar Sesion'),
                      ),
                    ]),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String ValidarEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Introduzca un E-mail Valido';
    else
      return null;
  }

  Future<void> iniciarsesion() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        {
          AuthResult auth = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _correo, password: _contra)  ;
          FirebaseUser user = auth.user;
         // Navigator.push(context,MaterialPageRoute(builder: (context) => seneca(user :user)));
        }
      } catch (e) {
        print(e.message);
      }
    }
  }
}
