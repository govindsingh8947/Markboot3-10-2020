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
import 'package:markBoot/pages/singup/email_sign_up.dart';
import 'package:markBoot/pages/singup/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_login.dart';
import 'forgot_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  Firestore _firestore = Firestore();
  CommonWidget commonWidget = CommonWidget();
  SharedPreferences prefs;
  CommonFunction commonFunction = CommonFunction();
  String userVerificationId;
  bool isLoading=false;
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
        color: Color(CommonStyle().introBackgroundColor),
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
                    controller: phoneCont,
                    //textAlign: TextAlign.center,

                    decoration: InputDecoration(
                      hintText: "Enter the Phone No",
                      contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.person),
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
                width: isLoading?100:220,
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 40,
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(20)
//              ),

                child: isLoading?CircularProgressIndicator():RaisedButton(
                  color: Color(CommonStyle().lightYellowColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    userLogin();
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
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        " Sign up",
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
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

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  userLogin() async {
    try {

      debugPrint("userLogin");
      String phoneNo = phoneCont.text.trim().toString();
      String password = passCont.text.trim().toString();
      print(password);
      if (phoneNo.isEmpty) {
        setState(() {
          isLoading=false;
        });
        Fluttertoast.showToast(
            msg: "Enter phone number",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (password.isEmpty) {
        setState(() {
          isLoading=false;
        });
        Fluttertoast.showToast(
            msg: "Enter password",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }

      // Show Progress Dialog
      commonFunction.showProgressDialog(isShowDialog: true, context: context);
      //..........
      if (_isNumeric(phoneNo)) {
        print("hello");
        login_user(phoneNo, password);
      } else {
        print("admin");
        admin_user(phoneNo, password);
      }
    } catch (e) {
      debugPrint("Exception (LoginPage) - ${e.toString()}");
    }
    commonFunction.showProgressDialog(isShowDialog: false, context: context);
  }

  login_user(String phoneNo, String password) async {
   try{
     setState(() {
       isLoading=true;
     });
     DocumentSnapshot snapshot =
     await _firestore.collection("Users").document("+91$phoneNo").get();
     debugPrint("SNAPSHOT ${snapshot.exists}");
     if (snapshot.exists == true) {
       Map<String, dynamic> userData = snapshot.data;
       String userPassword = userData["password"] ?? "";
       debugPrint("USERDATA $userData");
       AuthResult authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userData["emailId"], password: password);
       if (authResult.user!=null) {
         prefs.setString("userName", userData["name"] ?? "");
         prefs.setString("userPhoneNo", "+91$phoneNo" ?? "");
         prefs.setString("userEmailId", userData["emailId"] ?? "");
         prefs.setString("userPassword", password ?? "");
         prefs.setString("userInviteCode", userData["inviteCode"] ?? "");
         prefs.setString("userId", userData["userId"] ?? "");
         prefs.setString("referralCode", userData["referralCode"] ?? "");
         prefs.setBool("isLogin", true);
         print(prefs.getString("userPhoneNo"));
         Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(builder: (context) => HomePage()),
                 (route) => false);
       } else {
         setState(() {
           isLoading=false;
         });
         debugPrint("LOGIN UNSUCCESSFUL");
       }
     } else {
       setState(() {
         isLoading=false;
       });
       Fluttertoast.showToast(
           msg: "Phone number doesn't exist.",
           backgroundColor: Colors.red,
           textColor: Colors.white);
     }
   }
   catch(e) {
     setState(() {
       isLoading=false;
     });
     debugPrint("Exception :(login_user) -> $e");
     if(e.toString().contains("ERROR_WRONG_PASSWORD")) {
       BotToast.showText(text:"The password is invalid or the user does not have a password" ,contentColor: Colors.red);
     }
   }
  }

  admin_user(String emialNo, String password) async {
    setState(() {
      isLoading=true;
    });
    bool isLogin = false;

    DocumentSnapshot snapshot = await _firestore
        .collection("Agent")
        .document("wOJeT8psKFbGWLvOEW8EKzxY4gH2")
        .get();
    debugPrint("SNAPSHOT ${snapshot.exists}");
    if (snapshot.exists == true) {
      Map<String, dynamic> userData = snapshot.data;
      String userPassword = userData["password"] ?? "";
      debugPrint("USERDATA $userData");
      if (password == userPassword) {
        prefs.setString("userName", "Admin");
        prefs.setString("userPhoneNo", "+918279772115");
        prefs.setString("userEmailId", emialNo);
        prefs.setString("userPassword", password);
        prefs.setString("userInviteCode", "");
        prefs.setBool("isAdminLogin", true);
        prefs.setBool("isLogin", false);
        //prefs.setBool("isLogin", true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AdminHomePage()),
            (route) => false);
      } else {
        setState(() {
          isLoading=false;
        });
        debugPrint("LOGIN UNSUCCESSFUL");
      }
    } else {
      setState(() {
        isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "Email ID doesn't exist.",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }

    // FirebaseAuth auth = FirebaseAuth.instance;
    // AuthResult authResult = await auth.signInWithEmailAndPassword(
    //     email: emialNo, password: password);
    // await authResult.user.reload();
    // FirebaseUser user = authResult.user;
    // debugPrint("authRes - ${user.isEmailVerified}");
    // debugPrint("authRes - ");

    // if (authResult.user.isEmailVerified == true) {
    //   debugPrint("HIII");
    //   QuerySnapshot querySnapshot =
    //       await Firestore.instance.collection("Agent").getDocuments();
    //   for (DocumentSnapshot snapshot in querySnapshot.documents) {
    //     debugPrint("ID ${snapshot.documentID} ,, ${authResult.user.uid}");
    //     if (snapshot.documentID == authResult.user.uid) {
    //       isLogin = true;
    //       prefs.setString("userName", "Admin");
    //       prefs.setString("userPhoneNo", "+918279772115");
    //       prefs.setString("userEmailId", emialNo);
    //       prefs.setString("userPassword", password);
    //       prefs.setString("userInviteCode", "");
    //       prefs.setBool("isAdminLogin", true);
    //       prefs.setBool("isLogin", false);
    //       await commonFunction.showProgressDialog(
    //           isShowDialog: false, context: context);
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(builder: (context) => AdminHomePage()),
    //           (route) => false);
    //       break;
    //     }
    //   }
    //}
    // if (isLogin == false) {
    //   Fluttertoast.showToast(
    //       msg: "please try again",
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    // }
  }
}
