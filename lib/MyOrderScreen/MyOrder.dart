
import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mdsons/MyOrderScreen/MyOrderDetails.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:mdsons/TotalAddCartList/TotalCheckOut.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/MyOrderScreen/MyOrderModel.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//---------------------------------------------------------------------------------------------------//
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
class Palette2 {
  static Color greenLandLight2 = Color(0xFFE0318C);
}
//---------------------------------------------------------------------------------------------------//
class MyOrder extends StatefulWidget {

  static String tag = 'MyOrder';
  final String value;
  final String value4;
  final String value5;
//---------------------------------------------------------------------------------------------------//
  MyOrder({Key key, this.value, this.value4, this.value5}) : super(key: key);
  @override
  _MyOrderList createState() => new _MyOrderList();
}
//---------------------------------------------------------------------------------------------------//
class _MyOrderList extends State<MyOrder> {
  List data;
  List data1;
  String categoryid;
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String CountProduct = '';
  String Userid = '';
  String ReciveCount = '';
  String ReciveTotalPrice = '';
  String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
  final String phone = 'tel:+917000624695';
  String GlobalProductId  = '';
  String CardItemId  = '';
  bool statusProductDeleted = false;
  int statusProductAddItem = 0;
  bool statusProductRemoveItem = false;
  String ProfileName="" ;
  String ProfileData = '';
  String ProfileMobile;
  String ProfileAddress = '';
  String ProfileStatus = '';
  String ProfileUserType = '';
  String ProfileEmail = '';
  String OrderID  = '';
//---------------------------------------------------------------------------------------------------//
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
    String Url ='http://gravitinfosystems.com/MDNS/MDN_APP/MyOrder.php?UserId='+Userid;
    print("CartProductListUrl"+Url);;
    final response =
    await http.get(Url);
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
    }
  }
//---------------------------------------------------------------------------------------------------//
  getProductCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/forcount.php?UserId='+Userid;
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
//-----------------------------------------------------------------------------------------------------//
  getTotalPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/TotalamountCart.php?id='+Userid;
    //print("GetCount " + GetCount);
    var res =
    await http.get(GetCount, headers: {"Accept": "application/json"});
    var dataPrice = json.decode(res.body);
    // print("ReciveData"+dataLogin.toString());
    ReciveTotalPrice = dataPrice["TOTAL"].toString();
    print("GetCountFromServer"+ReciveTotalPrice);
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
  @override
  void initState() {
     this.getProductCount();
    this.fetchData();
    this.getTotalPrice();
   this.ProfileDisplay();
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(HomePage.tag);
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
  int _id;
//---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    double height = MediaQuery.of(context).size.height;
    double _height = height * 0.85;
    final listJson =  new Container(
      child: Column(
        children: <Widget>[
          new Container(),
          loading
              ? Center(
            child: CircularProgressIndicator(),
            )
              : Expanded(
            child: ListView.builder(

              padding: const EdgeInsets.all(4.0),
              //crossAxisSpacing: 10,
              itemCount: _list.length,
              itemBuilder: (context, i) {
                categoryid = data[i]["categoryid"];
                final a = _list[i];
                OrderID = a.OrderId.toString();
                //print("OrderID"+OrderID);
                return new Container(
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        _id = int.parse(data[i][
                                        "OrderId"]); //if you want to assign the index somewhere to check
                        // print("categoryid"+_id.toString());
                      });
                      print("OrderID"+_id.toString());
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new MyOrderDetails(
                            value: _id.toString(),
                            value1: " ${ widget.value }",
                           // value2: a.productName.toString(),
                            ),

                        );
                      Navigator.of(context).push(route);
                    },
                    child: new Card(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                           /* leading: Image.asset(
                              'assets/images/AllCategory.png',
                              height: 250.0,
                              width: 50.0,
                              ),*/

                            title: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 5.0,
                                        ),
                                      new Text(
                                        /*"${widget.itemRating}",*/
                                        "OrderID "+ a.OrderId.toString().toUpperCase(),
                                          style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,color: Palette1.greenLandLight1,),
                                        ),

                                    ],
                                    ),
                                  new SizedBox(
                                    height: 5.0,
                                    ),

                                ]),

                           trailing: Icon(Icons.keyboard_arrow_right,color: Palette1.greenLandLight1,),


                            subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new SizedBox(
                                    height: 5.0,
                                    ),
                                  new Text(
                                    /*"${widget.itemRating}",*/
                                   "OrderDate "+ a.OrderDate.toString().toUpperCase(),
                                      style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,color: Palette1.greenLandLight1,),
                                    ),

                                ],
                                ),
                              new SizedBox(
                                height: 10.0,
                                ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.rupeeSign, color: Palette1.greenLandLight1,
                                         size: 15.0,),
                                  new Text(
                                    /*"${widget.itemRating}",*/
                                    a.Amount.toString().toUpperCase(),
                                      style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,color: Palette1.greenLandLight1,),
                                    ),

                                ],
                                ),
                            ]),
                            ),
                        ],
                        ),
                      ),
                    ),

                  );
              },
              ),
            ),
        ],
        ),
      );
//---------------------------------------------------------------------------------------------------//
    return new WillPopScope(
      onWillPop: BackScreen,
      child: Scaffold(
        drawer: _drawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          title: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              color: Colors.transparent,
              child: Text('My order List'.toUpperCase()),
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
        backgroundColor: Colors.white,
        body: listJson,
    /*    bottomNavigationBar: BottomAppBar(
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
                    icon: Icon(FontAwesomeIcons.rupeeSign,color: Colors.white,), //`Icon` to display
                      label: Text(ReciveTotalPrice.toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                    *//*onPressed: () {
                        Navigator
                            .of(context)
                            .push(new MaterialPageRoute(builder: (_) => new Product()));
                      },*//*
                    ),

                  ),
                flex: 2,
                ),
              Expanded(
                child: Container(
                  height: 50,
                  color:Color(0xFFE0318C),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon( FontAwesomeIcons.shoppingCart,
                                  size: 18,
                                  color: Colors.white,), //`Icon` to display
                      label: Text('continue'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new TotalCheckOut(
                            value7: ReciveTotalPrice.toString(),
                            value8: CardItemId.toString(),),
                          );
                        Navigator.of(context).push(route);
                      },
                    ),

                  ),
                flex: 3,
                ),
            ],
            ),
          ),*/),
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
              /*currentAccountPicture:
              CircleAvatar(
                backgroundImage: ExactAssetImage('assets/images/aa.jpg'),
                minRadius: 90,
                maxRadius: 100,
                ),*/
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