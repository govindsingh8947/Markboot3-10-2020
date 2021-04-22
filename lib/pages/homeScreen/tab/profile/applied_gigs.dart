import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/post_list_ui.dart';

class applied_gigs extends StatefulWidget {
  @override
  _applied_gigsState createState() => _applied_gigsState();
}

class _applied_gigsState extends State<applied_gigs>
    with SingleTickerProviderStateMixin {
  List<DocumentSnapshot> usersList = new List();
  bool isShowInitBar = true;
  List maps_gigs = [];
  List maps_campaign = [];
  List maps_offers = [];

  getpref() async {
    // FOR THE GIGS
    List mapi = [];
    List<DocumentSnapshot> snaps =
        await CommonFunction().getPost("Posts/Gigs/Tasks");
    //print(snaps[0].data);
    for (DocumentSnapshot snapshot in snaps) {
      for (var map in snapshot.data["submittedBy"]) {
        //print(map);
        if (map["status"] == "pending") {
          map["documentId"] = snapshot.documentID.toString();
          print(map);

          //setState(() {
          mapi.add(map);

          //});
        }
      }
    }
    setState(() {
      maps_gigs = mapi;
    });

    // FOR THE OFFERS
    List mapi_offers = [];
    snaps = await CommonFunction().getPost("Posts/Offers/Tasks");
    //print(snaps[0].data);
    for (DocumentSnapshot snapshot in snaps) {
      for (var map in snapshot.data["submittedBy"]) {
        //print(map);
        if (map["status"] == "pending") {
          map["documentId"] = snapshot.documentID.toString();
          print(map);

          //setState(() {
          mapi_offers.add(map);

          //});
        }
      }
    }
    setState(() {
      maps_offers = mapi_offers;
    });

    // FOR THE CAMPAIGN
    List mapi_cam = [];
    snaps = await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
    //print(snaps[0].data);
    for (DocumentSnapshot snapshot in snaps) {
      for (var map in snapshot.data["submittedBy"]) {
        //print(map);
        if (map["status"] == "pending") {
          map["documentId"] = snapshot.documentID.toString();
          print(map);

          //setState(() {
          mapi_cam.add(map);

          //});
        }
      }
    }
    setState(() {
      maps_campaign = mapi_cam;
    });
    // print(maps.length);

    print(maps_gigs.length);
    print(maps_campaign.length);
    print(maps_offers.length);
  }

  init() async {
    getpref();
    isShowInitBar = false;
  }

  TabController _tabController;
  @override
  void initState() {
    init();
    _tabController = TabController(length: 3, vsync: this);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0xff051094),
            title: Text("Campaign"),
            bottom: TabBar(
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
                // moneyback- cashbacks ,wow offers-50 on 500,top offers - coupons
                Container(
                  width: 150,
                  child: Tab(
                    child: Text("Gigs"),
                  ),
                ),
                Container(width: 150, child: Tab(child: Text("Campaign"))),
                Container(width: 150, child: Tab(child: Text("Ongoing"))),
              ],
            )),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PostListUIPage(
              //docMap: pendingTasks,
              path: "Posts/Gigs/Tasks",
              type: "Gigs",
              subType: "Tasks",
              status: "applied",
            )
            //campaignMap:
            //                                          campaignList)
            ,
            PostListUIPage(
              //docMap: pendingTasks,
              path: "Posts/Gigs/Campaign Tasks",
              type: "Gigs",
              subType: "Campaign Tasks",
              status: "applied",
            ),
            PostListUIPage(
              //docMap: pendingTasks,
              path: "Posts/Gigs/Campaign Tasks",
              type: "Gigs",
              subType: "Campaign Tasks",
              status: "ongoing",
            ),
            // verify("Campaign", "Posts/Gigs/Campaign Tasks"),
            // ongoing(),
            // register()
          ],
        ));
  }
}
