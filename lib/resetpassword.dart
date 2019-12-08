import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'forgotscreen.dart';
import 'loginscreen.dart';

String urlReset = "http://myondb.com/myNelayanLY/php/resetPass.php";

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  @override
  _ResetPasswordState createState() => _ResetPasswordState(email);
  ResetPasswordScreen({Key key, this.email}) : super(key: key);
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  final TextEditingController _tempasscontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  String _tempassword = "";
  String _password = "";
  String email;
  _ResetPasswordState(this.email);
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
          title: Text('Reset Password'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Enter your temporary password"),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                  autovalidate: _validate,
                  controller: _tempasscontroller,
                  validator: validatePassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Temporary Password',
                    icon: Icon(Icons.person),
                  )),
              SizedBox(
                height: 20.0,
              ),
              Text("Enter your new password"),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                  autovalidate: _validate,
                  controller: _passcontroller,
                  validator: validatePassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Temporary Password',
                    icon: Icon(Icons.person),
                  )),
              SizedBox(
                height: 20.0,
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
                child: Text('Submit'),
                color: Colors.orange,
                textColor: Colors.black,
                elevation: 15,
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPassword(),
        ));
    return Future.value(false);
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

  void _onSubmit() {
    _tempassword = _tempasscontroller.text;
    _password = _passcontroller.text;
    email = widget.email;
    if (_password.length > 5) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Reset Password in progress");
      pr.show();
      http.post(urlReset, body: {
        "mmail": email,
        "temPassword": _tempassword,
        "newPassword": _password,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "success") {
          pr.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
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
      Toast.show("Please check your temporary password in your mail.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
