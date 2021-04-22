import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OngoingDetailScreen extends StatefulWidget {
  final String phone, name, email;
  final String task;
  final String company;
  OngoingDetailScreen({
    @required this.phone,
    @required this.name,
    @required this.email,
    @required this.task,
    @required this.company,
  });
  @override
  _OngoingDetailScreenState createState() => _OngoingDetailScreenState();
}

class _OngoingDetailScreenState extends State<OngoingDetailScreen> {
  TextEditingController status = TextEditingController();
  List maps = [];
  Firestore _firestore = Firestore.instance;
  String docID = "";
  bool flag = false;
  int numerator = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController link = TextEditingController();
  verify() {
    int value = int.parse(status.text.trim());
    if (value == null) {
      Fluttertoast.showToast(msg: "Enter new status value");
      return;
    } else if (value > maps[0]["maxStatus"]) {
      Fluttertoast.showToast(msg: "enter a valid value");
    } else if (value == maps[0]["maxStatus"]) {
      print(docID);
      var ref =
          _firestore.collection("Posts/Gigs/Campaign Tasks").document(docID);
      ref.get().then((snapshot) {
        List<dynamic> list = List.from(snapshot.data['submittedBy']);
        int i = 0;
        for (i = 0; i < list.length; i++) {
          if (list[i]["userId"] == maps[0]["userId"]) {
            // print(maps[0]["userId"]);
            list[i]["UserStatus"] = value;
            print(list[i]);
            break;
          }
        }
        // print(list[0]);
        //if you need to update all positions of the array do a foreach instead of the next line
        list[i]["status"] = "approved";
        // list[i]["UserStatus"] = value;
        ref.updateData({'submittedBy': list}).catchError((e) {
          print(e);
        });
      });
      _onRefresh();
      Fluttertoast.showToast(msg: "User Completed the task!");
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 3;
      });

      setState(() {
        flag = false;
        numerator = maps[0]["UserStatus"];
        flag = true;
      });
      return;
    } else {
      var ref =
          _firestore.collection("Posts/Gigs/Campaign Tasks").document(docID);
      ref.get().then((snapshot) {
        List<dynamic> list = List.from(snapshot.data['submittedBy']);
        //if you need to update all positions of the array do a foreach instead of the next line
        int i = 0;
        for (i = 0; i < list.length; i++) {
          if (list[i]["userId"] == maps[0]["userId"]) {
            print(maps[0]["userId"]);
            list[i]["UserStatus"] = value;
            print(list[i]);
            break;
          }
        }
        ref.updateData({'submittedBy': list}).catchError((e) {
          print(e);
        });
      });
    }
    _onRefresh();
    Navigator.of(context).pop();
    setState(() {
      flag = false;
      numerator = maps[0]["UserStatus"];
      flag = true;
    });
    return;
  }

  init() async {
    List<DocumentSnapshot> snaps =
        await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
    List demos = [];
    for (DocumentSnapshot snap in snaps) {
      List applys = snap["submittedBy"];
      for (var r in applys) {
        if (r["status"] == "ongoing" &&
            r["emailId"] == widget.email &&
            r["taskTitle"] == widget.task &&
            r["companyName"] == widget.company) {
          demos.add(r);
          setState(() {
            docID = snap.documentID;
            flag = true;
          });
        }
      }
    }
    maps = demos;
    setState(() {
      numerator = maps[0]["UserStatus"];
    });
    print(maps.length);
    if (maps.isEmpty) {
      setState(() {
        flag = false;
      });
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      numerator = maps[0]["UserStatus"];
    });
    init();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      numerator = maps[0]["UserStatus"];
    });
    init();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    init();
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: flag
            ? Builder(
                builder: (context) => SmartRefresher(
                  controller: _refreshController,
                  header: WaterDropHeader(),
                  enablePullDown: true,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: maps.length == 0
                                  ? Center(
                                      child: Text("no data found"),
                                    )
                                  : Image.network(
                                      maps[0]["imgUri"],
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            Positioned(
                                top: MediaQuery.of(context).size.height * 0.5,
                                child: Container(
                                  color: Colors.black54,
                                  padding: EdgeInsets.all(7),
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.name,
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            widget.email,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            flag
                                                ? "$numerator/${maps[0]["maxStatus"]}"
                                                : "0/0",
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 22),
                                          ))
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(flag
                                  ? maps[0]["logoUri"]
                                  : "https://firebasestorage.googleapis.com/v0/b/markick-app.appspot.com/o/image%2Fdata%2Fuser%2F0%2Fcom.app.markboot%2Fcache%2Fimage_picker-1099861005.jpg?alt=media&token=ffcf1f07-d83f-464a-84de-e51cbebad370"),
                            ),
                            title: Text(flag
                                ? "${maps[0]["companyName"]}"
                                : "CompanyName"),
                            subtitle: Text(maps[0]["taskTitle"]),
                            trailing: RaisedButton(
                                color: Colors.deepOrange,
                                child: Text(
                                  "Change Status",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  return showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                          color: Colors.orange,
                                          height: 120,
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: status,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Enter New Status Value',
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              RaisedButton(
                                                color: Colors.blue,
                                                child: Text(
                                                  "Confirm",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  verify();
                                                },
                                              )
                                            ],
                                          )));
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SingleChildScrollView(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.4 -
                                  105,
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Reward ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text("Rs.${maps[0]["reward"]}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.deepOrange))
                                      ],
                                    ),
                                    Text(
                                      "Status:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${maps[0]["status"]}",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        RaisedButton.icon(
                                          onPressed: () {
                                            return showModalBottomSheet(
                                                context: context,
                                                builder: (context) => Container(
                                                    color: Colors.orange,
                                                    height: 120,
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          controller: link,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Enter New link',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        RaisedButton(
                                                          color: Colors.blue,
                                                          child: Text(
                                                            "Confirm",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            var ref = _firestore
                                                                .collection(
                                                                    "Posts/Gigs/Campaign Tasks")
                                                                .document(
                                                                    docID);
                                                            ref.get().then(
                                                                (snapshot) {
                                                              List<dynamic>
                                                                  list =
                                                                  List.from(snapshot
                                                                          .data[
                                                                      'submittedBy']);
                                                              list.forEach(
                                                                  (element) {
                                                                if (element["companyName"] ==
                                                                        widget
                                                                            .company &&
                                                                    element["emailId"] ==
                                                                        widget
                                                                            .email) {
                                                                  element["link"] =
                                                                      link.text
                                                                          .trim();
                                                                }
                                                              });
                                                              ref.updateData({
                                                                'submittedBy':
                                                                    list
                                                              }).catchError(
                                                                  (e) {
                                                                print(e);
                                                              });
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "link uploaded successfully");
                                                          },
                                                        )
                                                      ],
                                                    )));
                                          },
                                          icon: Icon(
                                            Icons.upload_rounded,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            "Upload Link",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: Colors.deepOrange,
                                        ),
                                        RaisedButton(
                                            onPressed: () {
                                              return showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Do you want to reject"),
                                                      actions: [
                                                        FlatButton(
                                                            onPressed: () {
                                                              var ref = _firestore
                                                                  .collection(
                                                                      "Posts/Gigs/Campaign Tasks")
                                                                  .document(
                                                                      docID);
                                                              ref.get().then(
                                                                  (snapshot) {
                                                                List<dynamic>
                                                                    list =
                                                                    List.from(snapshot
                                                                            .data[
                                                                        'submittedBy']);
                                                                list.forEach(
                                                                    (element) {
                                                                  if (element["companyName"] ==
                                                                          widget
                                                                              .company &&
                                                                      element["emailId"] ==
                                                                          widget
                                                                              .email) {
                                                                    element["status"] =
                                                                        "rejected";
                                                                  }
                                                                });
                                                                ref.updateData({
                                                                  'submittedBy':
                                                                      list
                                                                }).catchError(
                                                                    (e) {
                                                                  print(e);
                                                                });
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Campaign rejected Successfully");
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text("Confirm"))
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text("Reject",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            color: Colors.deepOrange),
                                      ],
                                    ),
                                    Text(
                                      "${maps[0]["link"]}",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
