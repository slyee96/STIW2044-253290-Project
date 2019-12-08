import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

File _image;
String pathAsset = 'assets/images/profile.png';
String urlUpload = "http://myondb.com/myNelayanLY/php/register_user.php";
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
String _name, _email, _password, _phone;
bool _isChecked = false;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.orange[100],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New Customer Registration'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on image above to take profile picture'),
        TextFormField(
            autovalidate: _validate,
            controller: _namecontroller,
            validator: validateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _phcontroller,
            validator: validatePhone,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        TextFormField(
            autovalidate: _validate,
            controller: _emcontroller,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextFormField(
          autovalidate: _validate,
          controller: _passcontroller,
          validator: validatePassword,
          keyboardType: TextInputType.text,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _isChecked,
              onChanged: (bool value) {
                _onChange(value);
              },
            ),
            Text('I agree to myNelayan ', style: TextStyle(fontSize: 14)),
            GestureDetector(
                child: Text("(Terms and Condition)",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
                onTap: () {
                  launch(
                      'http://myondb.com/myNelayanLY/php/termandcondition.php');
                  // do what you need to do when "Click here" gets clicked
                })
          ],
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20.0)),
          minWidth: 200,
          height: 50,
          child: Text('Register'),
          color: Colors.orange,
          textColor: Colors.black,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16))),
      ],
    );
  }

  String validateName(String value) {
    if (value.length == 0) {
      return "Name is Required";
    }
    return null;
  }

  String validatePhone(String value) {
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (value.length < 9 || value.length > 11) {
      return "Phone Number must 10-11 digits";
    }
    return null;
  }

  String validateEmail(String value) {
    if (value.length == 0) {
      return "Email is Required";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _phone = _phcontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    print(_password);
    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 9 || _phone.length < 12)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "phone": _phone,
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _phcontroller.text = '';
          _emcontroller.text = '';
          _passcontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _validate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  Future savepref(String email, String password) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', password);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}
