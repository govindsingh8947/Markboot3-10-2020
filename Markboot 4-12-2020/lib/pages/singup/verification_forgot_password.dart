import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/reset_password_page.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerification_forgot extends StatefulWidget {
  String phone;
  PhoneVerification_forgot(this.phone);
  @override
  _PhoneVerification_forgotState createState() =>
      _PhoneVerification_forgotState();
}

class _PhoneVerification_forgotState extends State<PhoneVerification_forgot> {
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
    if (widget.phone.isNotEmpty) {
      loginUser(widget.phone);
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
                            onPressed: () async {
                              bool verify = await verifyCode();
                              if (verify == true) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPasswordPage(
                                              phoneNo: widget.phone,
                                            )));
                              }
                              ;
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
                            loginUser(widget.phone);
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

  Future<bool> loginUser(String number) async {
    // CommonFunction().showProgressDialog(isShowDialog: true, context: context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    debugPrint("Number +91$number");
    _auth.verifyPhoneNumber(
        phoneNumber: "+91$number",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            debugPrint("USERRRRRR $user");
          } else {
            print("Error");
          }
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          debugPrint(
              "VVVVVVVVVVVVV ${verificationId} , token $forceResendingToken");
          userVerificationId = verificationId;
          // showOTPDialog();
        },
        codeAutoRetrievalTimeout: null);
    //CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  verifyCode() async {
    //return true;
    try {
      String enteredOTPCode = _pinPutController.text.trim().toString();
      if (enteredOTPCode.isNotEmpty) {
        CommonFunction()
            .showProgressDialog(isShowDialog: true, context: context);
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
          await CommonFunction()
              .showProgressDialog(isShowDialog: false, context: context);
          debugPrint("UUUUUUUUUUUUUU ${user.phoneNumber}");
          return true;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ResetPasswordPage(
          //               phoneNo: widget.phone,
          //             )));
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
      debugPrint("ExceptionAuth : ${e.toString()}");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
    return false;
  }
}
