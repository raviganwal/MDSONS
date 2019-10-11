import 'package:flutter/material.dart';
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/HelpScreen/Help.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/Product.dart';

class Profile extends StatefulWidget {
  static String tag = 'Profile';

  @override
  _ProfileState createState() => new _ProfileState();
}

class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}

class _ProfileState extends State<Profile> {

  static const String Address = '923 N GreenRose Drive Beloit,Gwalior';
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String CountProduct = '';

  // ignore: missing_return
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
  //  CountProduct = prefs.getString(Preferences.KEY_CountProduct).toString();
    //print("UserEmail"+UserEmail);
    //print("UserContact"+UserContact);
    // print("KEY_CountProduct"+CountProduct);
  /*  setState(() {
      loading = true;
    });
    _list.clear();
    final response =
    await http.get("http://gravitinfosystems.com/MDNS/MDN_APP/MaxDiscountProduct.php");
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data = extractdata["data"];
      print("data"+data.toString());
      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i));
          loading = false;
        }
      });
    }*/
  }
  removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    prefs.remove(Preferences.KEY_ROLE);
    prefs.remove(Preferences.KEY_NAME);
    prefs.remove(Preferences.KEY_Contact);
    //prefs.remove(Preferences.KEY_CountProduct);
    Navigator.of(context).pushNamed(Splash.tag);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    final ProfileImage = new Padding(
      padding: EdgeInsets.all(0.0),
      child: new Container(
        height: 250.0,
        color: Palette.greenLandLight,
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Stack(fit: StackFit.loose, children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: new ExactAssetImage(
                                'assets/images/aa.jpg'),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top:150.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Mr. "+UserName.toUpperCase(),
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.white,letterSpacing: 1.4, backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top:180.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "+91"+UserContact,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.white,letterSpacing: 1.4, backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ]),
            )
          ],
        ),
      ),
    );
    final AddsEmaillDob = new Padding(
        padding: EdgeInsets.all(0.0),
        child:   new Container(
          color: Palette.greenLandLight,
          child: Padding(
            padding: EdgeInsets.only(top:0.0),
              key: null,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Row(children: <Widget>[
                        new Container(
                          child: new Text(
                            "Address :".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.white,backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                          ),
                          margin: new EdgeInsets.only(left: 15.0),
                        ),
                        new Container(
                          child: new Text(
                            Address,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.white, backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                          ),
                          margin: new EdgeInsets.only(left: 5.0),
                        ),
                      ]),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    new Row(children: <Widget>[
                      new Container(
                        child: new Text(
                          "Date Of Birth :".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.white,backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                        ),
                        margin: new EdgeInsets.only(left: 15.0),
                      ),
                      new Container(
                        child: new Text(
                          "22/06/1989",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.white, backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                        ),
                        margin: new EdgeInsets.only(left: 5.0),
                      ),
                    ]),
                    new Padding(
                      padding: const EdgeInsets.only(bottom:10.0),
                    ),
                    new Row(children: <Widget>[
                      new Container(
                        child: new Text(
                          "Email:".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.white,backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                        ),
                        margin: new EdgeInsets.only(left: 15.0),
                      ),
                      new Container(
                        child: new Text(
                          "hr.gravitinfosystem.com",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.white, backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                        ),
                        margin: new EdgeInsets.only(left:5.0),
                      ),
                    ]),
                    new Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                    ),
                  ]),
          ),
        )
    );
    final PasswordChange = new Padding(
        padding: EdgeInsets.all(0.0),
        child:   new Container(
          color: Palette.greenLandLight,
          child: Padding(
            padding: EdgeInsets.only(top:0.0),
              key: null,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: new Row(children: <Widget>[
                        new Container(
                          child: FlatButton.icon(
                            icon: Icon(Icons.lock,color: Colors.white,), //`Icon` to display
                            label: Text('Password Change'.toUpperCase(),style: TextStyle(fontSize: 18.0,color: Colors.white,backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),),
                            //`Text` to display
                            onPressed: () {
                              //Code to execute when Floating Action Button is clicked
                              //...
                            },
                          ),
                          margin: new EdgeInsets.only(left: 0.0),
                        ),
                      ]),
                    ),

                  ]),
          ),
        )
    );
    return new WillPopScope(
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: new Scaffold(
        //backgroundColor: Palette.greenLandLight,
        drawer: new Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Mr. "+UserName.toUpperCase(),style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    letterSpacing: 1.4,
                    backgroundColor: Colors.transparent,
                    fontWeight: FontWeight.bold),),
                accountEmail: Text(UserEmail,style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    letterSpacing: 1.4,
                    backgroundColor: Colors.transparent,
                    fontWeight: FontWeight.bold),),
                currentAccountPicture:
                CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/images/aa.jpg'),
                  minRadius: 90,
                  maxRadius: 100,
                ),
                decoration: BoxDecoration(color: Palette.greenLandLight),
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/home.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("Home".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.of(context).pushNamed(HomePage.tag);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/profile.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("Profile".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.of(context).pushNamed(Profile.tag);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/Product.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("Products".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.of(context).pushNamed(Product.tag);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/cate.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("categories".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.of(context).pushNamed(CategoryScreenList.tag);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/contactus.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("MyOrder".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
                  // Navigator.of(context).pushNamed(CategoryScreenList.tag);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/helpdesk.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("Help".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
               Navigator.of(context).pushNamed(Help.tag);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: new Image.asset(
                  'assets/images/exit.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                title: Text("Logout".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
                onTap: () {
                  TapMessage(context, "Logout!");
                },
              ),
            ],
          )),

        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              color: Colors.transparent,
              child: Text('my profile'.toUpperCase()),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            new Stack(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {

                  },
                ),
                new Positioned(
                    child: new Stack(
                      children: <Widget>[
                        new Icon(Icons.brightness_1,
                            size: 20.0, color: Colors.grey),
                        new Positioned(
                            top: 4.0,
                            right: 4,
                            child: new Center(
                              child: new Text(
                                '10',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ],
                    )),
              ],
            ),

          ],
        ),
        body: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            ProfileImage,
            AddsEmaillDob,
            PasswordChange
          ],
        ),
      ),
    );

  }
  //notifications..
  @override
  void initState() {
    super.initState();
    this.fetchData();
  }
  void TapMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Want to logout?'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              removeData();
            },
            child: new Text('OK'))
      ],
    );
    showDialog(context: context, child: alert);
  }
}
