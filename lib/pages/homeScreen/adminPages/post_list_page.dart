import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/adminPages/taskUserList_page.dart';
import 'package:markBoot/pages/homeScreen/adminPages/tournament_admin_page.dart';

import 'internship_userlist_page.dart';

class PostListPage extends StatefulWidget {
  String path;
  String title;
  PostListPage({this.title, this.path});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<DocumentSnapshot> snapshots;

  init() async {
    try {
      snapshots = await CommonFunction().getPost(widget.path);
      debugPrint("SSNNNNN $snapshots");
      setState(() {});
    } catch (e) {
      debugPrint("Exception : (init) -> $e");
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff051094),
        title: Text(
          widget.title + " Posts",
        ),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          snapshots != null && snapshots.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    children: snapshots.map((item) {
                      return singleCard(item, context, "Admin");
                    }).toList(),
                  ),
                )
              : (snapshots == null
                  ? SliverToBoxAdapter(
                      child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()),
                      ),
                    ))
                  : SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 100,
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
      ),
    );
  }

  Widget singleCard(DocumentSnapshot snapshot, context, postType, {subtype}) {
    //print("snapi=${snapshot["submittedBy"][0]["companyName"]}");
    //if()

    print(snapshot.data);
//   if( (snapshot["submittedBy"].where((item){
//     if(item["status"]=="applied"){
//       return true;
//     }
//     return false;
//   })).length==0){
//     return Text("");
//   }

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              child: InkWell(
                onTap: () {
                  if (widget.path.contains("Internship")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InternshipUserListPage(
                                  docId: snapshot.documentID,
                                  internshipUserList:
                                      snapshot["appliedBy"] ?? new List(),
                                )));
                  } else if (widget.path.contains("Tournament")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TournamentAdminDetailsPage(
                                  taskUserList:
                                      snapshot["submittedBy"] ?? new List(),
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskUserListPage(
                                taskUserList:
                                    snapshot["submittedBy"] ?? new List(),
                                reward: snapshot["reward"],
                                docId: snapshot.documentID)));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(CommonStyle().blueCardColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      snapshot["uploadWorkUri"] ?? ""))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 2, top: 2, bottom: 2),
                        child: Text(
                          widget.path.contains("Internship")
                              ? snapshot["companyName"] ?? ""
                              : snapshot["submittedBy"][0]["companyName"],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 100,
                        child: Text(
                          widget.path.contains("Internship")
                              ? snapshot["taskTitle"] ?? ""
                              : snapshot["submittedBy"][0]["taskTitle"] ?? "",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //color: Colors.white,

                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        Positioned(
            top: 5,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 18,
              child: Text(
                widget.path.contains("Internship")
                    ? (snapshot["appliedBy"]
                        .where((item) {
                          if (item["status"] == "applied") {
                            return true;
                          }
                          return false;
                        })
                        .length
                        .toString())
                    : (snapshot["submittedBy"]
                        .where((item) {
                          if (item["status"] == "applied") {
                            return true;
                          }
                          return false;
                        })
                        .length
                        .toString()),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )),
        Positioned(
            top: 5,
            left: 8,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 18,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
                onPressed: () async {
                  try {
                    CommonFunction().showProgressDialog(
                        isShowDialog: true, context: context);
                    await Firestore.instance
                        .collection(widget.path)
                        .document(snapshot.documentID)
                        .delete();
                    Fluttertoast.showToast(
                        msg: "delete successfully",
                        textColor: Colors.white,
                        backgroundColor: Colors.green);
                    CommonFunction().showProgressDialog(
                        isShowDialog: false, context: context);
                    snapshots.remove(snapshot);
                    setState(() {});
                  } catch (e) {}
                },
              ),
            ))
      ],
    );
  }
}
