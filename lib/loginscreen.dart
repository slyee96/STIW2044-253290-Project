import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'forgotscreen.dart';
import 'mainscreen.dart';
import 'registerscreen.dart';
import 'user.dart';

String urlLogin = "http://myondb.com/myNelayanLY/php/login_user.php";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _passcontroller = TextEditingController();
  String _password = "";
  bool _isChecked = false;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  @override
  void initState() {
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          backgroundColor: Colors.orange[300],
          resizeToAvoidBottomPadding: false,
          body: new Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/MyNelayan.png',
                  width: 230,
                  height: 200,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                    autovalidate: _validate,
                    controller: _emcontroller,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        labelText: 'Email',
                        icon: Icon(Icons.email))),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autovalidate: _validate,
                  controller: _passcontroller,
                  validator: validatePassword,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      labelText: 'Password',
                      icon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 50,
                  child: Text('Sign In'),
                  color: Colors.orange,
                  textColor: Colors.black,
                  elevation: 15,
                  onPressed: _onLogin,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    Text('Remember Me', style: TextStyle(fontSize: 16))
                  ],
                ),
                GestureDetector(
                    onTap: _onForgot,
                    child:
                        Text('Forgot Account', style: TextStyle(fontSize: 18))),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: _onRegister,
                    child: Text('Register a New Account',
                        style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        ));
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

  void _onLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLogin, body: {
        "Email": _email,
        "Password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          print("Radius:");
          print(dres);
          User user = new User(
              name: dres[1],
              email: dres[2],
              phone: dres[3],
              radius: dres[6],
              wallet: dres[7],
              rating: dres[8]);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreen(user: user)));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_isEmailValid(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _passcontroller.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email.length > 1) {
      _emcontroller.text = _email;
      _passcontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }
}
