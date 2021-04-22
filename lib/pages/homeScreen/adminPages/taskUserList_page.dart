import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// This is the page for the Gigs Page tasks
class TaskUserListPage extends StatefulWidget {
  List taskUserList;
  String reward;
  String docId;
  TaskUserListPage({this.taskUserList, this.reward, this.docId});

  @override
  _TaskUserListPageState createState() => _TaskUserListPageState();
}

class _TaskUserListPageState extends State<TaskUserListPage>
    with WidgetsBindingObserver {
  Firestore _firestore = Firestore();

  String _localPath;
  bool isShowDownloadBar = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {});
    _refreshController.loadComplete();
  }

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
            ? SmartRefresher(
                enablePullDown: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: ListView.builder(
                      itemCount: widget.taskUserList.length,
                      itemBuilder: (context, index) {
                        return taskUserCard(widget.taskUserList[index]);
                      }),
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
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xff051094)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[leftWidget(userData), rightWidget(userData)],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            userData["user email"] ?? "",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget leftWidget(Map<String, dynamic> userData) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(userData["taskTitle"] ?? "",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(
            userData["name"] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            userData["emailId"] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            userData["phoneNo"] ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          userData["showUser1"] != null
              ? Text(
                  userData["showUser1"] ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              : Container(),
          userData["showUser1"] != null
              ? Text(
                  userData["showUser2"] ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget rightWidget(Map<String, dynamic> userData) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 50,
          child: RaisedButton(
            onPressed: () {
              approvedAmount(userData["userId"], widget.reward,
                  userData["phoneNo"], userData);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(userData["reward"] + "Rs." ?? ""),
                Text(
                  "Verify",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        ),
        Container(
            child: IconButton(
          onPressed: () {
            downloadTaskImg(userData["uploadWorkUri"]);
          },
          icon: Icon(
            Icons.file_download,
            size: 20,
            color: Colors.white,
          ),
        ))
      ],
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
                  width: 100,
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

  Future<void> downloadTaskImg(imgUri) async {
    try {
      isShowDownloadBar = true;
      showDownloadingBar();
      // Saved with this method.
      final taskId = await FlutterDownloader.enqueue(
        url: imgUri,
        savedDir: _localPath,
        showNotification:
            true, // show download progress in status bar (for Android)
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

  Future<void> _showMyDialog(String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog'),
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
              child: Text("Approved"),
              onPressed: () async {
                //_pending_approved(userId);
                // Navigator.pop(context);
                for (var task in widget.taskUserList) {
                  // print(userId);
                  if (task["userId"] == userId) {
                    print("Got it");
                    print(widget.taskUserList.indexOf(task));
                    var t = widget.taskUserList;
                    setState(() {
                      t[t.indexOf(task)]["status"] = "approved";
                    });
                    print(t);
                    Map<String, dynamic> updatedPost = {"submittedBy": t};
                    await _firestore
                        .collection("Posts")
                        .document("Gigs")
                        .collection("Tasks")
                        .document(widget.docId)
                        .setData(updatedPost, merge: true);

                    var c = await CommonFunction().getPost("Users");
                    print(c);
                    for (DocumentSnapshot docx in c) {
                      print(
                          "Inside here ---------------------------------------");
                      if (t[t.indexOf(task)]["phoneNo"].toString() ==
                          docx.documentID.toString()) {
                        print(docx.data);
                        print("in here ");
                        Map<String, dynamic> userData = docx.data;
                        int approvedAmountCustom = 0;

                        // This is where the problem lied the type stored in the database was integer but then here it was assigned as String
                        // so I changed it
                        approvedAmountCustom =
                            approvedAmountCustom = userData["approvedAmount"];
                        approvedAmountCustom +=
                            int.parse(t[t.indexOf(task)]["reward"]);
                        //approvedAmountCustom = (int.parse(userData["approvedAmount"] ?? "0") + ;
                        userData["approvedAmount"] = approvedAmountCustom;
                        print(approvedAmountCustom);

                        await _firestore
                            .collection("Users")
                            .document(t[t.indexOf(task)]["phoneNo"])
                            .setData(userData, merge: true);
                      }
                    }
                  }
                }
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Pending"),
              onPressed: () async {
                // _pending_approved(userId);
                // Navigator.pop(context);
                for (var task in widget.taskUserList) {
                  if (task["userId"] == userId) {
                    print("Got it");
                    print(widget.taskUserList.indexOf(task));
                    var t = widget.taskUserList;
                    setState(() {
                      t[t.indexOf(task)]["status"] = "pending";
                    });
                    print(t);
                    Map<String, dynamic> updatedPost = {"submittedBy": t};
                    await _firestore
                        .collection("Posts")
                        .document("Gigs")
                        .collection("Tasks")
                        .document(widget.docId)
                        .setData(updatedPost, merge: true);
                    print("Users/${t[t.indexOf(task)]["phoneNo"]}");
                    var c = await CommonFunction().getPost("Users");
                    print(c);
                    for (DocumentSnapshot docx in c) {
                      if (t[t.indexOf(task)]["phoneNo"].toString() ==
                          docx.documentID.toString()) {
                        print(docx.data);
                        Map<String, dynamic> userData = docx.data;
                        int pendingAmountCustom;
                        pendingAmountCustom = userData["pendingAmount"];
                        pendingAmountCustom +=
                            int.parse(t[t.indexOf(task)]["reward"]);
                        //approvedAmountCustom += int.parse(t[t.indexOf(task)]["reward"]);
                        userData["pendingAmount"] = pendingAmountCustom;

                        await _firestore
                            .collection("Users")
                            .document(t[t.indexOf(task)]["phoneNo"])
                            .setData(userData, merge: true);
////
                      }
                    }
                  }
                }
                Navigator.of(context).pop();
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
                      phone = task["phoneNo"];
                    });
                    print(t);
                    Map<String, dynamic> updatedPost = {"submittedBy": t};
                    await _firestore
                        .collection("Posts")
                        .document("Gigs")
                        .collection("Tasks")
                        .document(widget.docId)
                        .setData(updatedPost, merge: true);
                  }
                }
//
                print(phone);
                DocumentSnapshot snapshot = await Firestore.instance
                    .collection("Users")
                    .document(phone)
                    .get();
                if (snapshot != null) {
                  Map appliedInternshipList =
                      snapshot.data["pendingTasks"] ?? Map();
                  debugPrint("LLn $appliedInternshipList ${widget.docId}");
                  // appliedInternshipList[widget.docId] = true;
                  appliedInternshipList.remove(widget.docId);
                  snapshot.data["pendingTask"] = appliedInternshipList;
                  debugPrint("LLIUUUSSSTT ${snapshot.data}");
                  print(appliedInternshipList);
                  await Firestore.instance
                      .collection("Users")
                      .document(phone)
                      .setData({"pendingTasks": appliedInternshipList},
                          merge: true);
                }
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
