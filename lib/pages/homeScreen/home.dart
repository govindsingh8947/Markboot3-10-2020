import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:markBoot/common/bottom_bar_nav.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/tab/gigs/gigs_page_tab.dart';
import 'package:markBoot/pages/homeScreen/tab/gigs/tasks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/internship/internship_details.dart';
import 'package:markBoot/pages/homeScreen/tab/internship/internship_tab.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/cashbacks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/offers_page_tab.dart';
import 'package:markBoot/pages/homeScreen/tab/tournament/tournament_tab.dart';

import 'tab/profile/settings_page.dart';
import 'tab/profile/user_profile_tab.dart';
import 'tab/tournament/tournament_details_page.dart';

ScrollController _scrollController;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _containerMaxHeight = 56, _offset, _delta = 0, _oldOffset = 0;
  int _currentIndex = 0;
  PageController _pageController;
  int currentIndex = 0;
  double _width, _height;
  Firestore _firestore = Firestore.instance;
  CommonWidget commonWidget = CommonWidget();
  CommonFunction commonFunction = CommonFunction();
  List<DocumentSnapshot> documentList;

  init() async {
    documentList = await commonFunction.getPost("Posts/Offers/Cashback");
    debugPrint("DocumentSNAP $documentList");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _pageController = PageController();
    _offset = 0;
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          double offset = _scrollController.offset;
          _delta += (offset - _oldOffset);
          if (_delta > _containerMaxHeight)
            _delta = _containerMaxHeight;
          else if (_delta < 0) _delta = 0;
          _oldOffset = offset;
          _offset = -_delta;
        });
        debugPrint("OFFSET $_offset");
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Color(CommonStyle().darkBlueColor),
      backgroundColor: Color(0xff051094),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox.expand(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                currentIndex = index;
                if (currentIndex != 0) {
                  _offset = 0;
                }
                setState(() => _currentIndex = index);
              },
              children: <Widget>[
                HomeTab(),
                GigsPageTab(),
                OffersPageTab(),
                InternshipPageTab(),
                TournamentPageTab(),
                UserProfileTab(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
          width: double.infinity,
          color: Colors.red,
          height: _offset + 56,
          child: BottomNavyBar(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            backgroundColor: Color(0xff051094),
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  textAlign: TextAlign.start,
                  title: Text('Home'),
                  icon: Image.asset(
                    "assets/icons/home.png",
                    width: MediaQuery.of(context).size.width*0.05,
                    height: 20,
                    color: Colors.white,
                  )),
              BottomNavyBarItem(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  title: Text('Gigs'),
                  icon: Image.asset(
                    "assets/icons/gigs.png",
                    width: MediaQuery.of(context).size.width*0.05,
                    height: 20,
                    color: Colors.white,
                  )),
//              home,gigs,offers,internship, tournament,profile
              BottomNavyBarItem(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  title: Text('Offers'),
                  icon: Image.asset(
                    "assets/icons/offers.png",
                    width: MediaQuery.of(context).size.width*0.055,
                    height: 28,
                    color: Colors.white,
                  )),
              BottomNavyBarItem(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  title: Text('Internship'),
                  icon: Image.asset(
                    "assets/icons/internship.png",
                    width: MediaQuery.of(context).size.width*0.05,
                    height: 20,
                    color: Colors.white,
                  )),
              BottomNavyBarItem(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  title: Text('Tournament'),
                  icon: Image.asset(
                    "assets/icons/tourn.png",
                    width: MediaQuery.of(context).size.width*0.05,
                    height: 20,
                    color: Colors.white,
                  )),
              BottomNavyBarItem(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  title: Text('Profile'),
                  icon: Image.asset(
                    "assets/icons/user.png",
                    width:MediaQuery.of(context).size.width*0.05,
                    height: 20,
                    color: Colors.white,
                  )),
            ],
          )),
    );
  }

  Future<void> _onRefresh() async {
    documentList = await commonFunction.getPost("Posts/Offers/Cashbacks");
    debugPrint("REFRESHSNAP $documentList");
    return;
  }
}

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  List<String> introImages = [
    "assets/icons/list.png",
    "assets/icons/money.png",
    "assets/icons/purchase.png"
  ];
  List<DocumentSnapshot> documentList_cash;
  List<DocumentSnapshot> documentList_50_50;

  List<Map> headerSwipeList;
  TabController _tabController;
  SwiperController swiperCont = new SwiperController();

  init() async {
    try {
      documentList_cash =
          await CommonFunction().getPost("Posts/Offers/Cashbacks");
      documentList_50_50 =
          await CommonFunction().getPost("Posts/Offers/50 on 500") ??
              new List();

      int i = 1;
      headerSwipeList = new List();
      for (DocumentSnapshot snapshot in documentList_cash) {
        DocumentSnapshot snap = snapshot;
        headerSwipeList.add({"type": "Cashbacks", "docx": snap});
        print(snapshot.data);
        if (i == 3) break;
        i++;
      }
      for (DocumentSnapshot snapshot in documentList_50_50) {
        DocumentSnapshot snap = snapshot;
        headerSwipeList.add({"type": "50 on 50", "docx": snap});
        if (i == 3) break;
        i++;
      }
      debugPrint("DocumentSNAP $documentList_50_50");

      debugPrint("DocumentSNAP $documentList_cash");
      setState(() {});
    } catch (e) {
      debugPrint("Exception : (init)-> $e");
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Color(CommonStyle().blueColor),
          backgroundColor: Color(0xff051094),
          title: Text(
            "MarkBoot",
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
//            SliverToBoxAdapter(
//              child: Align(
//                alignment: Alignment.centerLeft,
//                child: Container(
//                  margin: EdgeInsets.only(left: 20,top: 10),
//                  child: CircleAvatar(
//                    radius: 30,
//                    backgroundImage: AssetImage("assets/icons/mb_icon.png",),
//                  ),
//                ),
//              )
//            ),

            SliverToBoxAdapter(child: swiperBody()),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
//
//            documentList != null && documentList.length > 0 ?
//            SliverPadding(
//              padding: const EdgeInsets.all(20),
//              sliver: SliverGrid.count(
//                crossAxisSpacing: 10,
//                mainAxisSpacing: 10,
//                crossAxisCount: 2,
//                childAspectRatio: 2 / 3,
//                children: documentList.map((item) {
//                  return CommonWidget().commonCard(
//                      item, context, "Gigs", subtype: "Tasks");
//                }).toList(),
//              ),
//            ) :
//            (
//                documentList == null ?
//                SliverToBoxAdapter(
//                    child: Container(
//                      margin: EdgeInsets.only(top: 0),
////                      child: Center(
////                        child: Container(
////                            width: 30,
////                            height: 30,
////                            child: CircularProgressIndicator()),
////                      ),
//                    )
//                )
//                    : SliverToBoxAdapter(
//                  child: Container(
//                    margin: EdgeInsets.only(top: 250),
//                    child: Center(
//                      child: Container(
//                        child: Text("No Data Found",
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 18
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                )
//            ),
            SliverToBoxAdapter(
              child: Container(height: 750, child: RecentPageView()),
            )
          ],
        ));
  }

  Widget swiperBody() {
    return Container(
        height: 200,
        margin: EdgeInsets.only(top: 10),
        child: headerSwipeList == null
            ? Container(
                margin: EdgeInsets.only(top: 0),
                child: Center(
                  child: Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator()),
                ),
              )
            : Swiper(
                loop: true,
                autoplay: true,
                controller: SwiperController(),
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Color(CommonStyle().lightYellowColor),
                        activeSize: 13.0,
                        size: 10)),
                itemHeight: 200,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print(headerSwipeList[index]["type"]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CashbacksPageDetails(
                                        snapshot: headerSwipeList[index]
                                            ["docx"],
                                        type: "Offers",
                                        subType: headerSwipeList[index]["type"],
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(headerSwipeList[index]
                                      ["docx"]["imgUri"]))),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Text(
                          "",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  );
                },
                itemCount:
                    headerSwipeList == null ? 0 : (headerSwipeList.length),
                scale: 0.6,
                fade: 0.5,
                viewportFraction: 0.95,
              ));
  }
}

class RecentPageView extends StatefulWidget {
  @override
  _RecentPageViewState createState() => _RecentPageViewState();
}

class _RecentPageViewState extends State<RecentPageView> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  int activePageIndex = 0;
  List<DocumentSnapshot> gigsSnapList = new List();
  List<DocumentSnapshot> offersSnapList = new List();
  List<DocumentSnapshot> internshipSnapList = new List();
  List<DocumentSnapshot> tournamentSnapList = new List();
  List<int> cardColor = [
    CommonStyle().cardColor1,
    CommonStyle().cardColor2,
    CommonStyle().cardColor3,
    CommonStyle().cardColor4
  ];

  init() async {
    try {
      QuerySnapshot gigsQuerySnap = await Firestore.instance
          .collection("Posts")
          .document("Gigs")
          .collection("Gigs")
          .getDocuments();
      int len = 0;
      for (DocumentSnapshot snapshot in gigsQuerySnap.documents) {
        gigsSnapList.add(snapshot);
        len++;
        if (len >= 4) break;
      }
      setState(() {});
      QuerySnapshot offersQuerySnap = await Firestore.instance
          .collection("Posts")
          .document("Offers")
          .collection("Cashbacks")
          .getDocuments();
      len = 0;
      for (DocumentSnapshot snapshot in offersQuerySnap.documents) {
        offersSnapList.add(snapshot);
        len++;
        if (len >= 4) break;
      }
      QuerySnapshot internshipQuerySnap = await Firestore.instance
          .collection("Posts")
          .document("Internship")
          .collection("Internship")
          .getDocuments();
      len = 0;
      for (DocumentSnapshot snapshot in internshipQuerySnap.documents) {
        internshipSnapList.add(snapshot);
        len++;
        if (len >= 4) break;
      }
      QuerySnapshot tournamentQuerySnap = await Firestore.instance
          .collection("Posts")
          .document("Tournament")
          .collection("Tournament")
          .getDocuments();
      len = 0;
      for (DocumentSnapshot snapshot in tournamentQuerySnap.documents) {
        tournamentSnapList.add(snapshot);
        len++;
        if (len >= 4) break;
      }
      setState(() {});
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //color: Color(CommonStyle().blueColor),
          color: Color(0xff051094),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "RECENTS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 70,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: activePageIndex == 0
                              ? Color(CommonStyle().lightYellowColor)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Gigs",
                        style: TextStyle(
                            color: activePageIndex == 0
                                ? Colors.white
                                : Color(0xff051094),
                            fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 70,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: activePageIndex == 1
                              ? Color(CommonStyle().lightYellowColor)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Offers",
                        style: TextStyle(
                            color: activePageIndex == 1
                                ? Colors.white
                                : Color(0xff051094),
                            fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 70,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: activePageIndex == 2
                              ? Color(CommonStyle().lightYellowColor)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Internship",
                        style: TextStyle(
                            color: activePageIndex == 2
                                ? Colors.white
                                : Color(0xff051094),
                            fontSize: 14),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 90,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: activePageIndex == 3
                              ? Color(CommonStyle().lightYellowColor)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Tournament",
                        style: TextStyle(
                            color: activePageIndex == 3
                                ? Colors.white
                                : Color(0xff051094),
                            fontSize: 14),
                      )),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              activePageIndex = index;
              debugPrint("Index $index");
              setState(() {});
            },
            controller: _controller,
            children: [
              GigsPageWidget(),
              OffersPageWidget(),
              InternshipPageWidget(),
              TournamentPageWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget GigsPageWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
          itemCount: gigsSnapList.length,
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2 / 3),
          itemBuilder: (context, index) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Card(
                  // borderRadius: BorderRadius.circular(10),
                  //color: Colors.transparent,

                  child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TasksPageDetails(
                                snapshot: gigsSnapList[index],
                                type: "Gigs",
                                subType: "Gigs",
                                isDisabled: false,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      gigsSnapList[index]["logoUri"]))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 2, top: 2, bottom: 2),
                        child: Text(
                          gigsSnapList[index]["taskTitle"] ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 60,
                        child: Text(
                          gigsSnapList[index]["companyName"] ?? "",
                          style: TextStyle(
                            //                  color: Color(CommonStyle().lightYellowColor),
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          }),
    );
  }

  Widget OffersPageWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
          itemCount: offersSnapList.length,
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2 / 3),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Card(
                  // color: Colors.transparent,
                  // borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CashbacksPageDetails(
                                snapshot: offersSnapList[index],
                                type: "Offers",
                                subType: "Cashbacks",
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      offersSnapList[index]["logoUri"]))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 2, top: 2, bottom: 2),
                        child: Text(
                          offersSnapList[index]["taskTitle"] ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 60,
                        child: Text(
                          offersSnapList[index]["companyName"] ?? "",
                          style: TextStyle(
                            //                  color: Color(CommonStyle().lightYellowColor),
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          }),
    );
  }

  Widget InternshipPageWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
          itemCount: internshipSnapList.length,
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2 / 3),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Card(
                  // color: Colors.transparent,
                  // borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InternshipPageDetails(
                              snapshot: internshipSnapList[index],
                              type: "Internship",
                              subType: "Internship")));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      internshipSnapList[index]["logoUri"]))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 2, top: 2, bottom: 2),
                        child: Text(
                          internshipSnapList[index]["taskTitle"] ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 60,
                        child: Text(
                          internshipSnapList[index]["companyName"] ?? "",
                          style: TextStyle(
                            //                  color: Color(CommonStyle().lightYellowColor),
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          }),
    );
  }

  Widget TournamentPageWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
          itemCount: tournamentSnapList.length,
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2 / 3),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Card(
                  // color: Colors.transparent,
                  // borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TournamentDetailsPage(
                              snapshot: tournamentSnapList[index],
                              type: "Gigs",
                              subType: "Tasks")));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      tournamentSnapList[index]["logoUri"]))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 2, top: 2, bottom: 2),
                        child: Text(
                          tournamentSnapList[index]["taskTitle"] ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 60,
                        child: Text(
                          tournamentSnapList[index]["companyName"] ?? "",
                          style: TextStyle(
                            //                  color: Color(CommonStyle().lightYellowColor),
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          }),
    );
  }
}
