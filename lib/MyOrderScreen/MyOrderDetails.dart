import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/MyOrderScreen/MyOrder.dart';
import 'package:mdsons/ProductScreen/ProductTotalCardList.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/MyOrderScreen/OrderDetailsModel.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//---------------------------------------------------------------------------------------------------//
class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
//---------------------------------------------------------------------------------------------------//
class MyOrderDetails extends StatefulWidget {
  static String tag = 'MyOrderDetails';
//---------------------------------------------------------------------------------------------------//
  List data;
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  final String value;
  final String value1;
  final String value2;
//---------------------------------------------------------------------------------------------------//
  MyOrderDetails({Key key, this.value, this.value1,this.value2}) : super(key: key);
//---------------------------------------------------------------------------------------------------//
  @override
  _MyOrderDetails createState() => new _MyOrderDetails();
}
//---------------------------------------------------------------------------------------------------//
class _MyOrderDetails extends State<MyOrderDetails> {
  String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
  List data;
  List data1;
  List<Posts> _list = [];
  var loading = false;
  List<Posts> _list1 = [];
  var loading1 = false;
  String id;
  String StoreProductId= "";
  String NumberOfCount = "";
  String RecivedCount = "";
  String RecivedMessage = "";
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String ReciveCountNumber = '';
  String URl = '';
  String Userid = '';
  final String phone = 'tel:+917000624695';
  String ProfileName="" ;
  String ProfileData = '';
  String ProfileMobile;
  String ProfileAddress = '';
  String ProfileStatus = '';
  String ProfileUserType = '';
  String ProfileEmail = '';
//---------------------------------------------------------------------------------------------------//
  // ignore: missing_return
  // ignore: missing_return
  // ignore: missing_return
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    // CountProduct = prefs.getString(Preferences.KEY_CountProduct).toString();
    setState(() {
      loading = true;
    });
    _list.clear();
    String Url ='http://gravitinfosystems.com/MDNS/MDN_APP/OrderDetail.php?OrderId='+widget.value.toString();
    print("CartProductListUrl"+Url);;
    final response =
    await http.get(Url);
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data = extractdata["data"]["Order_MasterDetail"];
     // data = extractdata["data"]["OrderList"];
      print("data"+data.toString());
      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i));
          loading = false;
        }
      });
    }
  }

//---------------------------------------------------------------------------------------------------//
  //---------------------------------------------------------------------------------------------------//
  // ignore: missing_return
  // ignore: missing_return
  // ignore: missing_return
  Future<Null> fetchDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    // CountProduct = prefs.getString(Preferences.KEY_CountProduct).toString();
    setState(() {
      loading1 = true;
    });
    _list1.clear();
    String Url ='http://gravitinfosystems.com/MDNS/MDN_APP/OrderDetail.php?OrderId='+widget.value.toString();
    print("CartProductListUrl"+Url);;
    final response =
    await http.get(Url);
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data1 = extractdata["data"]["OrderList"];
      print("data"+data1.toString());
      setState(() {
        for (Map i in data1) {
          _list1.add(Posts.formJson(i));
          loading1 = false;
        }
      });
    }
  }

//---------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------//
  getProductCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/forcount.php?UserId='+Userid;
    var res =
    await http.get(GetCount, headers: {"Accept": "application/json"});
    var dataLogin = json.decode(res.body);
    // print("ReciveData"+dataLogin.toString());
    RecivedCount = dataLogin["count"].toString();
    // print("GetCountFromServer"+ReciveCount);
    setState(() {
      //print("Success");
      //print("GetCountFromServer"+Userid);
    });
  }
//------------------------------------------------------------------------------------------------//
  Future<String> ProfileDisplay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();

    String url = 'http://gravitinfosystems.com/MDNS/MDN_APP/ProfileDisplay.php?id='+Userid;
    //print("url"+url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      ProfileData = extractdata["data"].toString();
      //print("ProfileData"+ProfileData.toString());
      ProfileName = extractdata["data"]["Name"].toString();
      ProfileMobile = extractdata["data"]["contact"].toString();
      ProfileAddress = extractdata["data"]["address"].toString();
      ProfileEmail = extractdata["data"]["Email"].toString();
      //print("ProfileName"+ProfileName.toString());
      //print("ProfileMobile"+ProfileMobile.toString());
      // print("ProfileAddress"+ProfileAddress.toString());
    });
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(Product.tag);
  }
//---------------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.fetchData();
    this.getProductCount();
    this.fetchDataList();
    this.ProfileDisplay();
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
//---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    double height = MediaQuery.of(context).size.height;
    double _height = height * 0.85;

    final listJson =   new ListView.builder(
        shrinkWrap: true,
        reverse: true,
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          final a = _list[i];
          return new Container(
            child: new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new GestureDetector(
                onTap: () {
//                  examname.text = data[i]["name"];
//                  examnote.text = data[i]["note"];
//                  FocusScope.of(context).requestFocus(focusNode);
                },
                child: new Card(
                  elevation: 2.0,
                  key: null,
                  child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: new Row(children: <Widget>[
                            new Container(
                              child: new Text(
                                "OrderNo:",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold,),
                                ),
                              height: 40.0,
                              margin: new EdgeInsets.only(left: 10.0),
                              ),
                            new Container(
                              child: new Text(
                                a.OrderId,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Palette1.greenLandLight1),
                                ),
                              height: 40.0,
                              margin: new EdgeInsets.only(left: 80.0),
                              ),
                          ]),
                          ),
                        new Row(children: <Widget>[
                          new Container(
                            child: new Text(
                              "OrderDate:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 10.0),
                            ),
                          new Container(
                            child: new Text(
                              a.OrderDate,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 65.0),
                            ),
                        ]),
                        new Row(children: <Widget>[
                          new Container(
                            child: new Text(
                              "CustomerName:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 10.0),
                            ),
                          new Container(
                            child: new Text(
                              a.customer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color:Palette1.greenLandLight1),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 25.0),
                            ),
                        ]),
                        new Row(children: <Widget>[
                          new Container(
                            child: new Text(
                              "Total Amount:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 10.0),
                            ),
                          new Container(
                            child: new Text(
                              a.Amount,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 40.0),
                            ),
                        ]),
                        new Row(children: <Widget>[
                          new Container(
                            child: new Text(
                              "Payment Status:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 10.0),
                            ),
                          new Container(
                            child: new Text(
                              "Pendding",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 20.0),
                            ),
                        ]),
                        new Row(children: <Widget>[
                          new Container(
                            child: new Text(
                              "Order Status:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 10.0),
                            ),
                          new Container(
                            child: new Text(
                              a.order_status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette1.greenLandLight1),
                              ),
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 45.0),
                            ),
                        ]),
                      ]),
                  ),
                ),
              ),
            );
        });
    final listJson2 =  new ListView.builder(
        shrinkWrap: true,
        reverse: true,
        itemCount: data1 == null ? 0 : data1.length,
        itemBuilder: (BuildContext context, i) {
          final a = _list1[i];
          return new Container(
            //color: Colors.black,
            child: new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new GestureDetector(
                onTap: () {
//                  examname.text = data[i]["name"];
//                  examnote.text = data[i]["note"];
//                  FocusScope.of(context).requestFocus(focusNode);
                },
                child: new Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                    color:Palette.greenLandLight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(a.productName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white)),
                            SizedBox(height: 4),
                            Text("Qty  "+a.Qty, style: TextStyle(color: Colors.white70)),
                            new SizedBox(
                              height: 5.0,
                              ),
                            Text("Rate  "+a.Rate, style: TextStyle(color: Colors.white70)),
                            new SizedBox(
                              height: 5.0,
                              ),
                            Text("Amount  "+a.amount, style: TextStyle(color: Colors.white70)),
                          ],
                          ),
                        Spacer(),
                        /*CircleAvatar(backgroundColor: Colors.white),*/
                      ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        });

//---------------------------------------------------------------------------------------------------//
    return Scaffold(
      drawer: _drawer(),
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Padding(
          padding: const EdgeInsets.all(0.0),
          child: new Container(
            color: Colors.transparent,
            child: Text(
                "Order Details".toUpperCase()),
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
                /*onPressed: () {
                    //print("hello"+id.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TotalAddCartList(
                            value: id.toString(),
                            )),
                      );
                  },*/
                ),
              new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      new Icon(null),
                      new Positioned(
                          top: 5.0,
                          right: 3,
                          child: new Center(
                            child: new Text(
                              RecivedCount.toString(),
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                              ),
                            )),
                    ],
                    )
                  ),
            ],
            ),
        ],
        ),
//---------------------------------------------------------------------------------------------------//
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Container(
            height: _height,
            child: new ListView(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              controller: _scrollController,
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 15.0),
                listJson,
                SizedBox(height: 5.0),
                listJson2
              ],
              ),
            ),
          // new FlutterLogo(size: 100.0, colors: Colors.orange),
        ],
        ),
      );
  }
//---------------------------------------------------------------------------------------------------//
  Widget _drawer() {
    return new Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Mr. "+ProfileName.toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text(ProfileEmail,style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
             /* currentAccountPicture:
              CircleAvatar(
                backgroundImage: ExactAssetImage('assets/images/aa.jpg'),
                minRadius: 90,
                maxRadius: 100,
                ),*/
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
                Navigator.of(context).pushNamed(MyOrder.tag);
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
//---------------------------------------------------------------------------------------------------//

