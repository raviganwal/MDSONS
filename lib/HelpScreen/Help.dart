import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  static String tag = 'Help';
  final String phone = 'tel:+917000624695';

  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Care '.toUpperCase()),
      centerTitle: true,),
      body: Center(
          child: RaisedButton(
            onPressed: _callPhone,
            child: Text('Call now'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)),
              color:Color(0xFF222B78),
          )),
    );
  }
}