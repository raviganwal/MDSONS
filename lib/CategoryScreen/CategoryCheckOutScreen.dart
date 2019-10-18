import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:mdsons/TotalAddCartList/TotalCartModel.dart';
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
class CategoryCheckOutScreen extends StatefulWidget {

  static String tag = 'TotalCheckOut';
  final String value;
  final String value7;
  final String value8;

//---------------------------------------------------------------------------------------------------//
  CategoryCheckOutScreen({Key key, this.value, this.value7, this.value8}) : super(key: key);
  @override
  _CategoryCheckOutScreenList createState() => new _CategoryCheckOutScreenList();
}
//---------------------------------------------------------------------------------------------------//
class _CategoryCheckOutScreenList extends State<CategoryCheckOutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      ));
  }
  static final String uploadEndPoint =
      'http://gravitinfosystems.com/MDNS/MDN_APP/CheckoutCart.php?PaymentImage=';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String Userid = '';
  String ReciveCount = '';
  String ReciveStatus = '';
  String OrderNumber = '';
  String pressphone = "";
  bool UploadImagestatus = false;
//-------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.fetchData();
    this.getProductCount();
    super.initState();
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

//-------------------------------------------------------------------------------------------//
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path
        .split('/')
        .last;
    upload(fileName);
  }

//--------------------------------------------------------------------------------//
  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
      "UserId": Userid,
      "TotalAmount": widget.value7.toString(),
    }).then((result) {
      // print("base64Image"+base64Image.toString());
      //print("fileName"+fileName.toString());
      //print("uploadEndPoint"+uploadEndPoint.toString());
      // print("uploadEndPoint"+uploadEndPoint.toString());
      print("UserId" + Userid);
      print("TotalAmount" + widget.value7.toString());
      print("uploadEndPoint" + uploadEndPoint.toString());
      print("statusCode" + result.statusCode.toString());
      print("resultbody" + result.body);
      // return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);

      var data = json.decode(result.body);
      ReciveStatus = data["msg"].toString();
      OrderNumber = data["OrderNumber"].toString();
      UploadImagestatus = data["status"];

      print("ReciveStatus" + ReciveStatus.toString());
      print("OrderNumber" + OrderNumber.toString());
      print("UploadImagestatus" + UploadImagestatus.toString());
    }).catchError((error) {
      setStatus(error);
    });
  }
  void _handleSubmitted() {
    if(UploadImagestatus == true){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
            )),
        );
    }else{
      showInSnackBar(ReciveStatus.toString());
    }
  }


//----------------------------------------------------------------------------//
  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.contain,
              ),
            );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
            );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
            );
        }
      },
      );
  }

//---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Upload Picture"),
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
                        builder: (context) =>
                            TotalAddCartList(
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
      body: Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              child: Column(
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
                              style: new TextStyle(fontSize: 12.0,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight
                                                           .bold),
                            ),
                          Icon(FontAwesomeIcons.rupeeSign, color: Colors.black,
                                 size: 15.0,),
                          new Text(
                            /*"${widget.itemRating}",*/
                            widget.value7.toString().toUpperCase(),
                              style: new TextStyle(fontSize: 12.0,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight
                                                           .bold),
                            ),

                        ],
                        ),
                    ],
                    ),

                ],
                ),
              ),
            SizedBox(
              height: 20.0,
              ),
            showImage(),
            SizedBox(
              height: 100.0,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  color: Color(0xFFE0318C),
                  icon: Icon(FontAwesomeIcons.camera, color: Colors.white,),
                  //`Icon` to display
                  label: Text("Camera".toUpperCase().toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight
                                        .bold,)),
                  //`Text` to display
                  onPressed: chooseCamera,
                  ),

                FlatButton.icon(
                  color: Color(0xFFE0318C),
                  icon: Icon(FontAwesomeIcons.cameraRetro,
                               size: 18,
                               color: Colors.white,), //`Icon` to display
                  label: Text('gallery'.toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,)), //`Text` to display
                  onPressed: chooseImage,
                  ),
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
                  icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.white,),
                    //`Icon` to display
                    label: Text("send".toUpperCase().toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .bold,)),
                    //`Text` to display
                    onPressed: () {
                      startUpload();
                      _handleSubmitted();
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
      );
  }
}//---------------------------------------------------------------------------------------------------//