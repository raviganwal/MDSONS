import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/DetailsOrAddToCart.dart';
import 'package:mdsons/ProductScreen/Model.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';

void main() => runApp(new Product());
class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}

class Product extends StatefulWidget {
  // This widget is the root of your application.
  static String tag = 'Product';
  final String value;
  Product({Key key, this.value}) : super(key: key);

//---------------------------------------------------------------------------------------------------//
  @override
  _ProductState createState() => _ProductState();
}
class _ProductState extends State<Product> {

//---------------------------------------------------------------------------------------------------//
  //variables
  List data;
  String fullname = "";
  String firstname = "";
  String lastname = "";
  String name = '';
  TextEditingController controller = new TextEditingController();
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  String id;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String CountProduct = '';
  String Userid= '';
  String ReciveCount = " ";
  String ProductName="";
  final String phone = 'tel:+917000624695';
//---------------------------------------------------------------------------------------------------//

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.title.contains(text) || f.id.toString().contains(text))
        _search.add(f);
    });
    setState(() {});
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    //CountProduct = prefs.getString(Preferences.KEY_CountProduct).toString();
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
    await http.get("http://gravitinfosystems.com/MDNS/MDN_APP/product.php?name=product");
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data = extractdata["data"];
      //print("ReciveData"+data.toString());
      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i));
          loading = false;
        }
      });
    }
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(HomePage.tag);
  }
//---------------------------------------------------------------------------------------------------//
  removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    prefs.remove(Preferences.KEY_ROLE);
    prefs.remove(Preferences.KEY_NAME);
    prefs.remove(Preferences.KEY_Contact);
    Navigator.of(context).pushNamed(Splash.tag);
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
//----------------------------------------------------------------------------------------//
  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
//---------------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.getProductCount();
    this.fetchData();
  }
//---------------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _id;
//---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    return new WillPopScope(
        onWillPop: BackScreen,
    child: Scaffold(
      drawer:  _drawer(),
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: new Container(
          color: Colors.transparent,
            width: _width / 0,
            height: 40,
            child: new TextField(
              //cursorColor: Colors.white,
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search ",hintStyle: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.w500),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,color: Colors.white,
                    size: 28.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel,color: Colors.white,),
                    onPressed: () {
                      controller.clear();
                      onSearch('');
                    },)
              ),
            ),
        ),
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
//-------------------------------------------------------------------------------------//
      body: Container(
        child: Column(
          children: <Widget>[
            new Container(),
            loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: _search.length != 0 || controller.text.isNotEmpty
                  ? GridView.builder(
                itemCount: _search.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  //padding: EdgeInsets.all(4.0),
                  /*childAspectRatio: 8.0 / 9.0,*/),
                itemBuilder: (context, i) {
                  final b = _search[i];
                  return new Container(
                      child: new GestureDetector(
                        onTap: () {
                          setState(() {
                            _id = int.parse(data[i][
                            "product_id"]);
                            ProductName = (data[i][
                            "product_name"]);//if you want to assign the index somewhere to check
                           // print("ProductName"+ProductName.toString());
                           // print("Product_id"+_id.toString());
                          });
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new DetailsOrAddToCart(
                                value: _id.toString(),
                                value2: ProductName.toString(),
                                value1: " ${ widget.value }"),
                          );
                          Navigator.of(context).push(route);
                        },
                        child: new Card(
                          key: null,
                          elevation: 2.0,
                          child: new Container(
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //SizedBox(height: 1.0),

                                  AspectRatio(
                                    aspectRatio: 18.0 / 12.0,
                                    child: Image.network(
                                      imageurl+b.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height:5.0),
                                  new Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          b.title.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        //SizedBox(height: 0.1),
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
                                                      "Rs."+b.mrp,
                                                      style: new TextStyle(fontSize: 13.0, color: Colors.grey,decoration: TextDecoration.lineThrough,),
                                                    ),
                                                    new Text(
                                                      /*"${widget.itemRating}",*/
                                                      " Rs."+b.body,
                                                      style: new TextStyle(fontSize: 13.0, color: Colors.black,fontWeight: FontWeight.bold),
                                                    ),

                                                  ],
                                                ),
                                                new Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    new Container(
                                                      child: new CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        child: Image.asset('assets/images/discount.png'),
                                                      ),
                                                      margin: const EdgeInsets.all(1.0),
                                                      width: 15.0,
                                                      height: 15.0,
                                                    ),
                                                    new Text(
                                                      /*"${widget.itemRating}",*/
                                                      b.Discount,
                                                      style: new TextStyle(fontSize: 13.0, color: Colors.red,fontWeight: FontWeight.bold),
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
                                ]),
                            margin: const EdgeInsets.all(5.0),
                            height: 80.0,
                            width: _width / 2,
                          ),
                        ),
                      ),

                  );
                },
              )
//---------------------------------------------------------------------------------------------------//
                  : GridView.builder(
                padding: const EdgeInsets.all(4.0),
                //crossAxisSpacing: 10,
                itemCount: _list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  //padding: EdgeInsets.all(4.0),
                  /*childAspectRatio: 8.0 / 9.0,*/),
                itemBuilder: (context, i) {
                  final a = _list[i];
                  return new Container(
                    child: new GestureDetector(
                      onTap: () {
                        setState(() {
                          _id = int.parse(data[i][
                          "product_id"]);
                          ProductName = (data[i][
                          "product_name"]);//if you want to assign the index somewhere to check
                          //print("ProductName"+ProductName.toString());
                          //print("Product_id"+_id.toString());
                        });
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new DetailsOrAddToCart(
                              value: _id.toString(),
                              value2: ProductName.toString(),
                              value1: " ${ widget.value }"),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: new Card(
                        key: null,
                        elevation: 2.0,
                        child: new Container(
                          child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //SizedBox(height: 1.0),

                                AspectRatio(
                                  aspectRatio: 18.0 / 12.0,
                                  child: Image.network(
                                    imageurl+a.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height:5.0),
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        a.title.toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      //SizedBox(height: 0.1),
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
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new Container(
                                                    child: new CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      child: Image.asset('assets/images/discount.png'),
                                                    ),
                                                    margin: const EdgeInsets.all(1.0),
                                                    width: 15.0,
                                                    height: 15.0,
                                                  ),
                                                  new Text(
                                                    /*"${widget.itemRating}",*/
                                                    a.Discount,
                                                    style: new TextStyle(fontSize: 13.0, color: Colors.red,fontWeight: FontWeight.bold),
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
                              ]),
                          margin: const EdgeInsets.all(5.0),
                          height: 80.0,
                          width: _width / 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
}
//---------------------------------------------------------------------------------------------------//