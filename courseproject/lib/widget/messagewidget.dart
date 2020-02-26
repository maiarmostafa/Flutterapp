import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseproject/Models/notificationdata.dart';
import 'package:courseproject/api/messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final TextEditingController titleController =
      TextEditingController();
  final TextEditingController bodyController =
      TextEditingController();
  final List<Message> messages = [];
  final Firestore _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _messaging.onTokenRefresh.listen(sendTokenServer);
    _messaging.getToken();
    _messaging.subscribeToTopic('all');

    _messaging.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      final notification = message['notification'];
      setState(() {
        messages.add(
            Message(title: notification['title'], body: notification['body']));
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLanch: $message");
      setState(() {
        messages.add(Message(title: '$message', body: 'Onlaunch:'));
      });
      final notification = message['data'];
      setState(() {
        messages.add(Message(
            title: 'Onlaunch: ${notification['title']}',
            body: 'Onlaunch: ${notification['body']}'));
      });
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume $message");
    });
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true));
 StreamSubscription iosSubscription;
        if (Platform.isIOS) {
            iosSubscription = _messaging.onIosSettingsRegistered.listen((data) {
                // save the token  OR subscribe to a topic here
            });

            _messaging.requestNotificationPermissions(IosNotificationSettings());
        }

          /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    // Get the current user
    final user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _messaging.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(user.email)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
        
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        TextFormField(
          controller: bodyController,
          decoration: InputDecoration(labelText: 'Body'),
        ),
        RaisedButton(
          onPressed: sendNotification,
          child: Text('Send notification'),
        )
      ]..addAll(messages.map(buildmessage).toList()),
    );
  }

  Widget buildmessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  void sendNotification() async{
    final response =await Messaging.sendToAll(
      title: titleController.text,
      body: bodyController.text,
    );
    if(response.statusCode !=200){
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
  void sendTokenServer(String fcmToken)
  {
    print('Token: $fcmToken');
  }
}
