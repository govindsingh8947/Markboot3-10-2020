import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//Flexible(
//child: Image.network("https://www.payscale.com/wp-content/uploads/2019/05/QuitYou_HP.jpg",
//fit: BoxFit.cover,
//),
//),

class CashbacksPageDetails extends StatefulWidget {
  DocumentSnapshot snapshot;
  String type;
  String subType;
  CashbacksPageDetails({@required this.snapshot, this.type, this.subType});
  @override
  _CashbacksPageDetailsState createState() => _CashbacksPageDetailsState();
}

class _CashbacksPageDetailsState extends State<CashbacksPageDetails>
    with TickerProviderStateMixin {
  Firestore _firestore = Firestore();
  String phoneNo;
  SharedPreferences prefs;
  Map<String, dynamic> pendingPost;
  Map<String, dynamic> userData;
  bool isApplied = false;
  File _workedImgFile;
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
  Timer timer;
  bool isShowWebsiteUrl = false;
  TextEditingController collegeNameCont = TextEditingController();
  List<String> offersListPrefs = new List<String>();

  final picker = ImagePicker();
  Map<String, dynamic> offersListDB = new Map();
  // Animation
  AnimationController animationController;
  AnimationController submitAnimCont;
  Animation animation;
  Animation submitAnim;
  String name, emailId, userId;

  String status;
  Color col;
  Future<void> init() async {
    try {
      debugPrint("COUPONS ${widget.subType}");
      print("Posts/${widget.type}/${widget.subType}");

      prefs = await SharedPreferences.getInstance();
      name = prefs.getString("userName");
      phoneNo = prefs.getString("userPhoneNo");
      emailId = prefs.getString("userEmailId");
      userId = prefs.getString("userId");
      // offersListPrefs = prefs.getStringList("offersList") ?? new List<String>();
      // if (offersListPrefs.contains(widget.snapshot.documentID.toString())) {
      //   isApplied = true;
      //   setState(() {});
      // }

      List tasks = await CommonFunction().getPost("Posts/${widget.type}/Tasks");
      print("Tasks =${tasks}");
      for (DocumentSnapshot doc in tasks) {
        print(doc.documentID);
        print(widget.snapshot.documentID);
        if (widget.snapshot.documentID == doc.documentID) {
          List users = doc.data["submittedBy"];
          print("GOt it");
          print(users);
          for (var user in users) {
            // print(user["userId"]);

            if (name == user["name"]) {
              print("user find");
              print(name);
              print(user["name"]);
              isApplied = true;
              status = user["status"];
              print(status);
              if (status == "applied") {
                status = "Submitted";
                col = Color(0xff051094);
              } else if (status == "rejected") {
                status = "Rejected";
                col = Colors.red;
              } else {
                status = "Accepted";
                col = Colors.green;
              }
            }
          }
        }
      }

      print(isApplied);
      print(status);

      // phoneNo = prefs.getString("userPhoneNo") ?? "";
      // DocumentSnapshot snapshot =
      //     await _firestore.collection("Users").document(phoneNo).get();
      // userData = snapshot.data;
      // debugPrint("DATA $userData");
      // offersListDB = userData["offersList"] ?? new Map<String, dynamic>();
      // if (offersListDB.containsKey(widget.snapshot.documentID)) {
      //   isApplied == true;
      // }
    } catch (e) {
      debugPrint("Exception: (Init) -> $e");
    }
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
    submitAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    submitAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: submitAnimCont, curve: Curves.ease))
          ..addListener(() {
            setState(() {});
          });
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              if (animationController.isCompleted) {
                animationController.reverse().then((value) {
                  isShowWebsiteUrl = false;
                });

                return false;
              } else if (submitAnimCont.isCompleted) {
                submitAnimCont.reverse().then((value) {});

                return false;
              }
              return true;
            },
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    animationController.reverse().then((value) {
                      isShowWebsiteUrl = false;
                    });

                    if (submitAnimCont.isCompleted) {
                      submitAnimCont.reverse();
                    }
                  },
                  child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Stack(
                        children: <Widget>[
                          CustomScrollView(
                            slivers: <Widget>[
                              SliverAppBar(
                                  backgroundColor: Colors.transparent,
                                  stretch: true,
                                  expandedHeight:
                                      MediaQuery.of(context).size.height * 0.70,
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: Hero(
                                      tag: "img",
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white38,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    widget.snapshot["imgUri"]))),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            right: 50,
                                            top: 50,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(widget.snapshot["taskTitle"]??"",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: NetworkImage(
                                                        widget
                                                            .snapshot["logoUri"]),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(widget.snapshot["companyName"]??"",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      placeholderBuilder:
                                          (context, size, widget) {
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
                                        Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Title",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      // color: Color(
                                                      //     CommonStyle().lightYellowColor),
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  widget.snapshot["taskTitle"] ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      //     color: Color(0xff051094)),
                                                      color: Colors.black54),
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Company Name",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      // color: Color(
                                                      //     CommonStyle().lightYellowColor),
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  widget.snapshot[
                                                          "companyName"] ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      //     color: Color(0xff051094)),
                                                      color: Colors.black54),
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: singleItem("Description",
                                                  widget.snapshot["taskDesc"],
                                                  crossAlign:
                                                      CrossAxisAlignment.start),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: SizedBox(
                                            height: 10,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: singleItem(
                                                    "Instruction",
                                                    widget
                                                        .snapshot["instruction"],
                                                    crossAlign:
                                                        CrossAxisAlignment.start))
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),
                                        Visibility(
                                          visible: !widget.subType
                                                  .toLowerCase()
                                                  .toString()
                                                  .contains("coupons") ??
                                              false,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 30),
                                                  child: Text(
                                                    "MarkBoot Cashback",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        // color:
                                                        //     Color(CommonStyle().lightYellowColor),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Image.asset(
                                                          "assets/icons/bank.png",
                                                          width: 15,
                                                          height: 15,
                                                          color:
                                                              Color(0xff051094),
                                                        ),
                                                        Text(
                                                          widget.snapshot[
                                                                  "cashbackAmount"] ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0xff051094)),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          //  height: 50,
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                    //   height: 50,
                                                    child: widget.subType
                                                                .toLowerCase()
                                                                .toString()
                                                                .contains(
                                                                    "coupons") ==
                                                            false
                                                        ? isApplied == true
                                                            ? Container(
                                                                //margin: EdgeInsets.only(top: 8),
                                                                child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Divider(
                                                                    thickness: 5,
                                                                  ),
                                                                  Text(
                                                                    "Status",
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        // color: Color(
                                                                        //     CommonStyle().lightYellowColor),
                                                                        color: Colors.black),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    status,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        //     color: Color(0xff051094)),
                                                                        color: col),
                                                                  )
                                                                ],
                                                              ))
                                                            : RaisedButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8)),
                                                                color: Color(
                                                                    0xff051094),
                                                                onPressed:
                                                                    isApplied ==
                                                                            true
                                                                        ? null
                                                                        : () {
                                                                            _launchURL(widget.snapshot["link"] ??
                                                                                "");

                                                                            // if (animationController
                                                                            //     .isCompleted) {
                                                                            //   animationController.reverse().then((value) {
                                                                            //     isShowWebsiteUrl = false;
                                                                            //   });
                                                                            // } else {
                                                                            //   timer =
                                                                            //       Timer(Duration(seconds: 3), () {
                                                                            //     isShowWebsiteUrl = true;
                                                                            //     setState(() {});
                                                                            //   });
                                                                            //   animationController.forward();
                                                                            // }
                                                                          },
                                                                child: Text(
                                                                  "Grab Deal",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )
                                                        : RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            color:
                                                                Colors.blueAccent,
                                                            onPressed:
                                                                isApplied == true
                                                                    ? null
                                                                    : () {
                                                                        _launchURL(
                                                                            widget.snapshot["link"] ??
                                                                                "");
                                                                      },
                                                            child: Text(
                                                              "AVAIL OFFER",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
//                                          Expanded(
//                                            child: Container(
//                                                width: double.infinity,
//                                                height: 50,
//                                                child: RaisedButton(
//                                                  shape: RoundedRectangleBorder(
//                                                      borderRadius: BorderRadius.circular(8)
//                                                  ),
//                                                  color: Colors.blueAccent,
//                                                  onPressed: (){
//                                                    if(isApplied == false) {
//                                                      if(submitAnimCont.isCompleted) {
//                                                        submitAnimCont.reverse();
//                                                      }
//                                                      else{
//                                                        submitAnimCont.forward();
//                                                      }
//                                                    }
//                                                  },
//                                                  child: Text(isApplied ==true ? "Submitted" : "SUBMIT",
//                                                    style: TextStyle(
//                                                        color: Colors.white
//                                                    ),
//                                                  ),
//                                                )),
//                                          ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: animation != null
                                  ? MediaQuery.of(context).size.height *
                                      0.25 *
                                      animation.value
                                  : 0,
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: animation != null
                                        ? 20 * animation?.value
                                        : 0,
                                  ),
                                  Visibility(
                                    visible: !(isShowWebsiteUrl ?? false),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: animation != null
                                        ? 30 * animation?.value
                                        : 0,
                                  ),
                                  Visibility(
                                    visible: isShowWebsiteUrl ?? false,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 60),
                                      height: 50 * animation.value,
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        color: Color(CommonStyle().blueColor),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        onPressed: () {
                                          debugPrint("Pressed");
                                          _launchURL(widget.snapshot["link"] ??
                                              "www.google.com");
                                        },
                                        child: Text(
                                          "Visit Website",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                Positioned(
                  bottom: 0,
                  child: Material(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: submitAnim != null
                          ? MediaQuery.of(context).size.height *
                              0.5 *
                              submitAnim.value
                          : 0,
                      color: Colors.white,
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height:
                                submitAnim != null ? 50 * submitAnim?.value : 0,
                          ),
                          Container(
                            height:
                                submitAnim != null ? 50 * submitAnim?.value : 0,
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: TextField(
                              controller: collegeNameCont,
                              onTap: () {},
                              decoration: InputDecoration(hintText: "Order Id"),
                            ),
                          ),
                          SizedBox(
                            height:
                                submitAnim != null ? 20 * submitAnim?.value : 0,
                          ),
                          GestureDetector(
                              onTap: () {
                                showPickImageDialog(_workedImgFile);
                              },
                              child: showCamera(_workedImgFile)),
                          SizedBox(
                            height:
                                submitAnim != null ? 40 * submitAnim.value : 0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            height: 50 * submitAnim.value,
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Color(CommonStyle().blueColor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: () {
                                debugPrint("Pressed");
                                FocusScope.of(context).unfocus();
                                if (collegeNameCont.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Enter college name",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                  return;
                                } else {
                                  applyPostService();
                                }
                              },
                              child: Text(
                                "Submit",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
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

  Widget singleItem(title, desc, {crossAlign = CrossAxisAlignment.center}) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // color: Color(
                  //     CommonStyle().lightYellowColor),
                  color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              desc,
              style: TextStyle(
                  fontSize: 15,
                  //     color: Color(0xff051094)),
                  color: Colors.black54),
            )
          ],
        ));
  }

  Widget showCamera(fileImg) {
    return Center(
        child: fileImg == null
            ? Container(
                width: 100,
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      "assets/icons/camera.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    )),
              )
            : Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white38)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      fileImg,
                      fit: BoxFit.fill,
                    )),
              ));
  }

  showPickImageDialog(showfileImg) {
    return showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(CommonStyle().blueColor),
                    borderRadius: BorderRadius.circular(10)),
                height: 260,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        pickImageGallery(showfileImg);
                      },
                      child: Text("Gallery"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        pickImageCamera(showfileImg);
                      },
                      child: Text("Camera"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  pickImageGallery(pickFileImg) async {
    try {
      final pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 30);

      setState(() {
        _workedImgFile = File(pickedFile.path);
      });
    } catch (e) {
      debugPrint("Exception : (pickImage) -> $e");
    }
  }

  pickImageCamera(showfileImg) async {
    try {
      final pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 30);

      setState(() {
        _workedImgFile = File(pickedFile.path);
      });
    } catch (e) {
      debugPrint("Exception : (pickImage) -> $e");
    }
  }

  _launchURL(url) async {
    if (!url.contains("http")) {
      url = "https://" + url;
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> applyPostService() async {
    try {
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);

      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("Posts")
          .document(widget.type)
          .collection(widget.subType)
          .getDocuments();
      DocumentSnapshot localSnapshot;

      for (DocumentSnapshot snapshot in querySnapshot.documents) {
        if (snapshot.documentID == widget.snapshot.documentID) {
          localSnapshot = snapshot;
        }
      }

      String workedImgFileUri = await uploadToStorage(_workedImgFile);
      debugPrint("IIIIIIIIIIIIIMMMMMMMMMMMM123 $workedImgFileUri");
      List<dynamic> offersList =
          localSnapshot["offersSubmittedBy"] ?? new List<dynamic>();

      debugPrint("OFfers list $offersList");

      if (workedImgFileUri != null) {
        offersList.add({
          "name": name,
          "emailId": emailId,
          "phoneNo": phoneNo,
          "userId": userId,
          "orderId": collegeNameCont.text,
          "uploadWorkUri": workedImgFileUri
        });
        await _firestore
            .collection("Posts")
            .document(widget.type)
            .collection(widget.subType)
            .document(widget.snapshot.documentID)
            .setData({"offersSubmittedBy": offersList}, merge: true);

        offersListDB[widget.snapshot.documentID] = false;

        await _firestore
            .collection("Users")
            .document(phoneNo)
            .setData({"offersList": offersListDB}, merge: true)
            .whenComplete(() {})
            .timeout(Duration(seconds: 5), onTimeout: () {
              Fluttertoast.showToast(
                  msg: "please try again.",
                  backgroundColor: Colors.red,
                  textColor: Colors.white);
            });
      }
      offersListPrefs.add(widget.snapshot.documentID.toString());
      prefs.setStringList("offersList", offersListPrefs);
      setState(() {});
      Fluttertoast.showToast(
          msg: "submit successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context);
      isApplied = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception : (applyPostService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  Future<String> uploadToStorage(File file) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(file.path);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    debugPrint("Upload ${uploadTask.isComplete}");
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
