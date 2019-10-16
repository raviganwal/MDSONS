import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdsons/Preferences/Preferences.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//----------------------------------------------------------------------------------------//
class Palette {
  static Color greenLandLight = Color(0xFFE0318C);
}
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}

class PasswordEdit extends StatefulWidget {
  static String tag = 'PasswordEdit';
 // const PasswordEdit({ Key key }) : super(key: key);

  static const String routeName = '/material/text-form-field';

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();

}

class PersonData {
  String password = '';
  String Currentpassword = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String ReciveCount = '';
  String Userid = '';
  final String phone = 'tel:+917000624695';
  TextEditingController NewPasswordController = new TextEditingController();
  TextEditingController ConfirmePasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
            ),
          ),
        ),
      );
  }
}

class TextFormFieldDemoState extends State<PasswordEdit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String ReciveCount = '';
  String Userid = '';
  String UserMessage = '';


  TextEditingController PasswordController = new TextEditingController();
  TextEditingController ConfirmPasswordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter = _UsNumberTextInputFormatter();


  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      //showInSnackBar('${person.Currentpassword}\Please Enter Current Password');
      EditPasswordData(PasswordController.text,ConfirmPasswordController.text);
      _showMaterialDialog();
    }
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value)
      return 'The passwords don\'t match';
    return null;
  }
//----------------------------------------------------------------------------------------//
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

//----------------------------------------------------------------------------------------//
  removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    prefs.remove(Preferences.KEY_ROLE);
    prefs.remove(Preferences.KEY_NAME);
    prefs.remove(Preferences.KEY_Contact);
    //prefs.remove(Preferences.KEY_CountProduct);
    Navigator.of(context).pushNamed(Splash.tag);
  }
//----------------------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    this.fetchData();
    this.getProductCount();
    //this.EditPasswordData();

    //this.EditPasswordData(PasswordController.text, ConfirmPasswordController.text);
  /*  setState(() {
      UserMessage.toString();
    });*/
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate())
      return true;

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('This form has errors'),
          content: const Text('Really leave this form?'),
          actions: <Widget> [
            FlatButton(
              child: const Text('YES'),
              onPressed: () { Navigator.of(context).pop(true); },
              ),
            FlatButton(
              child: const Text('NO'),
              onPressed: () { Navigator.of(context).pop(false); },
              ),
          ],
          );
      },
      ) ?? false;
  }
//----------------------------------------------------------------------------------------//
  // ignore: missing_return
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
  }
//----------------------------------------------------------------------------------------//
  EditPasswordData(String Password,String NewPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Userid = prefs.getString(Preferences.KEY_ID).toString();
    String profile =
        'http://192.168.0.200/anuj/MDN/MDN_APP/ChangePassword.php?id='+
            Userid +
            "&Password=" +
            Password +
            "&NewPassword=" +
            NewPassword ;

    print("URL " + profile);

    var res =
    await http.get(profile, headers: {"Accept": "application/json"});

    var data = json.decode(res.body);
    UserMessage= data["msg"].toString();
    print("UserMessage"+UserMessage.toString());
    print("data" + data.toString());

    setState(() {
      print("Success");
    });
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
//----------------------------------------------------------------------------------------//
  _callPhone() async {
    final String phone = 'tel:+917000624695';
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
  Future _showMaterialDialog() async {
    await   showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Password Messages.',textAlign: TextAlign.center,
                          style: new TextStyle(fontSize: 15.0,
                                                   color: Palette.greenLandLight,
                                                   fontWeight: FontWeight.bold),),

            content: Text(UserMessage.toString(),textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 12.0,
                                                     color: Palette1.greenLandLight1,
                                                     fontWeight: FontWeight.bold),),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    //print("hello"+id.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PasswordEdit(
                              )),
                      );
                  },
                  child: Text('Cancel')),
              FlatButton(
                onPressed: () {
                  //print("hello"+id.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(
                            )),
                    );
                },
                child: Text('ok!'),
                )
            ],
            );
        });
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushNamed(Profile
                                          .tag); //return a `Future` with false value so this route cant be popped or closed.
    },
    child: Scaffold(
      drawer: new Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Mr. "+UserName, style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    letterSpacing: 1.4,
                    backgroundColor: Colors.transparent,
                    fontWeight: FontWeight.bold),),
                accountEmail: Text(UserEmail, style: TextStyle(
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
                title: Text("Home".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
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
                title: Text("Profile".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
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
                title: Text("Products".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
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
                title: Text("categories".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
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
                title: Text("MyOrder".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
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
                title: Text("Help".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
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
                title: Text("Logout".toUpperCase(), style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
                onTap: () {
                 // TapMessage();
                },
                ),
            ],
        )),
      drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      appBar: AppBar(
        title: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
            color: Colors.transparent,
            child: Text('Password Edit'.toUpperCase()),
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
        //actions: <Widget>[MaterialDemoDocumentationButton(PasswordEdit.routeName)],
        ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          onWillPop: _warnUserAboutInvalidData,
          child: Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: PasswordController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Current Password',
                      suffixStyle: TextStyle(color: Colors.green),
                      ),
                    maxLines: 1,
                    ),
                  const SizedBox(height: 24.0),
                  PasswordField(
                    fieldKey: _passwordFieldKey,
                    labelText: 'Enter New Password *',
                    onFieldSubmitted: (String value) {
                      setState(() {
                        person.password = value;
                      });
                    },
                    ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: ConfirmPasswordController,
                    enabled: person.password != null && person.password.isNotEmpty,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Enter Confirm  Password',
                      ),
                    maxLength: 8,
                    obscureText: true,
                    validator: _validatePassword,
                    ),
                  const SizedBox(height: 24.0),
                 /*Center(
                    child: RaisedButton(
                      child: const Text('SUBMIT'),
                     // onPressed: _handleSubmitted,
                      ),
                    ),*/
                  const SizedBox(height: 24.0),
                ],
                ),
              ),
            ),
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
                  icon: Icon(Icons.save, color: Colors.white,),
                    //`Icon` to display
                    label: Text(
                        "Submit".toUpperCase(), textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 15.0,
                                           color: Colors.white,
                                           fontWeight: FontWeight.bold,)),
                    //`Text` to display
                  onPressed: _handleSubmitted,
                   /* onPressed: () {
                      EditPasswordData(PasswordController.text,ConfirmPasswordController.text); //fun1
                     // _ackAlert(); //fun2
                    },*/

                  ),

                ),
              flex: 1,
              ),
            /* Expanded(
                child: Container(
                  height: 50,
                  color: Color(0xFFE0318C),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(Icons.save, color: Colors.white,),
                      //`Icon` to display
                      label: Text('Submit'.toUpperCase(), style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,)),
                      //`Text` to display
                      onPressed: () {
                        EditProfileData(
                            NameController.text,
                            ContactController.text,
                            AddressController.text); //fun1
                        _ackAlert(); //fun2
                      },

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
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
      );
  }
}