import 'package:courseproject/Screens/uploadingmatrial.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final db = Firestore.instance;
FirebaseUser loggeduser;
final _auth = FirebaseAuth.instance;
DocumentSnapshot doc;

class Listcourses extends StatefulWidget {
  @override
  _ListcoursesState createState() => _ListcoursesState();
}

class _ListcoursesState extends State<Listcourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Courses List'),
        backgroundColor:Color(0xFF2372A3),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico'),
              
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[Coursesteam()],
      ),
    );
  }
}

class Coursesteam extends StatefulWidget {
  @override
  _CoursesteamState createState() => _CoursesteamState();
}

class _CoursesteamState extends State<Coursesteam> {
  FirebaseUser loggeduser;

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
        print(loggeduser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('Course').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting)
          return SpinKitChasingDots(
            color: Colors.black87,
            size: 20,
          );
        if (snapshot.hasData != true) {
          return Text(
            'There is no courses,yet!',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2372A3)),
          );
        }
        final course = snapshot.data.documents.reversed;
        List<Coursebuble> courseWs = [];
        for (var courses in course) {
          if (loggeduser.uid == courses.data['Professor']) {
            final coursedescription = courses.data['Description'];
            final courseTittel = courses.data['Title'];
            final coursehours = courses.data['Hours'];
            final courseMajor = courses.data['Major'];
            final courseLMOS = courses.data['Limited number of students'];

            final courseW = Coursebuble(
              coursedescription: coursedescription,
              coursehours: coursehours,
              courseLMOS: courseLMOS,
              courseMajor: courseMajor,
              courseTittel: courseTittel,
            );
            courseWs.add(courseW);
          }
        }
        return Expanded(
            child: ListView(
          reverse: false,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: courseWs,
        ));
      },
    );
  }
}

class Coursebuble extends StatefulWidget {
  final String coursedescription;
  final String courseTittel;
  final String coursehours;
  final String courseMajor;
  final String courseLMOS;
  Coursebuble(
      {this.coursedescription,
      this.coursehours,
      this.courseLMOS,
      this.courseMajor,
      this.courseTittel});

  @override
  _CoursebubleState createState() => _CoursebubleState();
}

class _CoursebubleState extends State<Coursebuble> {
  @override
  void initState() {
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
                Center(
                  child: Text(
                    widget.courseTittel,
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF2372A3),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Source Sans Pro'),
                  ),
                ),
                Center(
                  child: Text(
                    widget.courseMajor,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF2372A3),
                        fontFamily: 'Source Sans Pro'),
                  ),
                ),
                Center(
                  child: Text(
                    widget.coursedescription,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF2372A3),
                        fontFamily: 'Source Sans Pro'),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
               Row(children: <Widget>[
                SizedBox(
                  width: 100.0,
                ),
                Text(
                  'Hours: ${widget.coursehours}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2372A3),
                      fontFamily: 'Source Sans Pro'),
                ),SizedBox(
                  width: 20.0,
                ),
                Text(
                  'Limited to: ${widget.courseLMOS}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2372A3),
                      fontFamily: 'Source Sans Pro'),
                ),
               ],),
                SizedBox(
                  width: 2000,
                  height: 20,
                  child: Divider(
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   Text('Upload Materials',style: TextStyle(color: Colors.grey[600]),),
                    IconButton(
                      icon: Icon(Icons.file_upload,color: Colors.black,),
                      onPressed:(){
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadingMatrial(courseTittel: widget.courseTittel),
                                ));
                      }
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

void updateData(DocumentSnapshot doc) async {
  await db.collection('Course').document(doc.documentID).updateData({});
}

void deletedata(DocumentSnapshot doc) async {
  final user = await _auth.currentUser();
  if (user != null) {
    loggeduser = user;
  }
  await db.collection('Course').document(doc.documentID).delete();
}

void courseStream() async {
  await for (var snapshot in db.collection('Course').snapshots()) {
    for (var course in snapshot.documents) {
      print(course.data);
    }
  }
}
