import 'package:flutter/material.dart';
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
//----------------------------------------------------------------------------------------//
class Profile extends StatefulWidget {
  static String tag = 'Profile';
  @override
  _ProfileState createState() => new _ProfileState();
}
//----------------------------------------------------------------------------------------//
class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
//----------------------------------------------------------------------------------------//
class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  static const String Address = '923 N GreenRose,Gwalior';
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String ReciveCount = '';
  String Userid = '';
  final String phone = 'tel:+917000624695';
  final FocusNode myFocusNodeUserName = FocusNode();
  //final FocusNode myFocusNodeUserEmail = FocusNode();
  final FocusNode myFocusNodeUserContact = FocusNode();
  final FocusNode myFocusNodeUserAddress = FocusNode();
  TextEditingController NameController = new TextEditingController();
  //TextEditingController EmailController = new TextEditingController();
  TextEditingController ContactController = new TextEditingController();
  TextEditingController AddressController = new TextEditingController();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool status = false;
  bool _validate = false;

//----------------------------------------------------------------------------------------//
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

//----------------------------------------------------------------------------------------//
  void _showOnTapMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Profile Error'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(myFocusNode);
              Navigator.pop(context);
            },
            child: new Text('OK'))
      ],
      );
    showDialog(context: context, builder: (_) => alert);
  }

//----------------------------------------------------------------------------------------//
  EditProfileData(String Name,String mobile,
      String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    String profile =
        'http://192.168.0.200/anuj/MDN/MDN_APP/ProfileEdit.php?id=' +
            Userid +
            "&Name=" +
            Name +
            "&contact=" +
            mobile +
            "&address=" +
            address;

    print("URL " + profile);

    var res =
    await http.get(profile, headers: {"Accept": "application/json"});

    var data = json.decode(res.body);

    status = data['status'];
    print("status" + status.toString());

    if (status == 1) {
      print("status" + status.toString());
      /*_onWillPopSuccess();
        Navigator.of(context).pushNamed(Login.tag);*/
    }
    setState(() {
      print("Success");
    });
  }

//--------------------------------------------------------------------------------------------------------//
  Future<void> _ackAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Updated ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: Palette.greenLandLight,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Profile Edit Successfully Thanks..',
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color: Palette1.greenLandLight1,
                                                fontWeight: FontWeight.bold),),
              ],
              ),
            ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                //print("hello"+id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(
                          )),
                  );
              },
              child: Text('OK', style: new TextStyle(fontSize: 15.0,
                                                         color: Palette
                                                             .greenLandLight,
                                                         fontWeight: FontWeight
                                                             .bold),),
              )
          ],
          );
      },
      );
  }

//---------------------------------------------------------------------------------------------------//
  getProductCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/forcount.php?UserId=' +
            Userid;
    //print("GetCount " + GetCount);
    var res =
    await http.get(GetCount, headers: {"Accept": "application/json"});
    var dataLogin = json.decode(res.body);
    // print("ReciveData"+dataLogin.toString());
    ReciveCount = dataLogin["count"].toString();
    // print("GetCountFromServer"+ReciveCount);
    setState(() {
      //print("Success");
      //print("GetCountFromServer"+Userid);
    });
  }

//----------------------------------------------------------------------------------------//
  removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    prefs.remove(Preferences.KEY_ROLE);
    prefs.remove(Preferences.KEY_NAME);
    prefs.remove(Preferences.KEY_Contact);
    //prefs.remove(Preferences.KEY_CountProduct);
    Navigator.of(context).pushNamed(Splash.tag);
  }

//----------------------------------------------------------------------------------------//
  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

//----------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double _width = width * 0.70;

//----------------------------------------------------------------------------------------//
    return new WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed(HomePage
                                            .tag); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: new Scaffold(
        //backgroundColor: Palette.greenLandLight,
        drawer: new Drawer(
            elevation: 20.0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    "Mr. " + UserName.toUpperCase(), style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      letterSpacing: 1.4,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.bold),),
                  accountEmail: Text(UserEmail, style: TextStyle(
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
                  title: Text("Home".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
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
                  title: Text("Profile".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
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
                  title: Text("Products".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
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
                  title: Text("categories".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
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
                  title: Text("MyOrder".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
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
                  title: Text("Help".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                  onTap: () => _callPhone(),
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
                  title: Text("Logout".toUpperCase(), style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                  onTap: () {
                    TapMessage(context, "Logout!");
                  },
                  ),
              ],
              )),
//----------------------------------------------------------------------------------------//
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
                  padding: new EdgeInsets.all(15.0),
                  icon: new Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    ),
                  onPressed: () {
                    //print("hello"+id.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TotalAddCartList(
                            value: Userid.toString(),
                            )),
                      );
                  },
                  ),
                new Positioned(
                    child: new Stack(
                      children: <Widget>[
                        new Icon(null),
                        new Positioned(
                            top: 5.0,
                            right: 5,
                            child: new Center(
                              child: new Text(
                                ReciveCount.toString(),
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
        //----------------------------------------------------------------------------------------//
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                    ),
                                ],
                                )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      focusNode: myFocusNodeUserName,
                                      controller: NameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: UserName,
                                        ),
                                      ),
                                    ),
                                ],
                                )),
                          /*Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                    ),
                                ],
                                )),*/
                          /*Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      focusNode: myFocusNodeUserEmail,
                                      controller: EmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        hintText: UserEmail,
                                        ),
                                      ),
                                    ),
                                ],
                                )),*/
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                    ),
                                ],
                                )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      maxLength: 10,
                                      focusNode: myFocusNodeUserContact,
                                      controller: ContactController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: UserContact,
                                        ),
                                      ),
                                    ),
                                ],
                                )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                    ),
                                ],
                                )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      focusNode: myFocusNodeUserAddress,
                                      controller: AddressController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your Address",
                                        ),
                                      ),
                                    ),
                                ],
                                )),
                        ],
                        ),
                      ),
                    )
                ],
                ),
            ],
            ),
          ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  color: Color(0xFF222B78),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(Icons.arrow_back, color: Colors.white,),
                      //`Icon` to display
                      label: Text(
                          "back".toUpperCase(), textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15.0,
                                             color: Colors.white,
                                             fontWeight: FontWeight.bold,)),
                      //`Text` to display
                      onPressed: () {
                        Navigator
                            .of(context)
                            .push(new MaterialPageRoute(builder: (
                            _) => new HomePage()));
                      },
                    ),

                  ),
                flex: 2,
                ),
              Expanded(
                child: Container(
                  height: 50,
                  color: Color(0xFFE0318C),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(Icons.save, color: Colors.white,),
                      //`Icon` to display
                      label: Text('Submit'.toUpperCase(), style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,)),
                      //`Text` to display
                      onPressed: () {
                        EditProfileData(
                            NameController.text,
                            ContactController.text,
                            AddressController.text); //fun1
                        _ackAlert(); //fun2
                      },

                    ),

                  ),
                flex: 3,
                ),
            ],
            ),
          ),
        ),
      );
  }

//----------------------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    this.getProductCount();
    this.fetchData();
  }

//----------------------------------------------------------------------------------------//
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

//----------------------------------------------------------------------------------------//
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
//----------------------------------------------------------------------------------------//