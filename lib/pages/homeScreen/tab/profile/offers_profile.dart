import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralTab extends StatefulWidget {
  @override
  _GeneralTabState createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with SingleTickerProviderStateMixin {
  List<DocumentSnapshot> usersList = new List();
  bool isShowInitBar = true;
  List maps_gigs_accepted = [];
  List maps_gigs_rejected = [];

  List maps_campaign_accepted = [];
  List maps_campaign_rejected = [];

  List maps_offers_accepted = [];
  List maps_offers_rejected = [];

  List maps_intern_accepted = [];
  List maps_intern_rejected = [];

  getpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.get("userId");
    String userPhone = prefs.get("userPhoneNo");
    print(userId);
    List mapi_a = [];
    List mapi_r = [];

    // FOR THE GIGS
    List<DocumentSnapshot> snaps =
        await CommonFunction().getPost("Posts/Gigs/Tasks");
    for (DocumentSnapshot snapshot in snaps) {
      for (var map in snapshot.data["submittedBy"]) {
        if ((map["status"] == "pending" || map["status"] == "approved") &&
            map["userId"] == userId) {
          map["documentId"] = snapshot.documentID.toString();
          mapi_a.add(map);
        } else if (map["status"] == "rejected" && map["userId"] == userId) {
          map["documentId"] = snapshot.documentID.toString();
          //print(map);
          mapi_r.add(map);
        }
      }
    }
    setState(() {
      maps_gigs_accepted = mapi_a;
      maps_gigs_rejected = mapi_r;
    });

    // FOR THE OFFERS
    setState(() {
      mapi_a = [];
      mapi_r = [];
    });

    snaps = await CommonFunction().getPost("UsersOffers");
    //print(snaps[0].data);
    for (DocumentSnapshot snapshot in snaps) {
      if (snapshot.data["user phone"] == userPhone) {
        if (snapshot.data["status"] == "approved") {
          Map<String, dynamic> a = {
            "status": "approved",
            "reward": snapshot.data["reward"],
            "offerName": snapshot.data["offer name"],
            "logoUri": snapshot.data["logoUri"],
          };
          mapi_a.add(a);
        } else if (snapshot.data["status"] == "rejected") {
          Map<String, dynamic> r = {
            "status": "approved",
            "reward": snapshot.data["reward"],
            "offerName": snapshot.data["offer name"],
            "logoUri": snapshot.data["logoUri"],
          };
          mapi_a.add(r);
        }
      }
    }
    setState(() {
      maps_offers_accepted = mapi_a;
      maps_offers_rejected = mapi_r;
//      print(maps_offers_accepted.length);
//      print(maps_offers_rejected.length);
    });

    //    // FOR THE CAMPAIGN
    snaps = await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
    //print(snaps[0].data);
    setState(() {
      mapi_a = [];
      mapi_r = [];
    });
    for (DocumentSnapshot snapshot in snaps) {
      for (var map in snapshot.data["submittedBy"]) {
        if ((map["status"] == "pending" || map["status"] == "approved") &&
            map["userId"] == userId) {
          map["documentId"] = snapshot.documentID.toString();
          mapi_a.add(map);
        } else if (map["status"] == "rejected" && map["userId"] == userId) {
          map["documentId"] = snapshot.documentID.toString();
          //print(map);
          mapi_r.add(map);
        }
      }
    }
    setState(() {
      maps_campaign_accepted = mapi_a;
      maps_campaign_rejected = mapi_r;
    });

    // FOR THE INTERNSHIP
    snaps = await CommonFunction().getPost("Posts/Internship/Tasks");
    setState(() {
      mapi_a = [];
      mapi_r = [];
    });
    for (DocumentSnapshot snapshot in snaps) {
      for (var map in snapshot.data["appliedBy"]) {
        if ((map["status"] == "accepted") && map["userId"] == userId) {
          map["documentId"] = snapshot.documentID.toString();
          mapi_a.add(map);
        } else if (map["status"] == "rejected" && map["userId"] == userId) {
          map["documentId"] = snapshot.documentID.toString();
          //print(map);
          mapi_r.add(map);
        }
      }
    }

    setState(() {
      maps_intern_accepted = mapi_a;
      maps_intern_rejected = mapi_r;
      print(maps_intern_accepted.length);
      print(maps_intern_rejected.length);
    });
  }

  init() async {
    getpref();
    isShowInitBar = false;
  }

  TabController _tabController;
  @override
  void initState() {
    init();
    _tabController = TabController(length: 4, vsync: this);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            //backgroundColor: Color(CommonStyle().blueColor),
            backgroundColor: Color(0xff051094),
            title: Text("Journal View"),
            bottom: TabBar(
              isScrollable: true,
              labelColor: Color(0xff051094),
              unselectedLabelColor: Colors.white,
              //indicatorSize: TabBarIndicatorSize.label,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),

              controller: _tabController,
              tabs: <Widget>[
                Container(
                  width: 100,
                  child: Tab(
                    child: Text("Gigs"),
                  ),
                ),
                Container(
                  width: 100,
                  child: Tab(child: Text("Campaign")),
                ),
                Container(
                  width: 100,
                  child: Tab(child: Text("Offers")),
                ),
                Container(
                  width: 100,
                  child: Tab(child: Text("Internships")),
                ),
              ],
            )),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          // color: Colors.blue,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              getgigs(),
              getcampaign(),
              getoffers(),
              getintern()
            ],
          ),
        ));
  }

  int gigs_flag = 0;
  getgigs() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: LoadingFlipping.circle(
                borderColor: Colors.blue,
                size: 50,
                borderSize: 5,
              ),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                          color:
                              gigs_flag == 0 ? Color(0xff051094) : Colors.white,
                          onPressed: () {
                            setState(() {
                              gigs_flag = 0;
                              print(gigs_flag);
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Accepted",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: gigs_flag == 0
                                    ? Colors.white
                                    : Color(0xff051094)),
                          )),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            gigs_flag = 1;
                            print(gigs_flag);
                          });
                        },
                        color:
                            gigs_flag == 1 ? Color(0xff051094) : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Rejected",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: gigs_flag == 1
                                  ? Colors.white
                                  : Color(0xff051094)),
                        ),
                      ),
                    ],
                  ),
                ),
                gigs_flag == 0
                    ? Container(
                        //  color:Colors.red,
                        //padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: (maps_gigs_accepted.length > 0
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  // return Text("hello");
                                  return taskUserCard(maps_gigs_accepted[index],
                                      "gigs", "accepted");
                                },
                                itemCount: maps_gigs_accepted.length,
                              )
                            : Center(
                                child: Container(
                                  child: Text(
                                    "No users found",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              )),
                      )
                    : Container(
                        //color:Colors.red,
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: (maps_gigs_rejected.length > 0
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  // return Text("hello");
                                  return taskUserCard(maps_gigs_rejected[index],
                                      "gigs", "rejected");
                                },
                                itemCount: maps_gigs_rejected.length,
                              )
                            : Center(
                                child: Container(
                                  child: Text(
                                    "No users found",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              )),
                      ),
              ],
            ),
          );
  }

  int camp_flag = 0;
  getcampaign() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: LoadingFlipping.circle(
                borderColor: Colors.blue,
                size: 50,
                borderSize: 5,
              ),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                      color: camp_flag == 0 ? Color(0xff051094) : Colors.white,
                      onPressed: () {
                        setState(() {
                          camp_flag = 0;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Accepted",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: camp_flag == 0
                                ? Colors.white
                                : Color(0xff051094)),
                      )),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        camp_flag = 1;
                      });
                    },
                    color: camp_flag == 1 ? Color(0xff051094) : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Rejected",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: camp_flag == 1
                              ? Colors.white
                              : Color(0xff051094)),
                    ),
                  ),
                ],
              ),
              camp_flag == 0
                  ? Container(
                      // color:Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: (maps_campaign_accepted.length > 0
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                // return Text("hello");
                                return taskUserCard(
                                    maps_campaign_accepted[index],
                                    "campaign",
                                    "accepted");
                              },
                              itemCount: maps_campaign_accepted.length,
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            )),
                    )
                  : Container(
                      // color: Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: (maps_campaign_rejected.length > 0
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                // return Text("hello");
                                return taskUserCard(
                                    maps_campaign_rejected[index],
                                    "campaign",
                                    "rejected");
                              },
                              itemCount: maps_campaign_rejected.length,
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            )),
                    ),
            ],
          );
  }

  int offer_flag = 0;
  getoffers() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: LoadingFlipping.circle(
                borderColor: Colors.blue,
                size: 50,
                borderSize: 5,
              ),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                      color: offer_flag == 0 ? Color(0xff051094) : Colors.white,
                      onPressed: () {
                        setState(() {
                          offer_flag = 0;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Accepted",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: offer_flag == 0
                                ? Colors.white
                                : Color((0xff051094))),
                      )),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        offer_flag = 1;
                      });
                    },
                    color: offer_flag == 1 ? Color(0xff051094) : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Rejected",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: offer_flag == 1
                            ? Colors.white
                            : Color((0xff051094)),
                      ),
                    ),
                  )
                ],
              ),
              offer_flag == 0
                  ? Container(
                      // color:Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: (maps_offers_accepted.length > 0
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                // return Text("hello");
                                return taskUserCard(maps_offers_accepted[index],
                                    "offers", "accepted");
                              },
                              itemCount: maps_offers_accepted.length,
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            )),
                    )
                  : Container(
                      // color: Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: (maps_offers_rejected.length > 0
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                // return Text("hello");
                                return taskUserCard(maps_offers_rejected[index],
                                    "offers", "rejected");
                              },
                              itemCount: maps_offers_rejected.length,
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            )),
                    ),
            ],
          );
  }

  int intern_flag = 0;
  getintern() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: LoadingFlipping.circle(
                borderColor: Colors.blue,
                size: 50,
                borderSize: 5,
              ),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                      color:
                          intern_flag == 0 ? Color(0xff051094) : Colors.white,
                      onPressed: () {
                        setState(() {
                          intern_flag = 0;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Accepted",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: intern_flag == 0
                                ? Colors.white
                                : Color(0xff051094)),
                      )),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        intern_flag = 1;
                      });
                    },
                    color: intern_flag == 1 ? Color(0xff051094) : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Rejected",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: intern_flag == 1
                              ? Colors.white
                              : Color(0xff051094)),
                    ),
                  ),
                ],
              ),
              intern_flag == 0
                  ? Container(
                      // color:Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: (maps_intern_accepted.length > 0
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                // return Text("hello");
                                return taskUserCard(maps_intern_accepted[index],
                                    "intern", "accepted");
                              },
                              itemCount: maps_intern_accepted.length,
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            )),
                    )
                  : Container(
                      // color: Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: (maps_intern_rejected.length > 0
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                //return Text("bye");
                                return taskUserCard(maps_intern_rejected[index],
                                    "intern", "rejected");
                              },
                              itemCount: maps_intern_rejected.length,
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            )),
                    ),
            ],
          );
  }

  Widget taskUserCard(
      Map<String, dynamic> userData, String type, String status) {
    // print("user");
    // print(userData);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Color(CommonStyle().blueCardColor),
            borderRadius: BorderRadius.circular(10)),
        child: Card(
          child: leftWidget(userData, status, type),
        ),
      ),
    );
  }

  Widget leftWidget(Map<String, dynamic> userData, String status, String type) {
    print(userData["taskTitle"]);
    print(userData["companyName"]);
    Size _size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.2,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(userData["logoUri"].toString()))),
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  type == 'offer'
                      ? SizedBox()
                      : Container(
                          width: _size.width / 2,
                          child: Text(
                            userData["taskTitle"] ?? "",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  Text(
                    userData[type == "offers" ? "offerName" : "companyName"] ??
                        "",
                    style: TextStyle(
                      //                  color: Color(CommonStyle().lightYellowColor),
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              type != 'intern'
                  ? Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red)),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/bank.png",
                            width: 10,
                            height: 10,
                            color: Colors.black,
                          ),
                          Text(
                            userData["reward"],
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  Firestore _firestore = Firestore();
}
