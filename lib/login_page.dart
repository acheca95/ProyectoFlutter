import 'package:flutter/material.dart';
import 'package:jandulaseneca/sign_in.dart';
import 'package:animator/animator.dart';
import 'first_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  static AssetImage assetImage = AssetImage('assets/images/j.png');
  Image image = Image(image: assetImage, width: 100);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Animator<double>(
          tween: Tween<double>(begin: 0, end: 300),
          repeats: 1,
          duration: Duration(seconds: 2),
          builder: (anim1) => Animator<double>(
            tween: Tween<double>(begin: -1, end: 1),
            cycles: 4,
            builder: (anim2) => Center(
              child: Transform.rotate(
                angle: anim2.value,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  height: anim1.value,
                  width: anim1.value,
                  child: image,
                ),
              ),
            ),
          ),
        ),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FirstScreen();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
