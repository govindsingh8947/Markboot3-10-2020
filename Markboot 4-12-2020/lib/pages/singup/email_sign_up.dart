import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/adminPages/admin_homepage.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/login_page.dart';
import 'package:markBoot/pages/singup/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_page.dart';

class EmailSignup extends StatefulWidget {
  @override
  _EmailSignupState createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  Firestore _firestore = Firestore();
  CommonWidget commonWidget = CommonWidget();
  SharedPreferences prefs;
  CommonFunction commonFunction = CommonFunction();
  String userVerificationId;

  Future<void> init() async {
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        // margin: EdgeInsets.only(top: 40),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //    padding: EdgeInsets.symmetric(horizontal: 0,),
        color: Color(0xff051094),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70,
              ),

              appLogo(),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: emailCont,
                    //textAlign: TextAlign.center,

                    decoration: InputDecoration(
                      hintText: "Enter email id",
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.email),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),

              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: passCont,
                    //textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter the password",
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.lock),
                    ),
                  )),
//            commonWidget.commonTextField(controller: passCont,hintText: "Password",obscureText: true),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 220,
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 40,
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(20)
//              ),

                child: RaisedButton(
                  color: Color(CommonStyle().lightYellowColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    signupWithEmail();
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        " Sign in",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appLogo() {
    return Container(
      //height: 50,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
//              padding: EdgeInsets.all(50),
//              margin: EdgeInsets.only(left: 30,right:30,bottom: 40),
            child: Image.asset("assets/icons/money.png"),
          ),
          Container(
            //   color: Colors.blue,
            //padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            // height: _height * .10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mark",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Boot",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  signupWithEmail()async {
    try{
      final String email = emailCont.text.trim();
      final String pass = passCont.text.trim();
      AuthResult authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      debugPrint("AUTH RESULT ${authResult.user}");
      if(authResult.user!=null && authResult.user.isEmailVerified == false) {
        await authResult.user.sendEmailVerification();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => SignUpPage(user: authResult.user,pass: pass,)
        ), (route) => false);
      }
    }
    catch(e) {
      debugPrint("Exception:(signupWithEmail) -> $e");
      if(e.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
        BotToast.showText(text: "The email address is already in use by another account",contentColor: Colors.red);
      }
    }
  }

}
