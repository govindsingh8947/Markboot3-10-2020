import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  FocusNode _pinPutFocusNode = FocusNode();
  TextEditingController _pinPutController = TextEditingController();
  String userVerificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNo;
  String userName;
  String inviteCode;
  String emailId;
  String password;
  SharedPreferences prefs;
  Firestore _firestore = Firestore.instance;
  bool isShowProgressBar = false;
  CommonFunction commonFunction = CommonFunction();

  init() async {
    prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString("userPhoneNo") ?? "";
    userName = prefs.getString("userName") ?? "";
    emailId = prefs.getString("userEmailId") ?? "";
    password = prefs.getString("userPassword") ?? "";
    inviteCode = prefs.getString("userInviteCode") ?? "";
    _pinPutFocusNode.requestFocus();
    if (phoneNo.isNotEmpty) {
      loginUser(phoneNo);
    } else {
      Navigator.pop(context);
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
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 30,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              size: 25,
                              color: Color(0xff051094),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text(
                          "Verification",
                          style:
                              TextStyle(color: Color(0xff051094), fontSize: 22),
                        ),
                        SizedBox(
                          width: 30,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "We sent you a code to verify your",
                          style:
                              TextStyle(color: Color(0xff051094), fontSize: 15),
                        ),
                        Text(
                          "mobile number",
                          style:
                              TextStyle(color: Color(0xff051094), fontSize: 15),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Enter your OTP code here",
                          style:
                              TextStyle(color: Color(0xff051094), fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        onlySelectedBorderPinPut(),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          child: RaisedButton(
                            color: Color(CommonStyle().lightYellowColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "SUBMIT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 25,
                                )
                              ],
                            ),
                            onPressed: () {
                              verifyCode();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "I didn't receive a code!",
                          style:
                              TextStyle(color: Color(0xff051094), fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            loginUser(phoneNo);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Resend Code",
                              style: TextStyle(
                                  color: Color(0xff051094), fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  verifyCode() async {
    try {
      String enteredOTPCode = _pinPutController.text.trim().toString();
      if (enteredOTPCode.isNotEmpty) {
        commonFunction.showProgressDialog(isShowDialog: true, context: context);
        debugPrint("ID $userVerificationId");
        debugPrint("CODE112 $enteredOTPCode");
        AuthCredential credential = PhoneAuthProvider.getCredential(
            verificationId: userVerificationId, smsCode: enteredOTPCode);

        FirebaseAuth auth = FirebaseAuth.instance;
        debugPrint("CRED $credential");
        AuthResult result = await auth.signInWithCredential(credential);
        debugPrint("AUTHRES $result");
        FirebaseUser user = result.user;

        if (user != null) {
          debugPrint("UUUUUUUUUUUUUU ${user.phoneNumber}");
          Map<String, String> userData = {
            "name": userName,
            "phoneNo": phoneNo,
            "emailId": emailId,
            "password": password,
            "inviteCode": inviteCode,
            "userId": user.uid.toString()
          };
          await _firestore
              .collection("Users")
              .document(phoneNo)
              .setData(userData, merge: false);
          prefs.setBool("isLogin", true);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        } else {
          print("Error");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Enter valid OTP.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "please try again",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      debugPrint("ExceptionAuth : ${e.toString()}");
    }
    commonFunction.showProgressDialog(isShowDialog: false, context: context);
  }

  Widget onlySelectedBorderPinPut() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5),
    );

    return PinPut(
      fieldsCount: 6,
      textStyle: TextStyle(fontSize: 25, color: Colors.black),
      onChanged: (value) {
        if (value.length >= 6) {
          _pinPutFocusNode.unfocus();
        }
      },
      eachFieldWidth: 45,
      eachFieldHeight: 55,
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration.copyWith(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: Color(0xff051094),
          )),
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
    );
  }

  Future<bool> loginUser(String phone) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            debugPrint("USERRRRRR $user");
          } else {
            print("Error");
          }
          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          debugPrint(
              "VVVVVVVVVVVVV ${verificationId} , token $forceResendingToken");
          userVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: null);
  }

  Future<void> signUp(email, password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
    } catch (e) {}
  }
}
