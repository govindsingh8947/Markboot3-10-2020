import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class user_list extends StatefulWidget {
  List taskUserList;
  String reward;
  String docId;

  user_list({this.taskUserList, this.reward, this.docId});

  @override
  _user_listState createState() => _user_listState();
}

class _user_listState extends State<user_list> with WidgetsBindingObserver {
  Firestore _firestore = Firestore();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String _localPath;
  bool isShowDownloadBar = false;

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  init() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff051094),
          title: Text(
            "User List",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(CommonStyle().backgroundColor),
        body: widget.taskUserList.length > 0
            ? Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView.builder(
                    itemCount: widget.taskUserList.length,
                    itemBuilder: (context, index) {
                      print(widget.taskUserList[index]);
                      return taskUserCard(widget.taskUserList[index]);
                    }),
              )
            : Center(
                child: Container(
                  height: 30,
                  child: Text(
                    "No user found",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ));
  }

  Widget taskUserCard(Map<String, dynamic> userData) {
    if (userData["status"] != "applied") {
      return Container();
    }
    print(userData);
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xff051094)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[leftWidget(userData), rightWidget(userData)],
      ),
    );
  }

  Widget leftWidget(Map<String, dynamic> userData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            height: 50,
            child: Text(userData["taskTitle"] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            userData["name"] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            userData["emailId"] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            userData["phoneNo"] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget rightWidget(Map<String, dynamic> userData) {
    return Row(
      children: <Widget>[
        Container(
          height: 40,
          child: RaisedButton(
            onPressed: () {
              approvedAmount(userData["userId"], widget.reward,
                  userData["phoneNo"], userData);
            },
            child: Row(
              children: <Widget>[
                Text(userData["reward"] + "Rs." ?? ""),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Verify",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  approvedAmount(String userId, approveAmount, userPhoneNo, userData) async {
    _showMyDialog(userId, userData);
  }

  TextEditingController linkReferCode = TextEditingController();
  TextEditingController linkEnter = TextEditingController();

  Future<void> _showMyDialog(String userId, userData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do want to Accept that product?'),
                CommonWidget().commonTextField(
                  controller: linkReferCode,
                  hintText: "Enter the link",
                ),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ongoing"),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (linkReferCode.text.length != 0) {
                  for (var task in widget.taskUserList) {
                    if (task["userId"] == userId) {
                      print("Got it");
                      print(widget.taskUserList.indexOf(task));
                      var t = widget.taskUserList;
                      print(t);
                      Map<String, dynamic> updatedPost = {"submittedBy": t};
                      print(updatedPost);
                      if (linkReferCode.text.length >= 6) {
                        var db = _firestore
                            .collection("invitecodes")
                            .document(linkReferCode.text.toString());
                        await _firestore
                            .collection("invitecodes")
                            .document(linkReferCode.text.toString())
                            .get()
                            .then((value) async {
                          if (value.exists) {
                            Fluttertoast.showToast(
                                msg: 'This refer code is already taken');
                          } else {
                            CommonFunction().showProgressDialog(
                                isShowDialog: true, context: (context));
                            setState(() {
                              t[t.indexOf(task)]["status"] = "ongoing";
                              t[t.indexOf(task)]["link"] =
                                  linkReferCode.text.toString();
                            });
                            await _firestore
                                .collection("Posts")
                                .document("Gigs")
                                .collection("Campaign Tasks")
                                .document(widget.docId)
                                .setData(updatedPost, merge: true);
                            await db.setData({
                              "invitedBy": userId,
                              "invitedTo": [],
                              "referCode": linkReferCode.text.toString(),
                              "userEmail": userData["emailId"],
                              "userPhone": userData["phoneNo"],
                            });
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please enter correct code');
                      }
                    }
                  }
                } else {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Please enter refer code"),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
            ),
            FlatButton(
              child: Text('Rejected'),
              onPressed: () async {
                String phone;
                print("start");
                print(widget.taskUserList);
                for (var task in widget.taskUserList) {
                  if (task["userId"] == userId) {
                    print("Got it");
                    print(task);
                    print(widget.taskUserList.indexOf(task));
                    var t = widget.taskUserList;
                    setState(() {
                      t[t.indexOf(task)]["status"] = "rejected";
                      t[t.indexOf(task)]["link"] =
                          linkReferCode.text.toString();

                      phone = task["phoneNo"];
                    });
                    print(t);
                    Map<String, dynamic> updatedPost = {"submittedBy": t};
                    print(updatedPost);
                    await _firestore
                        .collection("Posts")
                        .document("Gigs")
                        .collection("Campaign Tasks")
                        .document(widget.docId)
                        .setData(updatedPost, merge: true);
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
