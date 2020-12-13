import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/adminPages/camapign.dart';
import 'package:markBoot/pages/homeScreen/adminPages/campaigns/campaigns.dart';
import 'package:markBoot/pages/homeScreen/adminPages/payment_transact.dart';
import 'package:markBoot/pages/homeScreen/adminPages/post_list_page.dart';
import 'package:markBoot/pages/homeScreen/adminPages/refer_earn_admin.dart';
import 'package:markBoot/pages/homeScreen/adminPages/send_emails.dart';
import 'package:markBoot/pages/singup/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_post_ui.dart';
import 'amountReqUser_page.dart';
import 'offers_details_admin.dart';
import 'refer_earn_admin.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<String> types = ["Gigs", "Offers", "Internship", "Tournament"];
  String selectedType;
  String selectedSubType;
  List<String> subTypeList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CommonStyle().backgroundColor),
      appBar: AppBar(
        //backgroundColor: Color(CommonStyle().appbarColor),
        backgroundColor: Color(0xff051094),
        title: Text(
          "MarkBoot",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: <Widget>[
         IconButton(
           icon: Icon(Icons.email),
           onPressed: (){
             Navigator.push(context, MaterialPageRoute(
               builder: (context) => SendEmailAdmin()
             ));
           },
         ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AmountReqUserListPage()));
              },
              child: Icon(Icons.markunread_mailbox)),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => payment_transact()));
            },
            child: Icon(Icons.account_balance_wallet),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              logout(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Color(CommonStyle().appbarColor),
        backgroundColor: Colors.amber,
        onPressed: () {
          showPostPopup();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),

              // title, function , path
              itemCard("Gigs", action, "Posts/Gigs/Tasks"),
              itemCard("Campaign", action, "Posts/Gigs/Campaign"),
              itemCard("Offers", action, "Posts/Offers/Cashbacks"),
              itemCard("Internship", action, "Posts/Internship/Tasks"),
              itemCard("Tournament", action, "Posts/Tournament/Tasks"),
              itemCard("Refer", action, "Refer"),
              //itemCard("Refer Earn", action, "Posts/H"),
            ],
          ),
        ),
      ),
    );
  }

  void logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => IntroPage()), (route) => false);
  }

  action(String path, title) {

    // This is for the offers page
    if (path.contains("Cashbacks")) {
      debugPrint("CCCCCCCCCCCCCCCCCCCCC");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => offers()));
    }
    else if(title.contains("Refer")){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ReferEarn()));
    }

    // This is for the Campaign page
    else if (title.contains("Campaign")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Campaigns()));

    }

    // this will be called for the gigs, Internship and also for the Tournament page
    else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostListPage(
                    path: path, // Posts/Gigs/Tasks
                    title: title,  // Gigs for the gigs page
                  )));
    }
  }

  Widget itemCard(title, func, path) {
    return GestureDetector(
      onTap: () {
        func(path, title);
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            //color: Color(CommonStyle().blueColor),
            color: Color(0xff051094),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  showPostPopup() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            color: Colors.transparent,
            child: Center(
              child: Container(
                //  color: Color(CommonStyle().appbarColor),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0xff051094),
                ),
                height: 300,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      constraints: BoxConstraints(maxWidth: 260),
                      child: DropdownButton(
                        hint: Text(
                          "Select type",
                          style: TextStyle(color: Colors.white70),
                        ),
                        underline: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        dropdownColor: Color(0xff051094),
                        style: TextStyle(),
                        isExpanded: true,
                        onChanged: (value) {
                          selectedType = value;
                          selectedSubType = null;
                          subTypeList.clear();
                          if (selectedType.contains("Gigs")) {
                            subTypeList.add("Gigs");
                            subTypeList.add("Campaign");
                          } else if (selectedType.contains("Offers")) {
                            subTypeList.add("Moneyback"); //Cashbacks
                            subTypeList.add("Wow Offers");
//                        subTypeList.add("Top Offers");
                          } else if (selectedType.contains("Internship")) {
                            subTypeList.add("Internship");
                          } else if (selectedType.contains("Tournament")) {
                            subTypeList.add("Tournament");
                          }
                          Navigator.pop(context);
                          showPostPopup();
                          setState(() {});
                        },
                        value: selectedType,
                        items: types.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      constraints: BoxConstraints(maxWidth: 260),
                      child: DropdownButton(
                        hint: Text(
                          "Select sub type",
                          style: TextStyle(color: Colors.white70),
                        ),
                        underline: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        dropdownColor: Color(0xff051094),
                        style: TextStyle(),
                        isExpanded: true,
                        onChanged: (value) {
                          selectedSubType = value;
                          Navigator.pop(context);
                          showPostPopup();
                          setState(() {});
                        },
                        value: selectedSubType,
                        items: subTypeList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 160,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          if (selectedSubType == "Moneyback")
                            selectedSubType = "Cashbacks";
                          else if (selectedSubType == "Wow Offers")
                            selectedSubType = "50 on 500";
                          else if (selectedSubType == "Top Offers")
                            selectedSubType = "Coupons";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPostAdminPage(
                                        type: selectedType,
                                        subtype: selectedSubType,
                                      )));
                        },
                        child: Text("Create"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
