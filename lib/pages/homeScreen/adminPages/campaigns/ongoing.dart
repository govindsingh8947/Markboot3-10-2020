import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/pages/homeScreen/adminPages/campaigns/OngoingDetailScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ongoing extends StatefulWidget {
  ongoing();

  @override
  _ongoingState createState() => _ongoingState();
}

class _ongoingState extends State<ongoing> with WidgetsBindingObserver {
  Firestore _firestore = Firestore();
  String _localPath;
  bool isShowDownloadBar = false;
  List maps = [];
  bool flag = false;
  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  init() async {
    List<DocumentSnapshot> snaps =
        await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
    List demos = [];
    for (DocumentSnapshot snap in snaps) {
      List applys = snap["submittedBy"];
      for (var r in applys) {
        if (r["status"] == "ongoing") {
          demos.add(r);
          setState(() {
            flag = true;
          });
        }
      }
    }
    maps = demos;
    print(maps.length);
    if (maps.isEmpty) {
      setState(() {
        flag = false;
      });
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    init();
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: flag
          ? Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView.builder(
                    itemCount: maps.length,
                    itemBuilder: (context, index) {
                      return taskUserCard(maps[index]);
                    }),
              ),
            )
          : Center(
              child: Container(
                height: 30,
                child: Text(
                  "No user found",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
    );
  }

  Widget taskUserCard(Map<String, dynamic> userData) {
    // if (userData["status"] != "applied") {
    //   return Text("");
    // }
    print(userData);
    return Container(
      //height: 100,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xff051094)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leftWidget(userData),
        ],
      ),
    );
  }

  Widget leftWidget(Map<String, dynamic> userData) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OngoingDetailScreen(
                      phone: userData["phone"],
                      name: userData["name"],
                      email: userData["emailId"],
                      task: userData["taskTitle"],
                      company: userData["companyName"],
                    )));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(userData["taskTitle"] ?? "",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 5,
            ),
            Text(
              userData["name"] ?? "",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              userData["emailId"] ?? "",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              userData["phoneNo"] ?? "",
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
