import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/adminPages/admin_homepage.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/intro_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'signup_page.dart';

// This page is shown to the user for 2 seconds only then the user is shifted to the IntroPage
class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  SharedPreferences prefs;
  bool isShowInitProgress = true;

  // This is used for sending the notifications to the user of the app

  start() async {
    return Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return IntroPage();
      }));
    });
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(CommonStyle().introBackgroundColor),
        body: Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: 1000,
            width: 1000,
            child: Lottie.asset("assets/Json/splash.json", repeat: false),
          ),
        ));
  }
}
