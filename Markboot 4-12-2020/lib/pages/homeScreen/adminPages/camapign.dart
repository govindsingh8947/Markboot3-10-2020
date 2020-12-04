import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class Campaign extends StatefulWidget {
  //String type;
  //String subtype;

  Campaign();

  @override
  _CampaignState createState() => _CampaignState();
}

class _CampaignState extends State<Campaign> {
  CommonWidget commonWidget = CommonWidget();
//  List<String> types = ["Gigs","Offers","Internship","Tournament"];
//  String selectedType ;
  TextEditingController com_name = TextEditingController();
  TextEditingController user_name = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_phone = TextEditingController();
  TextEditingController user_reward = TextEditingController();
//  TextEditingController  = TextEditingController();
  TextEditingController descrip = TextEditingController();
//  TextEditingController cashbackLinkCont = TextEditingController();
//  TextEditingController salaryCont = TextEditingController();
//  TextEditingController locationCont = TextEditingController();
//  TextEditingController durationCont = TextEditingController();
//  TextEditingController categoryCont = TextEditingController();
//  TextEditingController designationCont = TextEditingController();
//  TextEditingController startDateCont = TextEditingController();
//  TextEditingController applyByCont = TextEditingController();
//  TextEditingController skillsReqCont = TextEditingController();
//
  init() {}

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff051094),
        title: Text(
          "Campaign",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color(CommonStyle().backgroundColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: commonWidget.commonTextField(
                    controller: com_name, inputText: "Campaign Name")),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_name, inputText: "Name")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_email, inputText: "email address")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_phone, inputText: "Phone No")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_reward, inputText: "Reward")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: descrip, inputText: "Description")),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 260),
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
//                  checkTaskService();
                  String company = com_name.text.trim().toString();
                  String name = user_name.text.trim().toString();
                  String phone = user_phone.text.trim().toString();
                  String email = user_email.text.trim().toString();
                  String reward = user_reward.text.trim().toString();
                  String desc = descrip.toString();

//                  String company="google";
//                  String name="ashish";
//                  String phone="8532956668";
//                  String reward="20";
//                  String desc="nmndmnsd";
//                  String email="ashish@gmail.com";
//                  print(company.length);
//                  print(company.isEmpty);

                  if (company.isEmpty ||
                      name.isEmpty ||
                      phone.isEmpty ||
                      email.isEmpty ||
                      reward.isEmpty ||
                      desc.isEmpty) {
                    print("Please enter the data");
                  } else {
                    List<DocumentSnapshot> users =
                        await CommonFunction().getPost("Users");
                    List<DocumentSnapshot> campaigns =
                        await CommonFunction().getPost("Posts/Gigs/Campaign");

                    //  print(users);
                    //print(campaigns);

                    DocumentSnapshot use;
                    DocumentSnapshot campaign;
                    for (var user in users) {
//                      print(user.documentID.toString()=="+91${phone}");
                      // print(user.data);
//                      print(user.data["emailId"]);
                      //                    print(email);
                      //                  print("\n");
                      if (user.documentID.toString() == "+91${phone}" &&
                          user.data["name"] == name &&
                          user.data["emailId"] == email) {
                        print("user Got it");
                        setState(() {
                          print("setting state");
                          use = user;
                          print("set state");
                        });
                      }
                    }
                    print("finding campaigns");
                    for (var cam in campaigns) {
                      print("finding campaigns");
                      if (cam.data["taskTitle"].toString() == company) {
                        print(" campaign Got it");
                        setState(() {
                          campaign = cam;
                        });
                      }

                      else if (use != null && campaign != null) {
                        print("found");
                        _showMyDialog(use, campaign);
                      } else {
                        print("Data not Found");
                      }
                    }
                  }

//                   _showMyDialog();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  fieldClear() {
    //selectedType = null;
    com_name.clear();
    user_name.clear();
    user_phone.clear();
    user_email.clear();
    user_reward.clear();
  }

  Future<void> _showMyDialog(
      DocumentSnapshot user, DocumentSnapshot campaign) async {
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
              child: Text('approved'),
              onPressed: () {
                //_pending_approved(user, campaign);
                // _pending_approved(userId);
                // Navigator.pop(context);
                upload_data(user, campaign, "approved");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('pending'),
              onPressed: () {
                //_pending_approved(user, campaign);
                // _pending_approved(userId);
                Navigator.pop(context);
                upload_data(user, campaign, "pending");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('rejected'),
              onPressed: () async {
                upload_data(user, campaign, "rejected");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Firestore _firestore = Firestore();

  upload_data(
      DocumentSnapshot user, DocumentSnapshot campaign, String status) async {
//
//    // For the user Side
    Map<String, dynamic> u = user.data;
    // print(u);
    print(status);
    setState(() {
      print(user_reward.text);
      if (status == "pending") {
        print(int.parse(u["pendingAmount"]) +
            int.parse(user_reward.text.trim().toString()));
        print(int.parse(user_reward.text.trim().toString()));
        //   "${int.parse(u["pendingAmount"]) + int.parse(user_reward.text.trim().toString())}");
        u["pendingAmount"] =
            "${int.parse(u["pendingAmount"]) + int.parse(user_reward.text.trim().toString())}";
      } else if (status == "approved") {
        u["approvedAmount"] =
            "${int.parse(u["approvedAmount"]) + int.parse(user_reward.text.trim().toString())}";
      }
      var users_cam = u["campaignList"];
//      print(null);
//      if(users_cam==null){
      //u["campaignList"]={"${campaign.documentID}",false};
      //}else {
      users_cam["${campaign.documentID}"] = false;
      //print(u["campaignList"]);
      // users_cam.add(({"${campaign.documentID}" : false}));
      u["campaignList"] = users_cam;
      //}
    });
    print(u);

    print(user.documentID);
    print(u);
    await _firestore
        .collection("Users")
        .document(user.documentID)
        .setData(u, merge: true);

    // For Task Side

    List<DocumentSnapshot> campaigns_task =
        await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");

    int flag = 0;
    DocumentSnapshot cam;
    for (var cams in campaigns_task) {
      if (cams.documentID.toString() == campaign.documentID) {
        setState(() {
          flag = 1;
          cam = cams;
        });
      }
    }

    print(flag);
    print(campaign.data);

    List userr;
    if (flag == 1) {
      userr = cam.data["submittedBy"];
      for (var ut in userr) {
        //print(ut);
        if (ut["name"] == u["name"]) {
          print("user present");
          print(userr.indexOf(ut));
          userr.remove(ut);
          break;
        }
      }
      userr.add({
        "companyName": com_name.text.trim().toString(),
        "taskTitle": campaign.data["taskTitle"],
        "name": u["name"] ?? "",
        "emailId": u["emailId"] ?? "",
        "uploadWorkUri": campaign.data["imgUri"] ?? "",
        "userId": u["userId"] ?? "",
        "phoneNo": u["phoneNo"] ?? "",
        "description": "kdskdsk",
        "status": status,
        "reward": user_reward.text.trim().toString()
      });
    } else {
      userr = [];
      userr.add({
        "companyName": com_name.text.trim().toString(),
        "taskTitle": campaign.data["taskTitle"],
        "name": u["name"] ?? "",
        "emailId": u["emailId"] ?? "",
        "uploadWorkUri": campaign.data["imgUri"] ?? "",
        "userId": u["userId"] ?? "",
        "phoneNo": u["phoneNo"] ?? "",
        "description": "kdskdsk",
        "status": status,
        "reward": user_reward.text.trim().toString()
      });
    }

    print(userr);
    Map<String, dynamic> updatedPost = {"submittedBy": userr};

    print(updatedPost);

    await _firestore
        .collection("Posts")
        .document("Gigs")
        .collection("Campaign Tasks")
        .document(campaign.documentID)
        .setData(updatedPost, merge: true);
  }
}
