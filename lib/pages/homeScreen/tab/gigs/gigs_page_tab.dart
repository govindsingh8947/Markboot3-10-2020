import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class GigsPageTab extends StatefulWidget {
  @override
  _GigsPageTabState createState() => _GigsPageTabState();
}

class _GigsPageTabState extends State<GigsPageTab>
    with SingleTickerProviderStateMixin {
  int iscomplete = 1;
  List<DocumentSnapshot> taskDocumentList;
  List<DocumentSnapshot> campaignDocumentList;
  TabController _tabController;
  List<int> cardColor = [
    CommonStyle().cardColor1,
    CommonStyle().cardColor2,
    CommonStyle().cardColor3,
    CommonStyle().cardColor4
  ];

  Future<void> _onTaskRefresh() async {
    taskDocumentList = await CommonFunction().getPost("Posts/Gigs/Gigs");
    setState(() {});
    return;
  }

  Future<void> _onCampaignRefresh() async {
    taskDocumentList = await CommonFunction().getPost("Posts/Gigs/Campaign");
    setState(() {});
    return;
  }

  init() async {
    try {
      taskDocumentList = await CommonFunction().getPost("Posts/Gigs/Gigs");
      campaignDocumentList =
          await CommonFunction().getPost("Posts/Gigs/Campaign");
      setState(() {});
    } catch (e) {
      debugPrint("Exception : (init)-> $e");
    }
    setState(() {
      iscomplete = 0;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              //  backgroundColor: Color(CommonStyle().blueColor),
              backgroundColor: Color(0xff051094),
              title: Text(
                "Gigs",
              ),
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
                  Container(
                    width: 150,
                    child: Tab(
                      child: Text("Gigs"),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Tab(child: Text("Campaigns")),
                  ),
                ],
              )),
          body: iscomplete == 1
              ? Center(
                  child: LoadingFlipping.circle(
                    borderColor: Colors.blue,
                    size: 50,
                    borderSize: 5,
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: <Widget>[taskWidget(), campaignsWidget()],
                )),
    );
  }

  campaignsWidget() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onCampaignRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          campaignDocumentList != null && campaignDocumentList.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 3,
                    children: campaignDocumentList.map((item) {
                      index++;
                      return CommonWidget().commonCard(item, context, "Gigs",
                          subtype: "Campaign Tasks",
                          cardColor: cardColor[(index - 1) % 4]);
                    }).toList(),
                  ),
                )
              : (campaignDocumentList == null
                  ? SliverToBoxAdapter(
                      child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Container(
                            child: LoadingFlipping.circle(
                          borderColor: Colors.blue,
                          size: 50,
                          borderSize: 5,
                        )),
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
      ),
    );
  }

  taskWidget() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onTaskRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          taskDocumentList != null && taskDocumentList.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 3,
                    children: taskDocumentList.map((item) {
                      index++;
                      print(item.data);
                      return CommonWidget().commonCard(item, context, "Gigs",
                          subtype: "Tasks",
                          cardColor: cardColor[(index - 1) % 4]);
                    }).toList(),
                  ),
                )
              : (taskDocumentList == null
                  ? SliverToBoxAdapter(
                      child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Container(
                            child: LoadingFlipping.circle(
                          borderColor: Colors.blue,
                          size: 50,
                          borderSize: 5,
                        )),
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
      ),
    );
  }
}
