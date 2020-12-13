import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/pages/homeScreen/tab/gigs/tasks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/internship/internship_details.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/cashbacks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/offers_page_details.dart';
import 'package:markBoot/pages/homeScreen/tab/tournament/tournament_details_page.dart';

import 'style.dart';

class CommonWidget {
  List<int> colors = [
    0xff11232D,
    0xff1C2D41,
    0Xff343A4D,
    0xff4F4641,
    0xff434343,
    0xff2A2A28
  ];

  List<int> textColors = [0xff00E676, 0xffEEFF41, 0xffE0E0E0, 0xffffffff];
  List<int> cardColor = [
    CommonStyle().cardColor1,
    CommonStyle().cardColor2,
    CommonStyle().cardColor3,
    CommonStyle().cardColor4
  ];

  Random random = Random();

  Widget commonTextField(
      {@required TextEditingController controller,
      String hintText,
      keyboardType = TextInputType.text,
      obscureText = false,
      String inputText = "",
      int lines}) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hintText ?? "",
            style: TextStyle(color: Colors.black),
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              height: lines == null ? 50 : 100,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.white))),
              child: TextField(
                maxLines: lines ?? 1,
                obscureText: obscureText,
                keyboardType: keyboardType,
                controller: controller,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: inputText,
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget commonCard(DocumentSnapshot snapshot, context, postType,
      {subtype, disable = false, int cardColor = 0xff294073}) {
    print(snapshot.data);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Color(CommonStyle().blueCardColor),
          child: InkWell(
            onTap: () {
              print("$postType $subtype");
              //if (postType.contains("Admin")) {}
              if (subtype.toLowerCase().toString().contains("cashback")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CashbacksPageDetails(
                              snapshot: snapshot,
                              type: "Offers",
                              subType: "Cashbacks",
                            )));
              } else if (subtype.toLowerCase().toString().contains("50")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CashbacksPageDetails(
                              snapshot: snapshot,
                              type: "Offers",
                              subType: "50 on 500",
                            )));
              } else if (subtype.toLowerCase().toString().contains("coupons")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CashbacksPageDetails(
                              snapshot: snapshot,
                              type: "Offers",
                              subType: "Coupons",
                            )));
              } else if (subtype
                  .toLowerCase()
                  .toString()
                  .contains("internship")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InternshipPageDetails(
                              snapshot: snapshot,
                              type: "Internship",
                              subType: "Internship",
                            )));
              } else if (subtype.contains("Tournament")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TournamentDetailsPage(
                            snapshot: snapshot,
                            type: postType,
                            subType: subtype))).then((value) {
                  //if (value == true) {}
                });

                // This will run when the user is navigated from the gigs page
              }
              else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TasksPageDetails(
                              snapshot: snapshot,
                              type: postType,
                              subType: subtype,
                              isDisabled: disable,
                            ))).then((value) {
                  print("hello");
                  if (value == true) {}
                });
              }
            },
            child: postType == "Internship"
                ? Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width*0.2,
                            height: MediaQuery.of(context).size.width*0.2,
                            decoration: BoxDecoration(
                                //  color: Color(0xff051094),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                     scale: 3,
                                  image: NetworkImage(
                                    snapshot["logoUri"].toString(),
                                  ),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        snapshot["companyName"] ?? "",
                                        style: TextStyle(
                                          //                  color: Color(CommonStyle().lightYellowColor),
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*.60,
                                      height: MediaQuery.of(context).size.height*0.06,
                                      child: Text(
                                        snapshot["taskTitle"] ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Color(0xff051094),
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    SizedBox(height: 5),
                                    // Center(
                                    //   child: Text(
                                    //     "Location : ${snapshot["location"]}" ??
                                    //         "",
                                    //     style: TextStyle(
                                    //       //            color: Color(CommonStyle().lightYellowColor),
                                    //       color: Colors.black,
                                    //       fontSize: 13,
                                    //     ),
                                    //   ),
                                    // ),
                                    Center(
                                      child: Text(
                                        "${snapshot["salary"]} per month" ?? "",
                                        style: TextStyle(
                                          //         color: Color(CommonStyle().lightYellowColor),
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    // Center(
                                    //   child: Text(
                                    //     "Duration : ${snapshot["duration"]}" ??
                                    //         "",
                                    //     style: TextStyle(
                                    //       //                  color: Color(CommonStyle().lightYellowColor),
                                    //       color: Colors.black,

                                    //       fontSize: 13,
                                    //     ),
                                    //   ),
                                    // ),
                                    // Center(
                                    //   child: Text(
                                    //     "Apply By : ${snapshot["applyBy"]}" ?? "",
                                    //     style: TextStyle(
                                    //       //           color: Color(CommonStyle().lightYellowColor),
                                    //       color: Colors.black,

                                    //       fontSize: 13,
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Visibility(
                                      visible: (postType.contains("Internship"))
                                          ? false
                                          : true,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10, left: 10, right: 4),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/icons/bank.png",
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text(
                                              (postType.contains("Offers")
                                                      ? snapshot[
                                                          "cashbackAmount"]
                                                      : snapshot["reward"]) ??
                                                  "0",
                                              style: TextStyle(
                                                  color: Colors.yellow),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width*0.2,
                            height: MediaQuery.of(context).size.width*0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        snapshot["logoUri"].toString()))),
                          ),
                          Container(
                            margin: EdgeInsets.all(3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // snapshot["taskTitle"] ?? "",
                                    Container(
                                      width: MediaQuery.of(context).size.width*.60,
                                      height: MediaQuery.of(context).size.height*0.058,
                                      child: Text(
                                        snapshot["taskTitle"] ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      child: Center(
                                        child: Text(
                                          snapshot["companyName"] ?? "",
                                          style: TextStyle(
                                            //                  color: Color(CommonStyle().lightYellowColor),
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: (postType.contains("Internship")|| postType.contains("Offers"))
                                      ? false
                                      : true,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 1,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 4),
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.red)),
                                      child: Container(
                                        margin: EdgeInsets.all(2),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/icons/bank.png",
                                              width: 10,
                                              height: 10,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              (postType.contains("Offers")
                                                      ? snapshot["cashbackAmount"]
                                                      : snapshot["reward"]) ??
                                                  "0",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          )),
    );
  }
}
