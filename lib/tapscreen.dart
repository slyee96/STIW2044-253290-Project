import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project_mynelayan/fish.dart';
import 'SlideRightRoute.dart';
import 'fishdetail.dart';
import 'user.dart';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';

double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user});
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.orange[100],
        body: RefreshIndicator(
            key: refreshKey,
            color: Colors.orange,
            onRefresh: () async {
              await refreshList();
            },
            child: ListView.builder(
                itemCount: data == null ? 1 : data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Column(
                              children: <Widget>[
                                Center(
                                  child: Text("myNelayan",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange)),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: 280,
                                  height: 100,
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.person,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  widget.user.name
                                                          .toUpperCase() ??
                                                      "Not registered",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(_currentAddress),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.account_balance_wallet,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text("You have " +
                                                    widget.user.wallet +
                                                    " coins (Wallet)"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.deepOrange,
                            child: Center(
                              child: Text("Fishes Available Today",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (index == data.length && perpage > 1) {
                    return Container(
                      width: 250,
                      color: Colors.white,
                      child: MaterialButton(
                        child: Text(
                          "Load More",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                      ),
                    );
                  }
                  index -= 1;
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () => _onFishDetail(
                            data[index]['fishID'],
                            data[index]['fishtitle'],
                            data[index]['fishowner'],
                            data[index]['fishdes'],
                            data[index]['fishprice'],
                            data[index]['fishtime'],
                            data[index]['fishimage'],
                            data[index]['fishaccepted'],
                            data[index]['fishlatitude'],
                            data[index]['fishlongitude'],
                            widget.user.email,
                            widget.user.name,
                            widget.user.wallet),
                        onLongPress: () => _onFishDelete(
                            data[index]['fishid'].toString(),
                            data[index]['fishtitle'].toString()),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              "http://myondb.com/myNelayanLY/images/${data[index]['fishimage']}.jpg")))),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          data[index]['fishtitle']
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("RM " + data[index]['fishprice']),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data[index]['fishtime']),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }

  Future<String> makeRequest() async {
    String urlLoadJobs = "http://myondb.com/myNelayanLY/php/load_fishes.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Fishes");
    pr.show();
    http.post(urlLoadJobs, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["fishes"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onFishDetail(
      String fishID,
      String fishtitle,
      String fishowner,
      String fishdes,
      String fishprice,
      String fishtime,
      String fishimage,
      String fishaccepted,
      String fishlatitude,
      String fishlongitude,
      String email,
      String name,
      String wallet) {
    Fish fish = new Fish(
      fishID: fishID,
      fishtitle: fishtitle,
      fishowner: fishowner,
      fishdes: fishdes,
      fishprice: fishprice,
      fishtime: fishtime,
      fishimage: fishimage,
      fishaccepted: null,
      fishlatitude: fishlatitude,
      fishlongitude: fishlongitude,
    );
    //print(data);

    Navigator.push(context,
        SlideRightRoute(page: FishDetail(fish: fish, user: widget.user)));
  }

  void _onFishDelete(String fishID, String fishtitle) {
    print("Delete " + fishID);
    _showDialog(fishID, fishtitle);
  }

  void _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  void _showDialog(String fishID, String fishtitle) {
    String urlLoadJobs = "http://myondb.com/myNelayanLY/php/delete_fish.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting Fish");
    pr.show();
    http.post(urlLoadJobs, body: {
      "fishid": fishID,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        init();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }
}
