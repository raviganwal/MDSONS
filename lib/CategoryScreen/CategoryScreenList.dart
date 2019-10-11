import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/HelpScreen/Help.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/CategoryScreen/SubCategoryList.dart';
import 'package:mdsons/CategoryScreen/CategoryModel.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
class Palette {
  static Color greenLandLight = Color(0xFF6B0129);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
class Palette2 {
  static Color greenLandLight2 = Color(0xFFE0318C);
}
class CategoryScreenList extends StatefulWidget {
  static String tag = 'CategoryScreenList';
  final String value;

  CategoryScreenList({Key key, this.value}) : super(key: key);

  @override
  _NextPage createState() => new _NextPage();
}

class _NextPage extends State<CategoryScreenList> {
  List data;
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
    final response =
    await http.get("http://gravitinfosystems.com/MDNS/MDN_APP/Category.php");
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data = extractdata["data"];
     // print("data"+data.toString());
      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i));
          loading = false;
        }
      });

    }
  }

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

  @override
  void initState() {
    this.getProductCount();
    this.fetchData();
  }
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(HomePage.tag);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _id;

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
                return new Container(
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        _id = int.parse(data[i][
                        "categoryid"]); //if you want to assign the index somewhere to check
                        print("categoryid"+_id.toString());
                      });
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new SubCategoryList(
                            value: _id.toString(),
                            value1: " ${ widget.value }"),
                      );
                      Navigator.of(context).push(route);
                    },
                    child: new Card(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: Image.asset(
                              'assets/images/AllCategory.png',
                              height: 250.0,
                              width: 50.0,
                            ),

                            title: new Text(
                              a.title.toUpperCase(),textAlign: TextAlign.start,
                              style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Palette.greenLandLight),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,color: Palette.greenLandLight,),
                            /*subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('categoryid: '+categoryid,
                                  style: new TextStyle(
                                      fontSize: 13.0, fontWeight: FontWeight.normal,color: Palette.greenLandLight)),
                            ]),*/
                          )
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
              child: Text('Category'.toUpperCase()),
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
                  onPressed: null,
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
        body: listJson,),
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
        ));
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
