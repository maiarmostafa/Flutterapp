import 'package:flutter/material.dart';
import 'package:courseproject/widget/messagewidget.dart';

class NotficationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xFF2372A3)),
      ),
      body: NotificationWidget(),
    );
  }
}