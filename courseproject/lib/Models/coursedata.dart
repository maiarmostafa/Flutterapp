import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String description;
  final String hours;
  final String major;
  final String title;
  final String limitednum;
  String id;
  final db = Firestore.instance;

  Course(
      {this.description, this.hours, this.limitednum, this.major, this.title});

  void update(DocumentSnapshot doc) async {
    await db.collection('Course').document(doc.documentID).updateData({});
  }

  void delete(DocumentSnapshot doc) async {
    await db.collection('Course').document(doc.documentID).delete();
    //setState(() => id = null);
  }
}
