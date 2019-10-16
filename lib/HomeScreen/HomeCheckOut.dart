import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/HomeScreen/HomeTotalAddList.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
//------------------------------------------------------------------------------------------//
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
class Palette2 {
  static Color greenLandLight2 = Color(0xFFE0318C);
}
//-------------------------------------------------------------------------------------------//
class HomeCheckOut extends StatefulWidget {
  static String tag = 'HomeCheckOut';
  HomeCheckOut({Key key, this.title, this. value5, this.value6}) : super(key: key);
  final String title;
  final String value5;
  final String value6;
  @override
  _HomeCheckOutState createState() => new _HomeCheckOutState();
}
//-------------------------------------------------------------------------------------------//
class _HomeCheckOutState extends State<HomeCheckOut> {
  File _image;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String Userid = '';
  final String phone = 'tel:+917000624695';
  String id;
  bool statusDataSend = false;
  String ReciveCount = '';
//-------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.fetchData();
    this.getProductCount();
    super.initState();
  }
//-------------------------------------------------------------------------------------------//
  @override
  void dispose() {
    super.dispose();
  }
//-------------------------------------------------------------------------------------------//
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
  }
//-------------------------------------------------------------------------------------------//
  Future getImageFromCam() async { // for camera
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print("getImageFromCam"+_image.toString());
    });
  }
//-------------------------------------------------------------------------------------------//
  Future getImageFromGallery() async {// for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("getImageFromGallery"+_image.toString());
    });
  }
//---------------------------------------------------------------------------------------------------//
  // ignore: missing_return
  Future<String> SenddataRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString(Preferences.KEY_ID).toString();
    String url = 'http://gravitinfosystems.com/MDNS/MDN_APP/Cart.php?UserId='+id+'&ProductId='+widget.value5.toString()+'&ProductId='+widget.value5.toString();
    // print("url"+url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      var extractdata = json.decode(response.body);
      statusDataSend = extractdata['status'];
      print("status" + statusDataSend.toString());
      setState(() {
        print("Success");
      });
    });
  }
//---------------------------------------------------------------------------------------------------//
  getProductCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetProductCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/forcount.php?UserId='+Userid;
    //print("GetCount " + GetCount);
    var res =
    await http.get(GetProductCount, headers: {"Accept": "application/json"});
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
  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeTotalAddList(
            value: Userid.toString(),
            )),
      );
  }
//-------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: BackScreen,
      child: new  Scaffold(
        drawer: _drawer(),
        appBar: AppBar(
          title: Text('Upload CheckOut Picture'),
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
                          builder: (context) => HomeTotalAddList(
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
        body: ListView(
          children: [
           /* new SizedBox(
              height: 2.0,
              ),*/
            new Card(
              child: new Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                /* width: screenSize.width,*/
              //  margin: new EdgeInsets.all(20.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        //height: 1.0,
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Text(
                                    /*"${widget.itemRating}",*/
                                    "total amount   ".toUpperCase(),
                                      style: new TextStyle(fontSize: 12.0, color: Colors.black,fontWeight: FontWeight.bold),
                                    ),
                                  Icon(FontAwesomeIcons.rupeeSign,color: Colors.black,size: 15.0,),
                                  new Text(
                                    /*"${widget.itemRating}",*/
                                    widget.value5.toString().toUpperCase(),
                                      style: new TextStyle(fontSize: 12.0, color: Colors.black,fontWeight: FontWeight.bold),
                                    ),

                                ],
                                ),
                            ],
                            ),

                        ],
                        ),
                    ],
                    ),
                ),
              ),
            new SizedBox(
              height: 10.0,
              ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              height: 200.0,
                child: Center(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                  ),
              ),
            new SizedBox(
              height: 10.0,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  color:Color(0xFFE0318C),
                  icon: Icon(FontAwesomeIcons.camera,color: Colors.white,), //`Icon` to display
                    label: Text("Camera".toUpperCase().toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                    onPressed: getImageFromCam,
                  ),

                FlatButton.icon(
                  color:Color(0xFFE0318C),
                  icon: Icon( FontAwesomeIcons.cameraRetro,
                                size: 18,
                                color: Colors.white,), //`Icon` to display
                    label: Text('gallery'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                    onPressed: getImageFromGallery,
                  ),
              ],
              ),
          ],
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
                  color:Color(0xFF222B78),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(FontAwesomeIcons.paperPlane,color: Colors.white,), //`Icon` to display
                      label: Text("send".toUpperCase().toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                          SenddataRequest();
                        //print("hello");
                        // model.removeProduct(model.cart[index]);
                      },
                    ),

                  ),
                flex: 1,
                ),
              /*Expanded(
                child: Container(
                  height: 50,
                  color:Color(0xFFE0318C),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon( FontAwesomeIcons.cameraRetro,
                                  size: 18,
                                  color: Colors.white,), //`Icon` to display
                      label: Text('gallery'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: getImageFromGallery,
                    ),

                  ),
                flex: 3,
                ),*/
            ],
            ),
          ),
        ),
      );
  }
  Widget _drawer() {
    return new Drawer(
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
              decoration: BoxDecoration(color: Palette2.greenLandLight2),
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
                //Navigator.of(context).pushNamed(CartProductList.tag);
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
              title: Text("Logout".toUpperCase(),style: TextStyle( fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w500),),
              onTap: () {
                TapMessage(context, "Logout!");
              },
              ),
          ],
          ));
  }
  //---------------------------------------------------------------------------------------------------//
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
//---------------------------------------------------------------------------------------------------//
  removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    prefs.remove(Preferences.KEY_ROLE);
    prefs.remove(Preferences.KEY_NAME);
    prefs.remove(Preferences.KEY_Email);
    prefs.remove(Preferences.KEY_Contact);
    Navigator.of(context).pushNamed(Splash.tag);
  }
}
//-------------------------------------------------------------------------------------------//