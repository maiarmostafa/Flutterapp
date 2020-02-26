import 'package:flutter/material.dart';
import 'package:courseproject/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegesterPage extends StatefulWidget {
  @override
  _RegesterPageState createState() => _RegesterPageState();
}

class _RegesterPageState extends State<RegesterPage> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool spinner = false;

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
                    )),
              ),
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
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Enter Your Password'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 125,
                  ),
                  RaisedButton(
                    color: Color(0xFF2372A3),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0)),
                    onPressed: () async {
                      setState(() {
                        spinner=true; 
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, '/profile');
                        }
                        setState(() {
                          spinner=false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Creat Account',
                      style: KTextstyle,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Flatbuttonss(
                  label: 'HAVE AN ACCOUNT ALREADY?',
                  style: FontWeight.bold,
                  onpressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
