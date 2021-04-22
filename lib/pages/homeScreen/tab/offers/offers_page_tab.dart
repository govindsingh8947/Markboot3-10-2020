import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class OffersPageTab extends StatefulWidget {
  bool isRedirectFromProfile;
  Map<String, dynamic> docList;

  OffersPageTab({this.docList, this.isRedirectFromProfile});

  @override
  _OffersPageTabState createState() => _OffersPageTabState();
}

class _OffersPageTabState extends State<OffersPageTab>
    with SingleTickerProviderStateMixin {
  int iscomplete = 1;
  List<DocumentSnapshot> cashbackDocumentList;
  List<DocumentSnapshot> on500DocumentList;
  List<DocumentSnapshot> couponsDocumentList;
  TabController _tabController;
  List<int> cardColor = [
    CommonStyle().cardColor1,
    CommonStyle().cardColor2,
    CommonStyle().cardColor3,
    CommonStyle().cardColor4
  ];

  Future<void> _onCashbackRefresh() async {
    cashbackDocumentList =
        await CommonFunction().getPost("Posts/Offers/Cashbacks");
    if (widget.isRedirectFromProfile == true) {
      List<DocumentSnapshot> localSnapshot = new List();
      for (DocumentSnapshot snapshot in cashbackDocumentList) {
        if (widget.docList.containsKey(snapshot.documentID)) {
          localSnapshot.add(snapshot);
        }
      }
      cashbackDocumentList = localSnapshot;
    }
    setState(() {});
    return;
  }

  Future<void> _on500Refresh() async {
    on500DocumentList =
        await CommonFunction().getPost("Posts/Offers/50 on 500");
    if (widget.isRedirectFromProfile == true) {
      List<DocumentSnapshot> localSnapshot = new List();
      for (DocumentSnapshot snapshot in on500DocumentList) {
        if (widget.docList.containsKey(snapshot.documentID)) {
          localSnapshot.add(snapshot);
        }
      }
      on500DocumentList = localSnapshot;
    }
    setState(() {});
    return;
  }

  Future<void> _onCouponsRefresh() async {
    on500DocumentList = await CommonFunction().getPost("Posts/Offers/Coupons");
    setState(() {});
    return;
  }

  init() async {
    try {
      cashbackDocumentList =
          await CommonFunction().getPost("Posts/Offers/Cashbacks");
      if (widget.isRedirectFromProfile == true) {
        List<DocumentSnapshot> localSnapshot = new List();
        for (DocumentSnapshot snapshot in cashbackDocumentList) {
          if (widget.docList.containsKey(snapshot.documentID)) {
            localSnapshot.add(snapshot);
          }
        }
        cashbackDocumentList = localSnapshot;
      }
      setState(() {});
      on500DocumentList =
          await CommonFunction().getPost("Posts/Offers/50 on 500");
      if (widget.isRedirectFromProfile == true) {
        List<DocumentSnapshot> localSnapshot = new List();
        for (DocumentSnapshot snapshot in on500DocumentList) {
          if (widget.docList.containsKey(snapshot.documentID)) {
            localSnapshot.add(snapshot);
          }
        }
        on500DocumentList = localSnapshot;
      }
      setState(() {});
      couponsDocumentList =
          await CommonFunction().getPost("Posts/Offers/Coupons");
      if (widget.isRedirectFromProfile == true) {
        List<DocumentSnapshot> localSnapshot = new List();
        for (DocumentSnapshot snapshot in couponsDocumentList) {
          if (widget.docList.containsKey(snapshot.documentID)) {
            localSnapshot.add(snapshot);
          }
        }
        couponsDocumentList = localSnapshot;
      }
      setState(() {});
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0xff051094),
            // backgroundColor: Color(CommonStyle().blueColor),
            title: Text(
              widget.isRedirectFromProfile == true ? "Applied" : "Offers",
              style: TextStyle(color: Colors.white),
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
                // moneyback- cashbacks ,wow offers-50 on 500,top offers - coupons
                Container(
                  width: 150,
                  child: Tab(
                    child: Text("Moneyback"),
                  ),
                ),
                Container(
                  width: 150,
                  child: Tab(child: Text("Wow Offers")),
                ),
//                Tab(
//                    child: Text("Top Offers")
//                ),
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
                children: <Widget>[
                  cashbackWidget(),
                  on500Widget(),
                  //  couponsWidget(),
                ],
              ));
  }

  cashbackWidget() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onCashbackRefresh,
      child: cashbackDocumentList != null && cashbackDocumentList.length > 0
          ? CustomScrollView(
              primary: false,
              slivers: <Widget>[
                cashbackDocumentList != null && cashbackDocumentList.length > 0
                    ? SliverPadding(
                        padding: const EdgeInsets.all(10),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 1,
                          childAspectRatio: 3,
                          children: cashbackDocumentList.map((item) {
                            index++;
                            return CommonWidget().commonCard(
                                item, context, "Offers",
                                subtype: "Cashbacks",
                                cardColor: cardColor[(index - 1) % 4]);
                          }).toList(),
                        ),
                      )
                    : (cashbackDocumentList == null
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
            )
          : Center(
              child: Text(
                "Data Not Found",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
    );
  }

  on500Widget() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _on500Refresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          on500DocumentList != null && on500DocumentList.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 3,
                    children: on500DocumentList.map((item) {
                      index++;
                      return CommonWidget().commonCard(item, context, "Offers",
                          subtype: "50 on 500",
                          cardColor: cardColor[(index - 1) % 4]);
                    }).toList(),
                  ),
                )
              : (on500DocumentList == null
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

  couponsWidgt() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onCouponsRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          couponsDocumentList != null && couponsDocumentList.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 2 / 3,
                    children: couponsDocumentList.map((item) {
                      index++;
                      return CommonWidget().commonCard(item, context, "Offers",
                          subtype: "Coupons",
                          cardColor: cardColor[(index - 1) % 4]);
                    }).toList(),
                  ),
                )
              : (couponsDocumentList == null
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
