import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/CheckOutScreen/CheckOut.dart';
import 'package:mdsons/ProductScreen/ProductCheckOut.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/ProductTotalCartModel.dart';
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
class ProductTotalCardList extends StatefulWidget {

  static String tag = 'ProductTotalCardList';
  final String value;
  final String value4;
  final String value5;
//---------------------------------------------------------------------------------------------------//
  ProductTotalCardList({Key key, this.value, this.value4, this.value5}) : super(key: key);
  @override
  _ProductTotalCardList createState() => new _ProductTotalCardList();
}
//---------------------------------------------------------------------------------------------------//
class _ProductTotalCardList extends State<ProductTotalCardList> {
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
  String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
  final String phone = 'tel:+917000624695';
  String ReciveTotalPrice = '';
  String GlobalProductId  = '';
  String CardItemId  = '';
  bool statusProductDeleted = false;
  int statusProductAddItem = 0;
  bool statusProductRemoveItem = false;
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
    String Url ='http://gravitinfosystems.com/MDNS/MDN_APP/CartProduct.php?id='+widget.value.toString();
    print("CartProductListUrl"+Url);;
    final response =
    await http.get(Url);
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      data = extractdata["data"];
      //print("data"+data.toString());
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
   // print("GetCountFromServer"+ReciveTotalPrice);
    setState(() {
      //print("Success");
      //print("GetCountFromServer"+Userid);
    });
  }
//---------------------------------------------------------------------------------------------------//
  DeleteProductItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetDeleteProductItem =
        'http://gravitinfosystems.com/MDNS/MDN_APP/DeleteProductFromCart.php?UserId='+Userid+"&ProductId="+GlobalProductId;
   // print("GetCount " + GetDeleteProductItem);
    var res =
    await http.get(GetDeleteProductItem, headers: {"Accept": "application/json"});
    var ProductdataDelete = json.decode(res.body);
    statusProductDeleted = ProductdataDelete['status'];
    //print("status" + statusProductDeleted.toString());
    setState(() {
      print("Success");
    });
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _DeleteProductItemAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Deleted.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: Palette1.greenLandLight1,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product has been deleted from your List Thanks..',
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
                //("hello123"+id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductTotalCardList(
                          value: Userid.toString(),
                          value5: widget.value.toString()
                          )),
                  );
              },
              child: Text('OK', style: new TextStyle(fontSize: 15.0,
                                                         color: Palette1
                                                             .greenLandLight1,
                                                         fontWeight: FontWeight
                                                             .bold),),
              )
          ],
          );
      },
      );
  }
//---------------------------------------------------------------------------------------------------//
  AddProductCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetAddProductCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/Cart.php?UserId='+Userid+"&ProductId="+GlobalProductId;
    var res =
    await http.get(GetAddProductCount, headers: {"Accept": "application/json"});
    var dataAddItem = json.decode(res.body);
    statusProductAddItem = dataAddItem['status'];
    print("status" + statusProductAddItem.toString());
    setState(() {
      print("Success");
    });
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _AddProductItemAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Added.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: Palette1.greenLandLight1,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product has been Added From Your List Thanks..',
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
                //("hello123"+id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductTotalCardList(
                          value: Userid.toString(),
                          value5: widget.value.toString()
                          )),
                  );
              },
              child: Text('OK', style: new TextStyle(fontSize: 15.0,
                                                         color: Palette1
                                                             .greenLandLight1,
                                                         fontWeight: FontWeight
                                                             .bold),),
              )
          ],
          );
      },
      );
  }
//---------------------------------------------------------------------------------------------------//
  RemoveProductCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    //print("Userid"+Userid);
    String GetRemoveCount =
        'http://gravitinfosystems.com/MDNS/MDN_APP/RemoveSingleCartItem.php?CartId='+CardItemId;
   // print("GetRemoveCount " + GetRemoveCount);
    var res =
    await http.get(GetRemoveCount, headers: {"Accept": "application/json"});
    var dataRemoveItem = json.decode(res.body);
    statusProductRemoveItem = dataRemoveItem['status'];
    print("status" + statusProductRemoveItem.toString());
    setState(() {
      print("Success");
    });
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _RemoveProductItemAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Removed.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: Palette1.greenLandLight1,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product has been Removeded From Your List Thanks..',
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
                //("hello123"+id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductTotalCardList(
                          value: Userid.toString(),
                          value5: widget.value.toString()
                          )),
                  );
              },
              child: Text('OK', style: new TextStyle(fontSize: 15.0,
                                                         color: Palette1
                                                             .greenLandLight1,
                                                         fontWeight: FontWeight
                                                             .bold),),
              )
          ],
          );
      },
      );
  }
//---------------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.getProductCount();
    this.fetchData();
    this.getTotalPrice();
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(Product.tag);
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
            child: ListView.separated(
              padding: const EdgeInsets.all(4.0),
              //crossAxisSpacing: 10,
              itemCount: _list.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.0, color: Colors.grey),
              itemBuilder: (context, i) {
                categoryid = data[i]["categoryid"];
                final a = _list[i];
                GlobalProductId = a.userId.toString();
                CardItemId = a.id.toString();
                return new Container(
                  color: Colors.white54,
                  child: new GestureDetector(
                    /*onTap: () {
                      setState(() {
                        _id = int.parse(data[i][
                                        "categoryid"]); //if you want to assign the index somewhere to check
                        //print("categoryid"+_id.toString());
                      });
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new SubCategoryList(
                            value: _id.toString(),
                            value1: " ${ widget.value }"),
                        );
                      Navigator.of(context).push(route);
                    },*/
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageurl+a.image),
                                fit: BoxFit.contain,
                                ),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    a.productname,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color:Color(0xFF222B78),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                    ),
                                  Text(
                                    "Total Add Item ${a.count}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:Color(0xFF222B78),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 5,
                                    ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "SellingPrice ${a.SellingPrice}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:Color(0xFF222B78),
                                            ),
                                          ),
                                        ),
                                      Icon(
                                        FontAwesomeIcons.rupeeSign,
                                        size: 18,
                                        color:Color(0xFF222B78),
                                        ),
                                      new Text(a.Discost.toString(), style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color:Color(0xFF222B78),
                                        ),
                                               ),
                                      SizedBox(
                                        width: 5,
                                        ),
                                      /*Icon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color:Color(0xFFE0318C),
                                        ),*/
                                    ],
                                    ),
                                  SizedBox(
                                    height: 5,
                                    ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:Color(0xFF222B78),
                                            ),
                                          ),
                                        ),

                                      Container(
                                        color:Color(0xFFE0318C),
                                        child: IconButton(
                                          icon: Icon(Icons.remove,color: Colors.white,),
                                          onPressed: () {
                                            setState(() {

                                              CardItemId = (data[i][
                                              "Id"]);
                                              //if you want to assign the index somewhere to check
                                              //print("OnTapProductId"+GlobalProductId.toString());
                                            });
                                            RemoveProductCount();
                                            _RemoveProductItemAlert();
                                            //print("hello");
                                            // model.removeProduct(model.cart[index]);
                                          },
                                          ),
                                        ),
                                      Container(
                                        color:Color(0xFFE0318C),
                                        child: IconButton(
                                          icon: Icon(Icons.add,color: Colors.white,),
                                          onPressed: () {
                                            setState(() {

                                              GlobalProductId = (data[i][
                                              "product_id"]);
                                              //if you want to assign the index somewhere to check
                                             // print("OnTapProductId"+GlobalProductId.toString());
                                            });
                                            AddProductCount();
                                            _AddProductItemAlert();
                                            //print("hello");
                                            // model.removeProduct(model.cart[index]);
                                          },
                                          ),
                                        ),
                                      Container(
                                        color:Color(0xFFE0318C),
                                        child: IconButton(
                                          icon: Icon(Icons.delete,color: Colors.white,),
                                          onPressed: () {
                                            setState(() {

                                              GlobalProductId = (data[i][
                                              "product_id"]);
                                              //if you want to assign the index somewhere to check
                                             // print("OnTapProductId"+GlobalProductId.toString());
                                            });
                                            DeleteProductItem();
                                            _DeleteProductItemAlert();
                                            //print("hello");
                                            // model.removeProduct(model.cart[index]);
                                          },
                                          ),
                                        ),
                                      /*SizedBox(
                                        width: 5,
                                        ),*/
                                      /*Icon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color:Color(0xFFE0318C),
                                        ),*/
                                    ],
                                    ),
                                ],
                                ),
                              ),
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
              child: Text('add item List'.toUpperCase()),
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
                          builder: (context) => ProductTotalCardList(
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
                    icon: Icon(FontAwesomeIcons.rupeeSign,color: Colors.white,), //`Icon` to display
                      label: Text(ReciveTotalPrice.toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                    /*onPressed: () {
                        Navigator
                            .of(context)
                            .push(new MaterialPageRoute(builder: (_) => new Product()));
                      },*/
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
                          new ProductCheckOut(
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
          ),),
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
//---------------------------------------------------------------------------------------------------//