import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:markBoot/pages/homeScreen/tab/home/home_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';


class VerificationConfirmPage extends StatefulWidget {
  final String email;
  final String pass;
  final String name;
  final String phoneNo;
  final String inviteCode;
  VerificationConfirmPage(this.email,this.pass,this.phoneNo,this.name,{this.inviteCode=""});
  @override
  _VerificationConfirmPageState createState() => _VerificationConfirmPageState();
}

class _VerificationConfirmPageState extends State<VerificationConfirmPage> {
  CommonFunction commonFunction = CommonFunction();
  SharedPreferences prefs;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 10), (time) async {FirebaseAuth auth=FirebaseAuth.instance;
    FirebaseUser user= await auth.currentUser();
    user.reload();
    print(user.email);
    if(user.isEmailVerified){
      print("verified");
      navigate();
      time.cancel();
      return ;
    }
    else{
      print("not");
    }});
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
        SizedBox(height: MediaQuery.of(context).size.height*0.3),
        SpinKitSquareCircle(color: Colors.amber,size: 120,),
        SizedBox(height: 100),
        Text("Verify your email address \nwhile we wait",style: TextStyle(letterSpacing: 1,fontWeight: FontWeight.bold,fontSize: 30),),
      ],),
    );
  }
  navigate() async {
    try {
      Firestore _firestore = Firestore.instance;
      commonFunction.showProgressDialog(isShowDialog: true, context: context);
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser user = await auth.currentUser();
      DocumentSnapshot snapshot =
      await _firestore.collection("Users").document("+91${widget.phoneNo}").get();
      debugPrint("SNAPSHOT ${snapshot.exists}");
      if (snapshot.exists == false) {
        Map<String, dynamic> userData = {
          "name": widget.name,
          "phoneNo": widget.phoneNo,
          "emailId": user.email,
          "inviteCode": widget.inviteCode,
          "userId": user.uid.toString(),
          "pendingAmount":0,
          "approvedAmount":0,
          "request":[]
        };
        await Firestore.instance.collection("Users").document(
            "+91${widget.phoneNo}").setData(userData, merge: true);
        await commonFunction.showProgressDialog(
            isShowDialog: false, context: context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HomePage()
        ), (route) => false);
      } else {
        await commonFunction.showProgressDialog(
            isShowDialog: false, context: context);
        Fluttertoast.showToast(msg: "Mobile no already in used");
      }
    }catch(e){
      debugPrint("Exception : (SignUpService) - ${e.toString()}");
    }
  }
}
