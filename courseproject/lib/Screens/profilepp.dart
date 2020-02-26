import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseproject/container.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

var _majors=['Development','Design','Business'];

class Profilepage extends StatefulWidget {
  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  var _Cselcted;
  FirebaseUser loggeduser;
  final _auth = FirebaseAuth.instance;
  String id;
  String description;
  String hours;
  String title;
  String limitednum;
  String prof;
  bool spinner= false;
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(0xFF2372A3)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              child: Text(
                'Log Out!',
                style: TextStyle(fontSize: 17),
              ),
              textColor: Colors.red[900],
            ),
          ],
        ),
        drawer: ModalProgressHUD(
          inAsyncCall: spinner,
          child: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: (loggeduser==null)?Text("not Logged"): Text('${loggeduser.email}',style: KTextstyle),
                  accountName: Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    child: Text(
                      'P',
                      style: KTextstyle,
                    ),
                  ),
                ),
                Titlerepeted(
                    textdata: 'Add New Course',
                    onpressed: () {
                      setState(() {
                      spinner=true;
                    });
                      Navigator.pushNamed(context, '/profile');
                      setState(() {
                      spinner=false;
                    });
                    },
                    icondata: Icons.add),
                Titlerepeted(
                  textdata: 'List Courses',
                  onpressed: () {
                    setState(() {
                      spinner=true;
                    });
                    Navigator.pushNamed(context, '/listcourse');
                    setState(() {
                      spinner=false;
                    });
                  },
                  icondata: Icons.chrome_reader_mode,
                ),
                Titlerepeted(
                  textdata: 'Notfications',
                  icondata: Icons.notifications,
                  onpressed: () {
                    setState(() {
                      spinner=true;
                    });
                    Navigator.pushNamed(context, '/notfi');
                    setState(() {
                        spinner=false;
                      });
                  },
                ),
                Divider()
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Text('ADD NEW COURSE',style: TextStyle(fontSize: 20),),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Textfieldrepeted(
                      onchanged: (value) {
                        description = value;
                      },
                      inputDecoration: 'Description',
                    ),
                    Textfieldrepeted(
                      onchanged: (value) {
                        hours = value;
                      },
                      inputDecoration: 'Hours',
                    ),
                    Textfieldrepeted(
                      onchanged: (value) {
                        title = value;
                      },
                      inputDecoration: 'Title',
                    ),
                    Textfieldrepeted(
                      onchanged: (value) {
                        limitednum = value;
                      },
                      inputDecoration: 'Limited Nummber Of Students',
                    ),
                    Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: DropdownButton<String>(
                        hint: Text('Select Major'),
                        isExpanded: true,
                        items: _majors.map((String dropDownStringItem)
                        {
                          return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValue){
                          setState(() {
                              this._Cselcted=newValue;
                          });
                        },
                        value: _Cselcted,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: creatcourse,
          child: Icon(Icons.add),
        ));
  }

  void creatcourse() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      DocumentReference doc = await db.collection('Course').add({
        'Description': description,
        'Hours': hours,
        'Limited number of students': limitednum,
        'Major': _Cselcted,
        'Title': title,
        'Professor': loggeduser.uid,
      });
      setState(() => id = doc.documentID);
      print(doc.documentID);
      ackAlert(context);

    }
  }
}
Future<void> ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Upload State'),
        content: const Text('Course added Successfully!'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
