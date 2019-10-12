import 'package:mdsons/CategoryScreen/ProductListGridView.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/CategoryScreen/SubCategoryModel.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
class Palette {
  static Color greenLandLight = Color(0xFF6B0129);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF974d69);
}
class Palette2 {
  static Color greenLandLight2 = Color(0xFF222B78);
}
class SubCategoryList extends StatefulWidget {
  static String tag = 'SubCategoryList';

  final String value;
  final String value1;

 // Teacher_TimetableBYDay(this.value1);

  SubCategoryList({Key key, this.value, this.value1}) : super(key: key);

  @override
  _MonthSelection createState() => new _MonthSelection();
}

class _MonthSelection extends State<SubCategoryList> {
  String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
  List data;
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  String Userid = '';
  String ReciveCount = '';

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

  // ignore: missing_return
  Future<Null> makeRequest() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
    await http.get('http://gravitinfosystems.com/MDNS/MDN_APP/Category1?id='+widget.value.toString());
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

  @override
  void initState() {
    this.getProductCount();
    this.makeRequest();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _id;

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

              padding: const EdgeInsets.all(4.0),
              //crossAxisSpacing: 10,
              itemCount: _list.length,
              itemBuilder: (context, i) {
                final a = _list[i];
                return new Container(
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        _id = int.parse(data[i][
                        "sub_cat_id"]); //if you want to assign the index somewhere to check
                        print("sub_cat_id"+_id.toString());
                      });
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new ProductListGridView(
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

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              color: Colors.transparent,
              child: Text('sub Category'.toUpperCase()),
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
        body: listJson);
  }
}

