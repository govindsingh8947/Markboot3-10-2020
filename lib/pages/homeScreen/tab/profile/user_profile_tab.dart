import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/offers_page_tab.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/applied_gigs.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/offers_profile.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/paymentReq_page.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/post_list_ui.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/settings_page.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/transaction_page.dart';
import 'package:markBoot/pages/homeScreen/tab/tournament/tournament_tab.dart';
import 'package:markBoot/pages/singup/intro_page.dart';
import 'package:markBoot/pages/singup/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileTab extends StatefulWidget {
  @override
  _UserProfileTabState createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Firestore _firestore = Firestore.instance;
  TextEditingController updateNameCont = TextEditingController();
  SharedPreferences prefs;
  String name, email, phoneNo;
  bool isShowDialog = false;
  Map<String, dynamic> pendingTasks = new Map();
  Map<String, dynamic> internshipList = new Map();
  Map<String, dynamic> campaignList = new Map();
  Map<String, dynamic> tournamentList = new Map();
  Map<String, dynamic> offersList = new Map();
  String approvedAmount = "0";
  String pendingAmount = "0";
  bool isShowInitBar = false;

  initAnim() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
  }

  init() async {
    isShowInitBar = true;
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("userName");
    phoneNo = prefs.getString("userPhoneNo");
    //phoneNo = "+919250204014";
    email = prefs.getString("userEmailId");
    print(phoneNo);
    setState(() {});
    DocumentSnapshot snapshot =
        await _firestore.collection("Users").document(phoneNo).get();
    Map<String, dynamic> userData = snapshot.data;
    pendingTasks = userData["pendingTasks"] ?? new Map();
    campaignList = userData["campaignList"] ?? new Map();
    internshipList = userData["internshipList"] ?? new Map();
    offersList = userData["offersList"] ?? new Map();
    tournamentList = userData["tournamentList"] ?? new Map();
    approvedAmount = userData["approvedAmount"]
        .toString(); // this is Approved amount fetched from the databse
    pendingAmount = userData["pendingAmount"].toString() ?? "0";
    isShowInitBar = false;
    setState(() {});
  }

  @override
  void initState() {
    init();
    initAnim();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          body: isShowInitBar == true
              ? Container(
                  child: Center(
                    child: LoadingFlipping.circle(
                      borderColor: Colors.blue,
                      size: 50,
                      borderSize: 5,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (animationController.isCompleted) {
                      animationController.reverse();
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          padding:
                              EdgeInsets.only(left: 20, top: 30, right: 20),
                          decoration: BoxDecoration(
                            color: Color(0xff051094),
                          ),
                          child: Column(
                            children: [
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // CircleAvatar(
                                  //   radius: 40,
                                  //   //   backgroundColor: Colors.white,
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            name ?? "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        email ?? "",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        phoneNo ?? "",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                padding: EdgeInsets.only(top: 30, right: 20),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      // behavior: HitTestBehavior.deferToChild,
                                      onTap: () {
                                        print("hello");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MoreSettingsPage()));
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        show_dialog();
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "Earning",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Card(
                                        color: Colors.white,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "APPROVED",
                                                style: TextStyle(
                                                    color: Color(0xff051094),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "AMOUNT",
                                                style: TextStyle(
                                                    color: Color(0xff051094),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    "assets/icons/bank.png",
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    approvedAmount ?? "0",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff051094),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "PENDING",
                                                style: TextStyle(
                                                    color: Color(0xff051094),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "AMOUNT",
                                                style: TextStyle(
                                                    color: Color(0xff051094),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    "assets/icons/bank.png",
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    pendingAmount ?? "0",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff051094),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        //padding: EdgeInsets.symmetric(horizontal: 30),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: RaisedButton(
                                          color: Colors.pinkAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionPage()));
                                          },
                                          child: Text(
                                            "Transactions",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //padding: EdgeInsets.symmetric(horizontal: 30),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: RaisedButton(
                                          color: Colors.pinkAccent,
                                          //color: Color(CommonStyle().lightYellowColor),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: () async {
                                            if (int.parse(approvedAmount) >=
                                                150) {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PaymentRequestPage()))
                                                  .then((value) {
                                                debugPrint("returnVal $value");
                                                init();
                                              });
                                            }
                                          },
                                          child: Text(
                                            int.parse(approvedAmount) < 150
                                                ? "AMOUNT<150"
                                                : "WITHDRAW",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GeneralTab()));
                                  },
                                  child: Container(
                                    // margin: EdgeInsets.symmetric(horizontal: 15),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        //color: Color(CommonStyle().blueColor),
                                        color: Color(
                                            CommonStyle().lightYellowColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    //     height: 200,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "View Journal",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return applied_gigs();
                                      }));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green),
                                      height: 200,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Gigs",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostListUIPage(
                                                    //  docMap: internshipList,
                                                    status: "applied",
                                                    path:
                                                        "Posts/Internship/Tasks",
                                                    type: "Internship",
                                                    subType: "Tasks",
                                                  )));
                                    },
                                    child: Container(
                                      //margin: EdgeInsets.symmetric(horizontal: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                          //  color: Color(CommonStyle().blueColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.redAccent),
                                      height: 200,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Internship",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          //height: MediaQuery.of(context).size.height*0.1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: animation != null
                ? MediaQuery.of(context).size.height * 0.5 * animation.value
                : 0,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50 * animation.value,
                ),
                Container(
                  height: 50 * animation.value,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: updateNameCont,
                    onTap: () {},
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                ),
                SizedBox(
                  height: 40 * animation.value,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  height: 50 * animation.value,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color: Color(CommonStyle().blueColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      debugPrint("Pressed");
                      FocusScope.of(context).unfocus();
                      updateName();
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  TextEditingController up_date = TextEditingController();
  String selectedType;
  List<String> types = ["Name", "Phone No", "Email-ID"];
  show_dialog() {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.red, fontSize: 30),
              ),
            ),
            DropdownButton(
                value: selectedType,
                hint: Text("Select the Type"),
                items: List.generate(3, (val) {
                  return DropdownMenuItem(
                    child: Text(
                      types[val],
                    ),
                    value: types[val],
                  );
                }),
                onChanged: (val) {
                  setState(() {
                    selectedType = val;
                    print(selectedType);
                  });
                }),
            CommonWidget().commonTextField(
                controller: up_date,
                inputText:
                    selectedType == null ? "" : "Enter the ${selectedType}",
                lines: 1,
                keyboardType: TextInputType.text),
            FlatButton(
                onPressed: () async {
                  print(selectedType);
                  if (up_date.text.trim.toString().isEmpty ||
                      selectedType == null) {
                    print("enter the details");
                  } else {
                    if (selectedType == "Email-ID" &&
                        up_date.text.trim.toString().contains("@gmail.com")) {
                      //  print();
                      _firestore.collection("Users").document(phoneNo).setData(
                          {"emailId": up_date.text.toString()},
                          merge: true);
                    } else if (selectedType == "Phone No") {
                      List a = await CommonFunction().getPost("Users");

                      DocumentSnapshot user;
                      for (DocumentSnapshot snapshot in a) {
                        if (snapshot.documentID.toString() == phoneNo) {
                          setState(() {
                            user = snapshot;
                          });
                        }
                      }

                      Map u = user.data;
                      u["phoneNo"] = "+91${up_date.text.toString()}";
                      _firestore
                          .collection("Users")
                          .document("+91${up_date.text.toString()}")
                          .setData(u, merge: true)
                          .whenComplete(() async {
                        await _firestore
                            .collection("Users")
                            .document(phoneNo)
                            .delete();
                      });
                    } else {
                      _firestore.collection("Users").document(phoneNo).setData(
                          {"name": up_date.text.toString()},
                          merge: true);
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  'SAVE CHANGES',
                  style: TextStyle(color: Colors.purple, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  updateName() async {
    try {
      String name = updateNameCont.text.trim().toString();
      if (name.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter name.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      isShowDialog = true;
      showProgressDialog();
      Map<String, String> userData = {
        "name": name,
      };
      await _firestore
          .collection("Users")
          .document(phoneNo)
          .setData(userData, merge: true)
          .whenComplete(() {
        // CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(
            msg: "update successfully.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }).catchError((error) {
        // CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(
            msg: "getting some error.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }).timeout(Duration(seconds: 5), onTimeout: () {
        //CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(
            msg: "please try again.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      });
    } catch (e) {
      debugPrint("Exception : (UpdateName)-> $e");
    }
    isShowDialog = false;
    showProgressDialog();
  }

  Future<void> showProgressDialog() {
    if (isShowDialog) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                child: LoadingFlipping.circle(
                  borderColor: Colors.blue,
                  size: 50,
                  borderSize: 5,
                ),
              ),
            );
          });
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
