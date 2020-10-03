import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Flexible(
//child: Image.network("https://www.payscale.com/wp-content/uploads/2019/05/QuitYou_HP.jpg",
//fit: BoxFit.cover,
//),
//),

class OffersPageDetails extends StatefulWidget {
  DocumentSnapshot snapshot;
  String type;
  String subType;
  OffersPageDetails({@required this.snapshot, this.type, this.subType});
  @override
  _OffersPageDetailsState createState() => _OffersPageDetailsState();
}

class _OffersPageDetailsState extends State<OffersPageDetails> {
  Firestore _firestore = Firestore();
  String phoneNo;
  SharedPreferences prefs;
  Map<String, dynamic> pendingPost;
  Map<String, dynamic> userData;
  bool isApplied = false;
  List<String> pendingPostList;
  List<int> textColors = [0xff00E676, 0xffEEFF41, 0xffE0E0E0, 0xffffffff];
  List<int> colors = [
    0xff11232D,
    0xff1C2D41,
    0Xff343A4D,
    0xff4F4641,
    0xff434343,
    0xff2A2A28
  ];
  Random random = Random();

  Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      pendingPostList =
          prefs.getStringList("pendingPost") ?? new List<String>();
      if (pendingPostList.contains(widget.snapshot.documentID.toString())) {
        isApplied = true;
        setState(() {});
      }
      phoneNo = prefs.getString("userPhoneNo") ?? "";
      DocumentSnapshot snapshot =
          await _firestore.collection("Users").document(phoneNo).get();
      userData = snapshot.data;
      debugPrint("DATA $userData");
      pendingPost = userData["post"] ?? new Map<String, dynamic>();
    } catch (e) {
      debugPrint("Exception: (Init) -> $e");
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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Colors.transparent,
                stretch: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.70,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: "img",
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.snapshot["imgUri"]))),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 50,
                          top: 80,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.snapshot["taskTitle"] ?? "",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Color(textColors[random.nextInt(4)])),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(widget.snapshot["logoUri"]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.snapshot["companyName"] ?? "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color(textColors[random.nextInt(4)])),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    placeholderBuilder: (context, size, widget) {
                      return Container(
                        height: 150.0,
                        width: 150.0,
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )),
            SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          "TASK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          widget.snapshot["taskDesc"],
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                      Visibility(
                          visible:
                              widget.type.toLowerCase().contains("campaign") ??
                                  false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text(
                                  "TARGET",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.snapshot["target"] ?? "",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Text(
                          "REWARD",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/bank.png",
                                width: 15,
                                height: 15,
                              ),
                              Text(
                                widget.snapshot["reward"] ?? "",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.green),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible:
                            widget.subType.toLowerCase().contains("task") ??
                                false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  onPressed: () {},
                                  child: Text(
                                    "Visit Website",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(CommonStyle().blueColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  onPressed: () {
                                    applyPostService();
                                  },
                                  child: Text(
                                    isApplied == false ? "Apply" : "Pending",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            widget.subType.toLowerCase().contains("campaign") ??
                                false,
                        child: Expanded(
                          child: Container(
                            height: 50,
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {},
                              child: Text(
                                "REQUEST ACEESS",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }

  Widget bottomButton(context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {},
                child: Text(
                  "Visit Website",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 50,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/icons/list.png"))),
    );
  }

  Future<void> applyPostService() async {
    try {
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      pendingPost[widget.snapshot.documentID] = false;
      userData["post"] = pendingPost;

      await _firestore
          .collection("Users")
          .document(phoneNo)
          .setData(userData, merge: true)
          .whenComplete(() {
        isApplied = true;
        pendingPostList.add(widget.snapshot.documentID.toString());
        prefs.setStringList("pendingPost", pendingPostList);
        setState(() {});
        Fluttertoast.showToast(
            msg: "Applied successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }).timeout(Duration(seconds: 5), onTimeout: () {
        Fluttertoast.showToast(
            msg: "please try again.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "getting some error",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      });
    } catch (e) {
      debugPrint("Exception : (applyPostService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }
}
