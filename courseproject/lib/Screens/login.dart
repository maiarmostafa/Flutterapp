import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:courseproject/container.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final messagecontroler = TextEditingController();
  String email;
  String password;
  bool spinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xFF2372A3)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: Hero(
                      tag: 'Logo',
                      child: Circeleavatarimage(
                        radius: 100,
                      ))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Enter Your Email'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter Your Password'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 85,
                  ),
                  RaisedButton(
                    color: Color(0xFF2372A3),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0)),
                    onPressed: () {
                      setState(() {
                        spinner=true;
                      });
                      signIn(email, password);
                      setState(() {
                        spinner=false;
                      });
                    },
                    child: Text(
                      'Login',
                      style: KTextstyle,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flatbuttonss(label: 'Forget Password?')
                ],
              ),
              SizedBox(
                height: 75,
              ),
              Expanded(
                child: Flatbuttonss(
                  label: 'CREAT NEW ACCOUNT?',
                  style: FontWeight.bold,
                  onpressed: () {
                    Navigator.pushNamed(context, '/Regester');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> signIn(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        Navigator.pushNamed(context, '/profile');
      }
    } catch (e) {
      print(e);
    }
  }
}
