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

class ongoing extends StatefulWidget {
  ongoing();

  @override
  _ongoingState createState() => _ongoingState();
}

class _ongoingState extends State<ongoing> with WidgetsBindingObserver {
  Firestore _firestore = Firestore();

  String _localPath;
  bool isShowDownloadBar = false;

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  List maps = [];
  init() async {
    List<DocumentSnapshot> snaps =
        await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
    List demos = [];

    for (DocumentSnapshot snap in snaps) {
      List applys = snap["submittedBy"];
      // print(applys);
      for (var r in applys) {
        if (r["status"] == "ongoing") {
          demos.add(r);
        }
      }
    }

    setState(() {
      maps = demos;
    });
    print(maps.length);
  }

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return maps.length > 0
        ? Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: ListView.builder(
                itemCount: maps.length,
                itemBuilder: (context, index) {
                  return taskUserCard(maps[index]);
                }),
          )
        : Center(
            child: Container(
              height: 30,
              child: Text(
                "No user found",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          );
  }

  Widget taskUserCard(Map<String, dynamic> userData) {
    // if (userData["status"] != "applied") {
    //   return Text("");
    // }
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
        children: <Widget>[
          leftWidget(userData),
        ],
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
      ),
    );
  }
}
