import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TournamentDetailsPage extends StatefulWidget {
  DocumentSnapshot snapshot;
  String type;
  String subType;
  TournamentDetailsPage({@required this.snapshot, this.type, this.subType});
  @override
  _TournamentDetailsPageState createState() => _TournamentDetailsPageState();
}

class _TournamentDetailsPageState extends State<TournamentDetailsPage> {
  Firestore _firestore = Firestore();
  String phoneNo;
  SharedPreferences prefs;
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
  List localQuestionMapList = new List();
  List<Map<String, String>> questionMapList = new List();
  List<int> selectedOptionList = new List();
  List<String> questions = new List();
  String userName;
  String userPhone;
  String userEmailId;
  List<String> tournamentList = new List();
  Map<String, dynamic> tournamentMapDb = new Map<String, dynamic>();
  String pendigAmount;

  Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();

      // user details......
      userName = prefs.getString("userName");
      userPhone = prefs.getString("userPhoneNo");
      userEmailId = prefs.getString("userEmailId");
      tournamentList = prefs.getStringList("internshiplist") ?? new List();
      DocumentSnapshot snapshot = await Firestore.instance
          .collection("Users")
          .document(userPhone)
          .get();
      Map<String, dynamic> userData = snapshot.data;
      pendigAmount = userData["pendingAmount"] ?? "0";
      debugPrint("INITPAM $pendigAmount");
      tournamentMapDb =
          userData["tournamentList"] ?? new Map<String, dynamic>();
      if (tournamentList.contains(widget.snapshot.documentID) ||
          tournamentMapDb.containsKey(widget.snapshot.documentID)) {
        isApplied = true;
        setState(() {});
      }

      localQuestionMapList = widget.snapshot["questionList"] ?? new List();
      for (var item in localQuestionMapList) {
        selectedOptionList.add(0);
        questions.add(item["question"] ?? "");
        questionMapList.add({
          "question": item["question"] ?? "",
          "option1": item["option1"] ?? "",
          "option2": item["option2"] ?? "",
          "option3": item["option3"] ?? "",
          "option4": item["option4"] ?? ""
        });
      }
      setState(() {});

      debugPrint("TOURN DETAILS ${widget.snapshot["questionList"]}");
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.snapshot["taskTitle"] ?? "",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Colors.white)
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
                                      color: Colors.white)
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
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                widget.snapshot["companyName"] ?? "",
                                style: TextStyle(
                                    fontSize: 15,
                                    //     color: Color(0xff051094)),
                                    color: Colors.black54),
                              )
                            ],
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "REWARD",
                              style: TextStyle(
                                  color: Colors.black,
                                  // color:
                                  //     Color(CommonStyle().lightYellowColor),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/icons/bank.png",
                                  width: 15,
                                  height: 15,
                                  color: Color(0xff051094),
                                ),
                                Text(
                                  widget.snapshot["reward"] ?? "0",
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff051094)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: List<Widget>.generate(
                          //       questionMapList.length, (int index) {
                          //     return Card(
                          //       color: Color(CommonStyle().blueCardColor),
                          //       elevation: 5,
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(8)),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(4.0),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: <Widget>[
                          //             Container(
                          //               padding: EdgeInsets.only(left: 5),
                          //               child: Text(
                          //                 '${index + 1}. ${questionMapList[index]["question"]}',
                          //                 style: TextStyle(
                          //                     color: Colors.greenAccent,
                          //                     fontSize: 16),
                          //               ),
                          //             ),
                          //             Theme(
                          //               data: Theme.of(context).copyWith(
                          //                 unselectedWidgetColor: Colors.white,
                          //               ),
                          //               child: IgnorePointer(
                          //                 ignoring:
                          //                     isApplied == true ? true : false,
                          //                 child: Wrap(
                          //                   children: <Widget>[
                          //                     Row(
                          //                       children: <Widget>[
                          //                         Checkbox(
                          //                           activeColor: Colors.green,
                          //                           onChanged: (value) {
                          //                             selectedOptionList[
                          //                                 index] = 1;
                          //                             setState(() {});
                          //                           },
                          //                           value: selectedOptionList[
                          //                                       index] ==
                          //                                   1
                          //                               ? true
                          //                               : false,
                          //                         ),
                          //                         Text(
                          //                           questionMapList[index]
                          //                               ["option1"],
                          //                           style: TextStyle(
                          //                               color: Colors.white70,
                          //                               fontSize: 14),
                          //                         )
                          //                       ],
                          //                     ),
                          //                     Row(
                          //                       children: <Widget>[
                          //                         Checkbox(
                          //                           activeColor: Colors.green,
                          //                           onChanged: (value) {
                          //                             selectedOptionList[
                          //                                 index] = 2;
                          //                             setState(() {});
                          //                           },
                          //                           value: selectedOptionList[
                          //                                       index] ==
                          //                                   2
                          //                               ? true
                          //                               : false,
                          //                         ),
                          //                         Text(
                          //                           questionMapList[index]
                          //                               ["option2"],
                          //                           style: TextStyle(
                          //                               color: Colors.white70,
                          //                               fontSize: 14),
                          //                         )
                          //                       ],
                          //                     ),
                          //                     Row(
                          //                       children: <Widget>[
                          //                         Checkbox(
                          //                           activeColor: Colors.green,
                          //                           onChanged: (value) {
                          //                             selectedOptionList[
                          //                                 index] = 3;
                          //                             setState(() {});
                          //                           },
                          //                           value: selectedOptionList[
                          //                                       index] ==
                          //                                   3
                          //                               ? true
                          //                               : false,
                          //                         ),
                          //                         Text(
                          //                           questionMapList[index]
                          //                               ["option3"],
                          //                           style: TextStyle(
                          //                               color: Colors.white70,
                          //                               fontSize: 14),
                          //                         )
                          //                       ],
                          //                     ),
                          //                     Row(
                          //                       children: <Widget>[
                          //                         Checkbox(
                          //                           activeColor: Colors.green,
                          //                           onChanged: (value) {
                          //                             selectedOptionList[
                          //                                 index] = 4;
                          //                             setState(() {});
                          //                           },
                          //                           value: selectedOptionList[
                          //                                       index] ==
                          //                                   4
                          //                               ? true
                          //                               : false,
                          //                         ),
                          //                         Text(
                          //                           questionMapList[index]
                          //                               ["option4"],
                          //                           style: TextStyle(
                          //                               color: Colors.white70,
                          //                               fontSize: 14),
                          //                         )
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   }),
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Color(0xff051094),
                              onPressed: () {
                                _launchURL(widget.snapshot["link"] ?? "");

                                // if (isApplied == false) {
                                //   tournamentService();
                                // }
                              },
                              child: Text(
                                isApplied == false
                                    ? "Visit Website"
                                    : "Already Submitted",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ));
  }

  tournamentService() async {
    try {
      debugPrint("TournaService ${selectedOptionList}");
      List<Map<String, String>> questionAnsMap = new List();
      int index;
      String answer;
      bool isEmpty = false;
      for (int i = 0; i < questions.length; i++) {
        if (selectedOptionList[i] == 1) {
          debugPrint("HI");
          answer = questionMapList[i]["option1"] ?? "";
        } else if (selectedOptionList[i] == 2) {
          answer = questionMapList[i]["option2"] ?? "";
        } else if (selectedOptionList[i] == 3) {
          answer = questionMapList[i]["option3"] ?? "";
        } else if (selectedOptionList[i] == 4) {
          answer = questionMapList[i]["option4"] ?? '';
        } else {
          isEmpty = true;
          answer = "";
        }
        if (isEmpty == true) {
          Fluttertoast.showToast(
              msg: "Please select valid option",
              backgroundColor: Colors.red,
              textColor: Colors.white);
          return;
        }
        CommonFunction()
            .showProgressDialog(isShowDialog: true, context: context);

        questionAnsMap.add({"question": questions[i], "answer": answer});
      }

      List submittedBy = widget.snapshot["submittedBy"] ?? new List();
      debugPrint("ALREADY ${widget.snapshot["submittedBy"]}");

      submittedBy.add({
        "name": userName,
        "emailId": userEmailId,
        "phoneNo": userPhone,
        "data": questionAnsMap
      });
      tournamentMapDb[widget.snapshot.documentID] = false;
      pendigAmount = (int.parse(pendigAmount ?? "0") +
              int.parse(widget.snapshot["reward"] ?? "0"))
          .toString();
      debugPrint("PendingAMOUNT $pendigAmount");
      debugPrint("RReward ${widget.snapshot["reward"]}");
      await Firestore.instance.collection("Users").document(userPhone).setData(
          {"tournamentList": tournamentMapDb, "pendingAmount": pendigAmount},
          merge: true);
      await Firestore.instance
          .collection("Posts")
          .document("Tournament")
          .collection("Tournament")
          .document(widget.snapshot.documentID)
          .setData({"submittedBy": submittedBy}, merge: true);
      tournamentList.add(widget.snapshot.documentID);
      prefs.setStringList("tournamentList", tournamentList);
      Fluttertoast.showToast(
          msg: "Submitted successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context);
      debugPrint("QANSWER $questionAnsMap");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "please try again",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      debugPrint("Exception: (tournamentService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
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
}
