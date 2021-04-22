import 'dart:io';
import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentAdminDetailsPage extends StatefulWidget {
  List taskUserList;
  String docId;
  TournamentAdminDetailsPage({this.taskUserList, this.docId});

  @override
  _TournamentAdminDetailsPageState createState() =>
      _TournamentAdminDetailsPageState();
}

class _TournamentAdminDetailsPageState extends State<TournamentAdminDetailsPage>
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              color: Color(0xff051094),
              margin: EdgeInsets.only(top: 30, left: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                  Text(
                    "User List",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )),
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
    return Container(
      height: 100,
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
          Text(
            userData["name"] ?? "",
            style: TextStyle(color: Colors.green, fontSize: 18),
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
    return GestureDetector(
      onTap: () {
        debugPrint("TAP verify");
      },
      child: Container(
          width: 150,
          height: 30,
          child: RaisedButton(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: () {
              debugPrint("VVVV ${userData["isVerify"]}");
              if (!(userData["isVerify"] == true ? true : false) ?? false) {
//                internshipService(userData);
                showAnswerDialog(userData["data"]);
              }
            },
            child: Text(
              "Check Answer",
              style: TextStyle(
                  color: (userData["isVerify"] == true
                          ? Colors.green
                          : Colors.red) ??
                      Colors.red,
                  fontSize: 15),
            ),
          )),
    );
  }

  showAnswerDialog(qustionList) async {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${index + 1}. ${qustionList[index]["question"]}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                'Ans. ${qustionList[index]["answer"]}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )
                            ],
                          );
                        },
                        itemCount: qustionList.length,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Color(CommonStyle().blueCardColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              )),
            ),
          );
        });
  }
}
