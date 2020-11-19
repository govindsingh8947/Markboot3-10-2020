import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(CommonStyle().backgroundColor),
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
      return Text("");
    }
    print(userData);
    return Container(
      //height: 100,
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
            width: MediaQuery.of(context).size.width*0.55,
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
        // Container(
        //     child: IconButton(
        //   onPressed: () {
        //     downloadTaskImg(userData["uploadWorkUri"]);
        //   },
        //   icon: Icon(
        //     Icons.file_download,
        //     size: 20,
        //     color: Colors.white,
        //   ),
        // ))
      ],
    );
  }

  approvedAmount(String userId, approveAmount, userPhoneNo, userData) async {
    _showMyDialog(userId);

    //    debugPrint("DOCID ${widget.docId}");
//
//    try{
//      bool isApproved= false;
//     QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
//     DocumentSnapshot userDocumentSnapshot;
//
//     if(querySnapshot!=null) {
//       for(DocumentSnapshot snapshot in querySnapshot.documents){
//         if(snapshot.data["userId"] == userId) {
//           userDocumentSnapshot = snapshot;
//           break;
//         }
//       }
//
//       if(userDocumentSnapshot !=null){
//         String pendingAmount = userDocumentSnapshot.data["pendingAmount"]??"0";
//         debugPrint("PendingAmount : $pendingAmount");
//         String approvedAmount = userDocumentSnapshot.data["approvedAmount"]??"0";
//         if(int.parse(pendingAmount) > 0) {
//           pendingAmount = (int.parse(pendingAmount)-int.parse(approvedAmount)).toString();
//           approvedAmount = (int.parse(approvedAmount)+int.parse(approveAmount)).toString();
//           debugPrint("RemainPendingAmount $pendingAmount");
//           -if(int.parse(pendingAmount)<0){
//              Fluttertoast.showToast(msg: "try again or contact to admin",
//              backgroundColor: Colors.red,textColor: Colors.white
//              );
//           }
//           else {
//             isApproved = true;
//             Firestore.instance.collection("Users").document(userPhoneNo).setData({
//               "approvedAmount" : approvedAmount,
//               "pendingAmount" : pendingAmount
//             },
//                 merge: true
//             );
//           }
//           if(isApproved == true) {
//             widget.taskUserList.remove(userData);
//             Firestore.instance.collection("Posts").document("Gigs").collection("Tasks").document(widget.docId).
//    setData({
//               "submittedBy" : widget.taskUserList
//             },
//             merge: true
//             );
//             Fluttertoast.showToast(msg: "approved successfully",
//             backgroundColor: Colors.green,textColor: Colors.white
//             );
//             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//               builder: (context)=>AdminHomePage()
//             ), (route) => false);
//           }
//         }
//         else {
//           Fluttertoast.showToast(msg: "please contact to admin or try again",
//           backgroundColor: Colors.red,textColor: Colors.white
//           );
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: "Getting some error,try again or contact to admin",
//         textColor: Colors.white,backgroundColor: Colors.red
//         );
//       }
//     }
//
//
//    }
//    catch(e) {
//      print(e);
//      Fluttertoast.showToast(msg: "Please try again",
//      backgroundColor: Colors.red,
//        textColor: Colors.white
//      );
//    }
  }

  TextEditingController link = TextEditingController();

  Future<void> _showMyDialog(String userId) async {
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
                  controller: link,
                  hintText: "Enter the link",
                )
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ongoing"),
              onPressed: () async {
                for (var task in widget.taskUserList) {
                  if (task["userId"] == userId) {
                    print("Got it");
                    print(widget.taskUserList.indexOf(task));
                    var t = widget.taskUserList;
                    setState(() {
                      t[t.indexOf(task)]["status"] = "ongoing";
                      t[t.indexOf(task)]["link"] = link.text.toString();
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
                Navigator.pop(context);
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
                      t[t.indexOf(task)]["link"] = link.text.toString();

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
//

//

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
