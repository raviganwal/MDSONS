import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/CategoryScreen/CategoryTotalAddList.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/Model.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
//--------------------------------------------------------------------------------------------------------//
class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
//--------------------------------------------------------------------------------------------------------//
class ProductGridViewDetails extends StatefulWidget {
  static String tag = 'ProductGridViewDetails';
  final String value;
  final String value1;
  final String value2;
  ProductGridViewDetails({Key key, this.value, this.value1, this.value2}) : super(key: key);
  @override
  _MonthSelection createState() => new _MonthSelection();
}
//--------------------------------------------------------------------------------------------------------//
class _MonthSelection extends State<ProductGridViewDetails> {
  String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
  List data;
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  String id;
  String StoreProductId= "";
  String NumberOfCount = "";
  String RecivedCount = "";
  String RecivedMessage = "";
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  final String phone = 'tel:+917000624695';
//--------------------------------------------------------------------------------------------------------//
  // ignore: missing_return
  Future<Null> makeRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    id = prefs.getString(Preferences.KEY_ID).toString();
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
    await http.get('http://gravitinfosystems.com/MDNS/MDN_APP/singleproduct.php?product_id='+widget.value.toString());
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data = extractdata["data"];
      // print("akash"+data.toString());
      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i));
          loading = false;
        }
      });
    }
  }
//--------------------------------------------------------------------------------------------------------//
  // ignore: missing_return
  Future<String> GetCountRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString(Preferences.KEY_ID).toString();
    String url = 'http://gravitinfosystems.com/MDNS/MDN_APP/Cart.php?UserId='+id+'&ProductId='+StoreProductId;
    //print("url"+url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      var extractdata = json.decode(response.body);
      NumberOfCount = extractdata.toString();
      //print("recivedata"+NumberOfCount);
      RecivedCount = extractdata["count"].toString();
      //print("count"+RecivedCount);

      RecivedMessage = extractdata["count"].toString();
      //print("RecivedMessage"+RecivedMessage);
    });
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _ackAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Add Message',textAlign: TextAlign.center,style: new TextStyle(fontSize: 15.0, color: Palette.greenLandLight,fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product Add Successfully Thanks..',textAlign: TextAlign.center,style: new TextStyle(fontSize: 12.0, color: Palette1.greenLandLight1,fontWeight: FontWeight.bold),),
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
                      builder: (context) => CategoryTotalAddList(
                        value: id.toString(),
                        )),
                  );
              },
              child: Text('OK',style: new TextStyle(fontSize: 15.0, color: Palette.greenLandLight,fontWeight: FontWeight.bold),),
              )
          ],
          );
      },
      );
  }
//-------------------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(CategoryScreenList.tag);
  }
//---------------------------------------------------------------------------------------------------//
  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.makeRequest();
  }
//--------------------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    double height = MediaQuery.of(context).size.height;
    double _height = height * 0.85;
    final listJson = new Container(
      child: Column(
        children: <Widget>[
          new Container(),
          loading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              //crossAxisSpacing: 10,
              itemCount: _list.length,
              itemBuilder: (context, i) {
                final a = _list[i];
                StoreProductId= a.userId;
                //print("StoreProductId"+StoreProductId);
                return new Container(
                  child: new Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      new SingleChildScrollView(
                        child: new Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.network(imageurl+a.image,
                                                     fit: BoxFit.contain,
                                                   ),
                              ),
                            new Card(
                              child: new Container(
                                /* width: screenSize.width,*/
                                margin: new EdgeInsets.all(10.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new SizedBox(
                                      //height: 1.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                new Text(
                                                  /*"${widget.itemRating}",*/
                                                  a.categoryname.toUpperCase(),
                                                  style: new TextStyle(fontSize: 13.0, color: Colors.black,fontWeight: FontWeight.bold),
                                                ),
                                                new Text(
                                                  /*"${widget.itemRating}",*/
                                                  " > "+a.subcategoryname.toUpperCase(),
                                                  style: new TextStyle(fontSize: 13.0, color: Colors.black,fontWeight: FontWeight.bold),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                        new Text(
                                          a.title.toUpperCase(),textAlign: TextAlign.left,
                                          style:
                                          TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300),
                                        ),
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                new Text(
                                                  /*"${widget.itemRating}",*/
                                                  "Rs."+a.mrp,
                                                  style: new TextStyle(fontSize: 13.0, color: Colors.grey,decoration: TextDecoration.lineThrough,),
                                                ),
                                                new Text(
                                                  /*"${widget.itemRating}",*/
                                                  " Rs."+a.body,
                                                  style: new TextStyle(fontSize: 13.0, color: Colors.black,fontWeight: FontWeight.bold),
                                                ),

                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  child: new CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: Image.asset('assets/images/discount.png'),
                                                  ),
                                                  margin: const EdgeInsets.all(2.0),
                                                  width: 15.0,
                                                  height: 15.0,
                                                ),
                                                Container(
                                                  child: new Text(a.Discount,style: TextStyle(fontSize: 13.0, color: Colors.red,fontWeight: FontWeight.bold),),
                                                  margin: const EdgeInsets.all(0.0),
                                                  width: 15.0,
                                                  height: 15.0,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),

                                      ],
                                    ),

                                    new SizedBox(
                                      //height: 2.0,
                                    ),

                                    /* new SizedBox(
                        height: 0.0,
                      ),*/
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            new Text(
                                              /*"${widget.itemRating}",*/
                                              a.productnumber.toUpperCase(),
                                              style: new TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.all(0),
                              //height: 120,
                              child: Card(
                                //color: Colors.grey,
                                child: new Column(
                                  children: <Widget>[
                                    new ListTile(
                                      title: new Text(
                                        "Description  ",textAlign: TextAlign.start,
                                        style: new TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new SizedBox(
                                              //height: 1.0,
                                            ),
                                            new Text(a.description.toUpperCase(),
                                                style: new TextStyle(
                                                    fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300)),
                                            /* new Text('Price: ${data["Price"]}',
                                style: new TextStyle(
                                    fontSize: 11.0, fontWeight: FontWeight.normal,color: Palette.greenLandLight)),*/
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.all(0),
                              //height: 120,
                              child: Card(
                                //color: Colors.grey,
                                child: new Column(
                                  children: <Widget>[
                                    new ListTile(
                                      title: new Text(
                                        "How To Use  ",textAlign: TextAlign.start,
                                        style: new TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new SizedBox(
                                              height: 1.0,
                                            ),
                                            new Text(a.howtouse.toUpperCase(),
                                                style: new TextStyle(
                                                    fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300)),
                                            /* new Text('Price: ${data["Price"]}',
                                style: new TextStyle(
                                    fontSize: 11.0, fontWeight: FontWeight.normal,color: Palette.greenLandLight)),*/
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),

                );
              },
            ),
          ),
        ],
      ),
    );
//--------------------------------------------------------------------------------------------------------//
    return new WillPopScope(
        onWillPop: BackScreen,
    child: Scaffold(
      drawer: _drawer(),
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Padding(
          padding: const EdgeInsets.all(0.0),
          child: new Container(
            color: Colors.transparent,
            child: Text(
                widget.value2.toString().toUpperCase()),
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
                          right: 5,
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
                  )),
            ],
          ),

        ],
      ),
      backgroundColor: Colors.white,
//--------------------------------------------------------------------------------------------------------//
      body: listJson,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50,
                color:Color(0xFF222B78),
                child: new FlatButton.icon(
                  //color: Colors.red,
                  icon: Icon(Icons.arrow_back,color: Colors.white,), //`Icon` to display
                  label: Text('back'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                  onPressed: () {
                    Navigator
                        .of(context)
                        .push(new MaterialPageRoute(builder: (_) => new Product()));
                  },
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
                  icon: Icon(Icons.add_shopping_cart,color: Colors.white,), //`Icon` to display
                  label: Text('add to cart'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                  onPressed: () {
                    GetCountRequest(); //fun1
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
//--------------------------------------------------------------------------------------------------------//
