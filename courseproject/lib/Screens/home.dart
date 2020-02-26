import 'package:flutter/material.dart';
import 'package:courseproject/container.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag:'Logo',
              child: Circeleavatarimage(radius: 60.0,)),
            TyperAnimatedTextKit(text:['Professor Application'],textStyle: TextStyle(fontSize: 25,color: Color(0xFF5F92A5)),),
            SizedBox(
              height: 50,
            ),
            
            Rowbuttons(
                colorr: Color(0xFF2372A3),
                textt: Text('Sign in with Email', style: KTextstyle),onpressed: () {
                Navigator.pushNamed(context, '/login');
              },),
            Rowbuttons(
                colorr: Color(0xFF5F92A5),
                textt: Text('Regester Now', style: KTextstyle),onpressed: () {
                Navigator.pushNamed(context, '/Regester');
              },)
          ],
        ),
      ),
    );
  }
}
