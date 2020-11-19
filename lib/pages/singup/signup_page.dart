import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/verification_confirm.dart';
import 'package:markBoot/pages/singup/verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  FirebaseUser user;
  String pass;
  SignUpPage({this.user,this.pass});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isEmail=true;
  TextEditingController nameCont = TextEditingController();
  TextEditingController pass2Cont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController inviteCodeCont = TextEditingController();
  SharedPreferences prefs;
  CommonFunction commonFunction = CommonFunction();
  CommonWidget commonWidget = CommonWidget();
  var isLoading=false;
  // Firebase
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(CommonStyle().introBackgroundColor),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
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
                    controller: nameCont,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.ac_unit),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: phoneCont,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Phone No.",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.phone),
                    ),
                  )),
              SizedBox(
                height: 10,
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
                       hintText: isEmail?"Email Id":"Phone No.",
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.only(left: 10),
                       icon: Icon(Icons.email),
                     ),
                   )),
               SizedBox(
                 height: 10,
               ),
               isEmail?Container(
                   margin: EdgeInsets.only(left: 30, right: 30),
                   padding: EdgeInsets.only(left: 10, right: 10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                     color: Colors.white,
                   ),
                   child: TextField(
                     obscureText: true,
                     controller: passCont,
                     //textAlign: TextAlign.center,
                     decoration: InputDecoration(
                       hintText: "Enter Password",
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.only(left: 10),
                       icon: Icon(Icons.lock_outline),
                     ),
                   )):SizedBox(),
              SizedBox(
                height: 10,
              ),
              isEmail?Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: pass2Cont,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Re-enter Password",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.lock_outline),
                    ),
                  )):SizedBox(),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: inviteCodeCont,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Invite Code (optional)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.ac_unit),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              isLoading?CircularProgressIndicator():Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: 220,
                  height: 40,
                  child: RaisedButton(
                    color: Color(CommonStyle().lightYellowColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      signUp();
                    },
                    child: Text(
                      "Sign Up",
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
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        " Sign in",
                        style: TextStyle(
                            decorationColor: Colors.yellowAccent,
                            decoration: TextDecoration.underline,
                            color: Color(CommonStyle().appbarColor),
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 50,
              )
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

  signUp() async {
    if(isEmail) {
      var email = emailCont.text.trim();
      var pass1 = passCont.text.trim();
      var pass2 = pass2Cont.text.trim();
      String name = nameCont.text.trim().toString();
      String inviteCode = inviteCodeCont.text.trim().toString();
      String phoneNo =phoneCont.text.trim().toString();
      List<DocumentSnapshot> snaps =await CommonFunction().getPost("Users");
      for (DocumentSnapshot snap in snaps) {
        if(snap.documentID=="+91$phoneNo"){
          Fluttertoast.showToast(msg: "User already exists try log in");
          return;
        }
      }
      if (name.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter name.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (phoneNo.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter phone number.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      else if (email.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter email id.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (pass1.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter password.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      else {
        if (pass2 == pass1) {
          if (pass1.length < 6) {
            Fluttertoast.showToast(msg: "please enter a strong password"
            );
            return;
          }
          try {
            setState(() {
              isLoading=true;
            });
            FirebaseAuth auth = FirebaseAuth.instance;
            AuthResult authResult = await auth.createUserWithEmailAndPassword(
                email: email, password: pass1);
            FirebaseUser user = await auth.currentUser();
            await user.reload();
            try {
              await user.sendEmailVerification();
              Fluttertoast.showToast(
                  msg: "verification email sent please verify"
              );
              setState(() {
                isLoading=false;
              });
              Future.delayed(Duration(seconds: 0), () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return VerificationConfirmPage(email,pass1,phoneNo,name,inviteCode: inviteCode);
                })
                );
              }
              );
              if(user.isEmailVerified){
                print("verified");
              }
              else{
                print("not verified");
              }
            }
            catch (err) {
              setState(() {
                isLoading=false;
              });
              Fluttertoast.showToast(msg: err.message);
              print(err);
            }
          } catch (err) {
            setState(() {
              isLoading=false;
            });
            Fluttertoast.showToast(msg: err.message);
            print(err);
          }
        }
        else if (pass1 != pass2) {
          Fluttertoast.showToast(msg: "Password do not match"
          );
          return;
        }
      }
    }
    else{
      try {
        String name = nameCont.text.trim().toString();
        String phoneNo = emailCont.text.trim().toString();
        String password = passCont.text.trim().toString();
        String inviteCode = inviteCodeCont.text.trim().toString();

        if (name.isEmpty) {
          Fluttertoast.showToast(
              msg: "Enter name.",
              backgroundColor: Colors.red,
              textColor: Colors.white);
          return;
        } else if (phoneNo.isEmpty) {
          Fluttertoast.showToast(
              msg: "Enter phone number.",
              backgroundColor: Colors.red,
              textColor: Colors.white);
          return;
        }
        //else if (email.isEmpty) {
        //  Fluttertoast.showToast(
        //      msg: "Enter email id.",
        //      backgroundColor: Colors.red,
        //      textColor: Colors.white);
        //  return;
        //} else if (password.isEmpty) {
        //  Fluttertoast.showToast(
        //      msg: "Enter password.",
        //      backgroundColor: Colors.red,
        //      textColor: Colors.white);
        //  return;
        //}

        if(widget.user.isEmailVerified == false) {
          AuthResult authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.user.email, password: widget.pass);
          if(authResult.user.isEmailVerified == false) {
            BotToast.showText(text: "Please verify your email id.");
            return;
          }
        }

        // show ProgressBar
        commonFunction.showProgressDialog(isShowDialog: true, context: context);

        DocumentSnapshot snapshot =
        await _firestore.collection("Users").document("+91$phoneNo").get();
        debugPrint("SNAPSHOT ${snapshot.exists}");
        if (snapshot.exists == false) {
          prefs.setString("userName", name);
          prefs.setString("userPhoneNo", "+91$phoneNo");
          prefs.setString("userEmailId", widget.user.email);
          prefs.setString("userPassword", widget.pass);
          prefs.setString("userInviteCode", inviteCode);
          Map<String, String> userData = {
            "name": name,
            "phoneNo": phoneNo,
            "emailId": widget.user.email,
            "inviteCode": inviteCode,
            "userId": widget.user.uid.toString()
          };
          await Firestore.instance.collection("Users").document("+91$phoneNo").setData(userData,merge: true);
          await commonFunction.showProgressDialog(
              isShowDialog: false, context: context);
          prefs.setBool("isLogin", true);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => HomePage()
          ), (route) => false);
        } else {
          await commonFunction.showProgressDialog(
              isShowDialog: false, context: context);
          Fluttertoast.showToast(msg: "Mobile no already in used");
        }

      } catch (e) {
        debugPrint("Exception : (SignUpService) - ${e.toString()}");
      }
    }
  }
  }

