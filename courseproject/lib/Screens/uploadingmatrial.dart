import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

final db = Firestore.instance;

class UploadingMatrial extends StatefulWidget {
  String courseTittel;
  UploadingMatrial({this.courseTittel});
  @override
  _UploadingMatrialState createState() => _UploadingMatrialState();
}

String _path;
Map<String, String> _paths;
String _extension;
bool _multiPick = false;
FileType _pickingType;
List<StorageUploadTask> _tasks = <StorageUploadTask>[];
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
FirebaseUser loggeduser;
final _auth = FirebaseAuth.instance;

File imgeFile;

final snackBar = SnackBar(content: Text('File Uploaded Successfully!'));

class _UploadingMatrialState extends State<UploadingMatrial> {
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

  Future getfile() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgeFile = img;
    });
  }

  Future openGallary() async {
    File picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgeFile = picture;
    });
  }

  onpenFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType, fileExtension: _extension);
      } else {
        _path = await FilePicker.getFilePath(
            type: _pickingType, fileExtension: _extension);
      }
      uploadtofirebase();
    } on PlatformException catch (e) {
      print('Unsupported Operation' + e.toString());
    }
    if (!mounted) {
      return;
    }
  }

  uploadtofirebase() async {
    if (_multiPick) {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
    } else {
      String fileName = _path.split('/').last;
      String filePath = _path;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) async {
    _extension = fileName.toString().split('.').last;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageReference.putFile(
        File(filePath),
        StorageMetadata(contentType: '$_pickingType/$_extension'));
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var r = await storageReference.getDownloadURL();
    setState(() {
      _tasks.add(uploadTask);
      String downurl = r.toString();
      db.collection("Materials").add({
        'Material_name': fileName,
        'download_url': downurl,
        'course_name': widget.courseTittel
      });
    });
  }

  downloadFile(StorageReference ref) {}
  dropDown() {
    return DropdownButton(
      hint: Text('Select File Type!'),
      value: _pickingType,
      items: <DropdownMenuItem>[
        DropdownMenuItem(
          child: Text('Aduio'),
          value: FileType.AUDIO,
        ),
        DropdownMenuItem(
          child: Text('Any'),
          value: FileType.ANY,
        ),
        DropdownMenuItem(
          child: Text('Video'),
          value: FileType.VIDEO,
        )
      ],
      onChanged: (value) {
        setState(() {
          _pickingType = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Upload Matrial(${widget.courseTittel})',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:Color(0xFF2372A3),
        elevation: 0.0,
        
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Card(
            elevation: 5,
            color: Colors.grey[300],
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('TO UPLOAD IMAGE',
                      style: TextStyle(color: Color(0xFF2372A3), fontSize: 20,
              fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center),
                  imgeFile == null
                      ? Text('No File selected yet!',
                          textAlign: TextAlign.center)
                      : Row(
                          children: <Widget>[
                            Image.file(
                              imgeFile,
                              width: 50,
                              height: 50,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                String filename = basename(imgeFile.path);
                                final StorageReference storageReference =
                                    FirebaseStorage.instance
                                        .ref()
                                        .child(filename);
                                final StorageUploadTask task =
                                    storageReference.putFile(imgeFile);
                                final StorageTaskSnapshot tasksnapshot =
                                    await task.onComplete;
                                String downurl =
                                    (await storageReference.getDownloadURL())
                                        .toString();
                                await db.collection("Materials").add({
                                  'Material_name': filename,
                                  'download_url': downurl,
                                  'course_name': widget.courseTittel
                                });
                                setState(() {
                                  print('File Uploaded Successfully!');
                                  Toast.show(
                                      'File Uploaded Successfully!', context);
                                });
                              },
                              child: Text(
                                'Upload!',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color(0xFF2372A3),
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                            )
                          ],
                        ),
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: getfile,
                        icon: Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        onPressed: openGallary,
                        icon: Icon(Icons.camera_front),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 5,
            color: Colors.grey[400],
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'TO UPLOAD PDF',
                    style: TextStyle(color: Color(0xFF2372A3), fontSize: 20,
              fontWeight: FontWeight.bold,),
                  ),
                  dropDown(),
                  SwitchListTile.adaptive(
                    value: _multiPick,
                    title: Text('Pick Multiple Files :',
                        textAlign: TextAlign.left),
                    onChanged: (bool value) {
                      setState(() {
                        _multiPick = value;
                      });
                    },
                  ),
                  OutlineButton(
                    child: Text('Open File Explorer'),
                    onPressed: () {
                      onpenFileExplorer();

                      Toast.show('File Uploaded Successfully!', context);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Upload State'),
        content: const Text('File Uploaded Successfully!'),
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
