import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/CategoryScreen/ProductListGridView.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/model.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';

class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}

class ProductGridViewDetails extends StatefulWidget {
  static String tag = 'ProductGridViewDetails';

  final String value;
  final String value1;
  final String value2;

  // Teacher_TimetableBYDay(this.value1);

  ProductGridViewDetails({Key key, this.value, this.value1, this.value2}) : super(key: key);

  @override
  _MonthSelection createState() => new _MonthSelection();
}

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

  // ignore: missing_return
  Future<Null> makeRequest() async {
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

  // ignore: missing_return
  Future<String> GetCountRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString(Preferences.KEY_ID).toString();
    //RecivedCount = prefs.getString(Preferences.KEY_CountProduct).toString();
    //print("USERLOGINIDRECIVE"+id);

    String url = 'http://gravitinfosystems.com/MDNS/MDN_APP/Cart.php?UserId='+id+'&ProductId='+StoreProductId;
    print("url"+url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      NumberOfCount = extractdata.toString();
      //print("recivedata"+NumberOfCount);

      RecivedCount = extractdata["count"].toString();
      print("count"+RecivedCount);

      RecivedMessage = extractdata["count"].toString();
      print("RecivedMessage"+RecivedMessage);
    });
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulation'),
          content:  Text("Product Add Successfully Thanks.."),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushNamed(CategoryScreenList.tag);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    this.makeRequest();
  }

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
                print("StoreProductId"+StoreProductId);
                return new Container(
                  child: new Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      new SingleChildScrollView(
                        child: new Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(imageurl+a.image,),
                                ),
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

    return Scaffold(
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
                    _ackAlert(context); //fun2
                  },
                ),

              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );

  }

}

