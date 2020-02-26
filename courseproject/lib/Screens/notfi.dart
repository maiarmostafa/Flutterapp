import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final db = Firestore.instance;
FirebaseUser loggeduser;
final _auth = FirebaseAuth.instance;
DocumentSnapshot doc;
String loggin;

class NotfiPage extends StatefulWidget {
  @override
  _NotfiPageState createState() => _NotfiPageState();
}

class _NotfiPageState extends State<NotfiPage> {
  bool spinner=false;

  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }

  void getCurrentuser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggeduser = user;
        loggin=(loggeduser == null )?('Please wait, loading...'): (loggeduser.uid);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF2372A3),
        elevation: 0.0,
        title: Text('Notfications'),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico'),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: <Widget>[Notfistream()],
      ),
    );
  }
}

class Notfistream extends StatefulWidget {
  @override
  _NotfistreamState createState() => _NotfistreamState();
}

class _NotfistreamState extends State<Notfistream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('Enroll_Notifications').snapshots(),
      builder: (context, snapshot) {
         if (snapshot.hasError) return Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting)
          return SpinKitChasingDots(
            color: Colors.black87,
            size: 20,
          );
        if (snapshot.hasData != true) {
          return Text(
            'There is no Notfication,yet!',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2372A3)),
          );
        }
        final course = snapshot.data.documents.reversed;
        List<Notfibuble> notfiWs = [];
        for (var courses in course) {
          if (loggeduser.uid == courses.data['notifiable_id']) {
            final studentEmail = courses.data['content'];

            final notfiW = Notfibuble(
              studentEmail: studentEmail,
            );
            notfiWs.add(notfiW);
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: notfiWs,
          ),
        );
      },
    );
  }
}

class Notfibuble extends StatefulWidget {
  final String studentEmail;
  Notfibuble({this.studentEmail});
  @override
  _NotfibubleState createState() => _NotfibubleState();
}

class _NotfibubleState extends State<Notfibuble> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
          elevation: 5.0,
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Student ${widget.studentEmail}.',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFF2372A3),
                      fontFamily: 'Source Sans Pro'),
                ),
                
              ],
            ),
          )),
    );
  }
}
