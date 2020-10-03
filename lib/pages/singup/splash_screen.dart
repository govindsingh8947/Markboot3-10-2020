import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/adminPages/admin_homepage.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/intro_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'signup_page.dart';

class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  double _width, _height;
  SharedPreferences prefs;
  CommonFunction commonFunction = CommonFunction();
  bool isShowInitProgress = true;
  List<String> introImages = [
    "assets/icons/mb_icon.png",
    "assets/icons/money.png",
    "assets/icons/purchase.png"
  ];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  start() async {
    print("hello");
    return Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return IntroPage();
      }));
    });
  }

  @override
  void initState() {
    super.initState();

    start();

    //print("ddjj");
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    //print(_width);
    return Scaffold(
        //backgroundColor :Color(0xff051094),
        backgroundColor: Color(CommonStyle().introBackgroundColor),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              swiperBody(),
              header(),

              // SizedBox(
              //   height: 30,
              // ),
              //bottom()
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      //   color: Colors.blue,
      //padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: _height * .10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mark",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
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
    );
  }

  Widget swiperBody() {
    return Container(
      width: 200,
      height: 200,
      // padding: EdgeInsets.all(50),
      // margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
      child: Image.asset(
        "assets/icons/mb_icon.png",
        //    color: Colors.white,
      ),
    );
  }
}
