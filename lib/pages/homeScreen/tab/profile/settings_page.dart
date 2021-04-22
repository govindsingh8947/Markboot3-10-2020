import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/singup/intro_page.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_us.dart';

class MoreSettingsPage extends StatefulWidget {
  @override
  _MoreSettingsPageState createState() => _MoreSettingsPageState();
}

class _MoreSettingsPageState extends State<MoreSettingsPage> {
  SharedPreferences prefs;
  String referalCode;

  init() async {
    prefs = await SharedPreferences.getInstance();
    referalCode = prefs.getString("referralCode") ?? "";
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
        appBar: AppBar(
          //   backgroundColor: Color(CommonStyle().appbarColor),
          backgroundColor: Color(0xff051094),
          title: Text(
            "More",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            customListTile(context,
                action: aboutUs,
                leadingIcon: "assets/icons/aboutus.png",
                title: "About Us"),
            customListTile(context,
                action: contactUS,
                leadingIcon: "assets/icons/contactus.png",
                title: "Contact Us"),
            customListTile(context,
                action: privacyPolicy,
                leadingIcon: "assets/icons/privacy.png",
                title: "Privacy Policy"),
            customListTile(context,
                action: share,
                leadingIcon: "assets/icons/share.png",
                title: "Share"),
            customListTile(context,
                action: reportIssue,
                leadingIcon: "assets/icons/issue.png",
                title: "Report Issue"),
            customListTile(context,
                action: logout,
                leadingIcon: "assets/icons/logout.png",
                title: "Logout"),
          ],
        ),
      ),
    );
  }

  Future<void> privacyPolicy() async {
    const url = 'https://markboot.com/privacy%20policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> share() {
    Share.share(
        'Download Markboot using given link https://play.google.com/store/apps/details?id=com.app.markbootapp&hl=en_IN'
        ' and use Referal Code $referalCode');
  }

  Future<void> reportIssue() async {
    const url =
        'mailto:markbootcompany@gmail.com?subject=Report Issue : MarkBoot';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool("isLogin", false);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => IntroPage()), (route) => false);
  }

  Future<void> contactUS() async {
    const url = 'mailto:markbootcompany@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void aboutUs() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutUsPage()));
  }

  Widget customListTile(context, {action, leadingIcon, title}) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: ListTile(
        onTap: () {
          action();
        },
        title: Text(
          title ?? "",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        leading: leadingIcon != null
            ? Image.asset(
                leadingIcon,
                width: 20,
                height: 20,
                color: Colors.red[400],
              )
            : null,
      ),
    );
  }
}
