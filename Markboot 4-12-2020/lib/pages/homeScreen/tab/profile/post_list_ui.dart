import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/tab/gigs/tasks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/internship/internship_details.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/cashbacks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/tournament/tournament_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostListUIPage extends StatefulWidget {
  @override
  String path;
  String type;
  String subType;
  String status;
  PostListUIPage({this.path, this.type, this.subType, this.status});

  _PostListUIPageState createState() => _PostListUIPageState();
}

class _PostListUIPageState extends State<PostListUIPage>
    with SingleTickerProviderStateMixin {
  List<DocumentSnapshot> taskDocumentList;
  List<DocumentSnapshot> campaignDocumentList;
  TabController _tabController;

  List appliedSnapshot;
  List<DocumentSnapshot> appliedCampaign = new List();

  SharedPreferences prefs;
  String name;
  init() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("userName");
    print(widget.path);
    try {
      taskDocumentList =
          await CommonFunction().getPost(widget.path) ?? new List();

      if (taskDocumentList.length > 0) appliedSnapshot = new List();
      for (DocumentSnapshot snapshot in taskDocumentList) {
        print(snapshot.data);
        // if (widget.docMap.containsKey(snapshot.documentID)) {
//          List<DocumentSnapshot> d=(await CommonFunction().getPost("${widget.path}/${snapshot.documentID}"));
//         print("d=$d");

        var snaps = widget.type == "Internship"
            ? snapshot["appliedBy"]
            : snapshot["submittedBy"];
        for (var maps in snaps) {
          if (name == maps["name"] && maps["status"] == widget.status) {
            print(maps);
            appliedSnapshot.add(maps);
          }
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint("Exception : (init)-> $e");
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == "Internship"
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xff051094),
              title: Text("Applied Interships"),
            ),
            body: postUI(),
          )
        : postUI();
  }

//
//  campaignsWidget() {
//    return  CustomScrollView(
//      primary: false,
//      slivers: <Widget>[
//        appliedCampaign !=null && appliedCampaign.length >0 ?
//        SliverPadding(
//          padding: const EdgeInsets.all(20),
//          sliver: SliverGrid.count(
//            crossAxisSpacing: 10,
//            mainAxisSpacing: 10,
//            crossAxisCount: 2,
//            childAspectRatio: 2/3,
//            children: appliedCampaign.map((item) {
//              return CommonWidget().commonCard(item,context,"Gigs",subtype: "Campaign");
//            }).toList(),
//          ),
//        ) :
//        (
//            appliedCampaign == null ?
//            SliverToBoxAdapter(
//                child: Container(
//                  margin: EdgeInsets.only(top: 50),
//                  child: Center(
//                    child: Container(
//                        width: 30,
//                        height: 30,
//                        child: CircularProgressIndicator()),
//                  ),
//                )
//            )
//                : SliverToBoxAdapter(
//              child: Container(
//                height: MediaQuery.of(context).size.height-200,
//                child: Center(
//                  child: Container(
//                    child: Text("No Data Found",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight:FontWeight.bold,
//                          fontSize: 18
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            )
//        ),
//      ],
//    );
//  }
  postUI() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        appliedSnapshot != null && appliedSnapshot.length > 0
            ? SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 1,
                  childAspectRatio: 3,
                  children: appliedSnapshot.map((item) {
                    //         print(item.data);
                    return commonCard(item, context, widget.type,
                        subtype: widget.subType, disable: true);
                  }).toList(),
                ),
              )
            : (appliedSnapshot == null
                ? SliverToBoxAdapter(
                    child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width*0.2,
                          height: 30,
                          child: CircularProgressIndicator()),
                    ),
                  ))
                : SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Container(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  )),
      ],
    );
  }

  Widget commonCard(var snapshot, context, postType,
      {subtype, disable = false, int cardColor = 0xff294073}) {
    Size _size = MediaQuery.of(context).size;
    // print(snapshot.data);
    return
       Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Color(CommonStyle().blueCardColor),
            child: InkWell(
              onTap: () {},
              child: postType == "Internship"
                  ? Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width-20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width*0.3,
                              height: 150,
                              decoration: BoxDecoration(
                                  //  color: Color(0xff051094),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    //   scale: 3,
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
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            //                  color: Color(CommonStyle().lightYellowColor),
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          snapshot["taskTitle"] ?? "",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Color(0xff051094),
                                              fontSize: 20,
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width*0.2,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(
                                          snapshot["logoUri"].toString()))),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:_size.width/2,
                                        child: Text(
                                          snapshot["taskTitle"] ?? "",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          snapshot["companyName"] ?? "",
                                          style: TextStyle(
                                            //                  color: Color(CommonStyle().lightYellowColor),
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: (postType.contains("Internship"))
                                        ? false
                                        : true,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 1,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border:
                                                Border.all(color: Colors.red)),
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
