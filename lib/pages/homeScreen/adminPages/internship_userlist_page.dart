import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternshipUserListPage extends StatefulWidget {
  List internshipUserList;
  String docId;

  InternshipUserListPage({this.internshipUserList, this.docId});

  @override
  _InternshipUserListPageState createState() => _InternshipUserListPageState();
}

class _InternshipUserListPageState extends State<InternshipUserListPage>
    with WidgetsBindingObserver {
  String _localPath;
  bool isShowDownloadBar = false;
  String phoneNo;
  SharedPreferences prefs;

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString("userPhoneNo") ?? "";
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
        appBar: AppBar(
          backgroundColor: Color(0xff051094),
          title: Text(
            "User List",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(CommonStyle().backgroundColor),
        body: widget.internshipUserList.length > 0
            ? Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView.builder(
                  itemCount: widget.internshipUserList.length,
                  itemBuilder: (context, index) {
                    return taskUserCard(widget.internshipUserList[index]);
                  },
                ),
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
    return Container(
      // height: 100,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xff051094)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[leftWidget(userData), rightWidget(userData)],
          ),
          Text(
            userData["user email"] ?? "",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget leftWidget(Map<String, dynamic> userData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * .60,
          height: MediaQuery.of(context).size.height * 0.055,
          child: Text(
            userData["taskTitle"] ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          userData["name"] ?? "",
          style: TextStyle(color: Colors.white, fontSize: 18),
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
    );
  }

  Widget rightWidget(Map<String, dynamic> userData) {
    return GestureDetector(
      onTap: () {
        debugPrint("TAP verify");
      },
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
              width: 110,
              height: 40,
              child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    // debugPrint("VVVV ${userData["isVerify"]}");
                    if (!(userData["isVerify"] == true ? true : false) ??
                        false) {
//                internshipService(userData);
//                       debugPrint("UUUUSSEERRDATA $userData");
                      downloadTaskImg(userData["resumeUri"] ?? "",
                          userData["phoneNo"] ?? "");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Resume",
                        style: TextStyle(
                            color: (userData["isVerify"] == true
                                    ? Colors.green
                                    : Colors.red) ??
                                Colors.red,
                            fontSize: 15),
                      ),
                      Icon(
                        Icons.file_download,
                        size: 18,
                      ),
                    ],
                  ))),
          SizedBox(height: 20),
          Container(
              width: 110,
              height: 40,
              child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    //debugPrint("VVVV ${userData["isVerify"] }");
                    //if(!(userData["isVerify"] ==true? true : false) ?? false){
//                internshipService(userData);
                    //   debugPrint("UUUUSSEERRDATA $userData");
                    //    downloadTaskImg(userData["resumeUri"] ?? "",userData["phoneNo"]??"");

                    _showMyDialog(userData);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Verify",
                        style: TextStyle(
                            color: (userData["isVerify"] == true
                                    ? Colors.green
                                    : Colors.red) ??
                                Colors.red,
                            fontSize: 15),
                      ),
                      Icon(CupertinoIcons.check_mark_circled),
                    ],
                  ))),
        ],
      ),
    );
  }

  showDownloadingBar() async {
    if (isShowDownloadBar == true) {
      return showDialog(
          context: context,
          builder: (context) {
            return Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Downloading...",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> downloadTaskImg(imgUri, phoneNo) async {
    try {
      debugPrint("IIMMGG URI ${imgUri}");
      if (imgUri == null) return;
      isShowDownloadBar = true;
      showDownloadingBar();
      // Saved with this method.
      final taskId = await FlutterDownloader.enqueue(
        fileName: "Resume_$phoneNo",
        url: imgUri,
        savedDir: _localPath,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
      if (taskId != null && taskId.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "Download successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Download failed",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    } on PlatformException catch (error) {
      print(error);
    }
    isShowDownloadBar = false;
    showDownloadingBar();
  }

  Future<void> internshipService(clickUserData) async {
    try {
      debugPrint("CALL INTERNSHIP");
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      List localList = widget.internshipUserList;
      int index = 0;
      for (var item in localList) {
        if (item["phoneNo"] == clickUserData["phoneNo"]) {
          item["isVerify"] = true;
          widget.internshipUserList[index] = item;
          break;
        }
        index++;
      }
      Firestore.instance
          .collection("Posts")
          .document("Internship")
          .collection("Internship")
          .document(widget.docId)
          .setData({"appliedBy": widget.internshipUserList}, merge: true);
      debugPrint("PHONE $phoneNo");
      String userPhoneNo = clickUserData["phoneNo"];
      DocumentSnapshot snapshot = await Firestore.instance
          .collection("Users")
          .document(userPhoneNo)
          .get();
      if (snapshot != null) {
        Map appliedInternshipList = snapshot.data["internshipList"] ?? Map();
        debugPrint("LLn $appliedInternshipList ${widget.docId}");
        appliedInternshipList[widget.docId] = true;
        snapshot.data["internshipList"] = appliedInternshipList;
        debugPrint("LLIUUUSSSTT ${snapshot.data}");
        await Firestore.instance
            .collection("Users")
            .document(phoneNo)
            .setData({"internshipList": appliedInternshipList}, merge: true);
      }
    } catch (e) {
      debugPrint("Exception : (InternshipService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  Firestore _firestore = Firestore();

  Future<void> _showMyDialog(var userData) async {
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
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('accepted'),
              onPressed: () async {
                //_pending_approved(userId);
                // Navigator.pop(context);

                List m = widget.internshipUserList;
                print(m.indexOf(userData));
                setState(() {
                  m[m.indexOf(userData)]["status"] = "accepted";
                });
                Map<String, dynamic> updatedPost = {"appliedBy": m};
                print(updatedPost);
                print(widget.docId);
                await _firestore
                    .collection("Posts")
                    .document("Internship")
                    .collection("Tasks")
                    .document(widget.docId)
                    .setData(updatedPost, merge: true);
                List<DocumentSnapshot> users =
                    await CommonFunction().getPost("Users");
                var use;
                for (var user in users) {
                  if (user.documentID == userData["phoneNo"]) {
                    print(user.data);

                    var u = user.data;
                    var interns = u["internshipList"];
                    setState(() {
                      interns.remove(widget.docId);
                      print(interns);

                      u["internshipList"] = interns;

                      print(u);
                      use = u;
                    });
                    break;
                  }
                }
                print(userData["phoneNo"]);
                await _firestore
                    .collection("Users")
                    .document(userData["phoneNo"])
                    .setData(use, merge: true);

                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('rejected'),
              onPressed: () async {
//                print(userData);
//                print(widget.internshipUserList);

                List m = widget.internshipUserList;
                print(m.indexOf(userData));
                setState(() {
                  m[m.indexOf(userData)]["status"] = "rejected";
                });
                Map<String, dynamic> updatedPost = {"appliedBy": m};
                print(updatedPost);
                print(widget.docId);
                await _firestore
                    .collection("Posts")
                    .document("Internship")
                    .collection("Tasks")
                    .document(widget.docId)
                    .setData(updatedPost, merge: true);
                List<DocumentSnapshot> users =
                    await CommonFunction().getPost("Users");
                var use;
                for (var user in users) {
                  if (user.documentID == userData["phoneNo"]) {
                    print(user.data);

                    var u = user.data;
                    var interns = u["internshipList"];
                    setState(() {
                      interns.remove(widget.docId);
                      print(interns);

                      u["internshipList"] = interns;

                      print(u);
                      use = u;
                    });
                    break;
                  }
                }
                print(userData["phoneNo"]);
                await _firestore
                    .collection("Users")
                    .document(userData["phoneNo"])
                    .setData(use, merge: true);

                Navigator.pop(context);

                // print(widget.taskUserList);
//                for(var task in widget.taskUserList){
//                  if(task["userId"]==userId){
//                    print("Got it");
//                    print(widget.taskUserList.indexOf(task));
//                    var t=widget.taskUserList;
//                    setState(() {
//                      t[t.indexOf(task)]["status"]="rejected";
//
//                    });
//                    print(t);
//                    Map<String,dynamic> updatedPost = {
//                      "submittedBy" : t
//                    };
//                    await _firestore.collection("Posts").document("Gigs").collection("Tasks").document(widget.docId)
//                        .setData(updatedPost,merge: true);
//
//                  }
//                }
//                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
