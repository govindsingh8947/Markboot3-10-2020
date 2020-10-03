import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatefulWidget {
  String phoneNo;
  ResetPasswordPage({this.phoneNo});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  SharedPreferences prefs;
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();

  init() async {
    prefs = await SharedPreferences.getInstance();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Text(
            "Reset Password",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            height: 30,
          ),
          CommonWidget()
              .commonTextField(controller: passwordCont, hintText: "Password"),
          CommonWidget().commonTextField(
              controller: confirmPassCont, hintText: "Confirm Password"),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: 40,
            child: RaisedButton(
              color: Color(CommonStyle().lightYellowColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
              onPressed: () {
                FocusScope.of(context).unfocus();
                resetPasswordService();
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
        ],
      ),
    );
  }

  resetPasswordService() async {
    try {
      String password = passwordCont.text;
      String confirmPass = confirmPassCont.text;
      if (password != confirmPass) {
        Fluttertoast.showToast(
            msg: "Confirm Password does'nt match",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }

      await Firestore.instance
          .collection("Users")
          .document("+91${widget.phoneNo}")
          .setData({"password": password}, merge: true);
      DocumentSnapshot snapshot = await Firestore.instance
          .collection("Users")
          .document("+91${widget.phoneNo}")
          .get();
      Map<String, dynamic> userData = snapshot.data;
      String name = userData["name"] ?? "";
      String phoneNo = userData["phoneNo"] ?? "";
      String emailId = userData["emailId"] ?? "" ?? "";
      String inviteCode = userData["inviteCode"] ?? "";
      String UID = userData["userId"] ?? "";
      String referralCode = userData["referralCode"] ?? "";

      prefs.setString("userName", name);
      prefs.setString("userPhoneNo", phoneNo);
      prefs.setString("userEmailId", emailId);
      prefs.setString("userPassword", password);
      prefs.setString("userInviteCode", inviteCode);
      prefs.setString("userId", UID);
      prefs.setString("referralCode", referralCode);
      prefs.setBool("isLogin", true);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } catch (e) {
      debugPrint("Exception : (ResetPasswordService) -> $e");
    }
  }
}
