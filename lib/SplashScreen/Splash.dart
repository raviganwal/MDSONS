import 'dart:async';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/LoginScreen/Login.dart';
import 'package:flutter/material.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}

class Splash extends StatefulWidget {
  static String tag = 'Splash';

  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with SingleTickerProviderStateMixin {

  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  void handleTimeout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(Preferences.KEY_ID) != null) {
      if (prefs.getString(Preferences.KEY_ROLE) == 'Individual') {
        Navigator.of(context).pushNamed(HomePage.tag);
      }
      if (prefs.getString(Preferences.KEY_ROLE) == "Individual") {
        Navigator.of(context).pushNamed(HomePage.tag);
      }
    } else {
      Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (_) => new Login()));
    }
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimeout();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 4),
    );

    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFFFFFFF),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: new Text(
                  'Copyright © 2019 MD&SONS',style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600,color: Palette.greenLandLight),
                ),
              )
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
