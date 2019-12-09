import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'fish.dart';
import 'mainscreen.dart';
import 'user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FishDetail extends StatefulWidget {
  final Fish fish;
  final User user;

  const FishDetail({Key key, this.fish, this.user}) : super(key: key);
  @override
  _FishDetailState createState() => _FishDetailState();
}

class _FishDetailState extends State<FishDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          backgroundColor: Colors.orange[100],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Fish Details'),
            backgroundColor: Colors.orange,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                fish: widget.fish,
                user: widget.user,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Fish fish;
  final User user;
  DetailInterface({this.fish, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(double.parse(widget.fish.fishlatitude),
          double.parse(widget.fish.fishlongitude)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://myondb.com/myNelayanLY/images/${widget.fish.fishimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.fish.fishtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.fish.fishtime),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Fish Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(""),
                ]),
                TableRow(children: [
                  Text("Fish Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.fish.fishprice),
                ]),
                TableRow(children: [
                  Text("Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(""),
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: 340,
                child: GoogleMap(
                  initialCameraPosition: _myLocation,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'Add to Fish',
                    style: TextStyle(fontSize: 12),
                  ),
                  color: Colors.deepOrangeAccent,
                  textColor: Colors.orange,
                  elevation: 5,
                  onPressed: _onAcceptFish,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptFish() {
    if (widget.user.email == "user@noregister") {
      Toast.show("Please register to view Fish cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      _showDialog();
    }
    print("Add to Fish");
  }

  void _showDialog() {
    // flutter defined function
    if (int.parse(widget.user.wallet) < 1) {
      Toast.show("Wallet not enough ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add " + widget.fish.fishtitle),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> acceptRequest() async {
    String urlLoadFish = "http://myondb.com/myNelayanLY/php/accept_fish.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting fish");
    pr.show();
    http.post(urlLoadFish, body: {
      "fishid": widget.fish.fishID,
      "email": widget.user.email,
      "wallet": widget.user.wallet,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        _onLogin(widget.user.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
    String urlgetuser = "http://myondb.com/myNelayanLY/php/get_user.php";
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            phone: dres[2],
            email: dres[3],
            wallet: dres[7],
            rating: dres[8]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
