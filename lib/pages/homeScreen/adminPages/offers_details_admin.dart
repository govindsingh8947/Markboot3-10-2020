import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class offers extends StatefulWidget {
  //String type;
  //String subtype;

  offers();

  @override
  _offersState createState() => _offersState();
}

class _offersState extends State<offers> {
  CommonWidget commonWidget = CommonWidget();
  List<String> types = ["Moneyback", "Wow Offers"];
  String selectedType;


  TextEditingController com_name = TextEditingController();
  TextEditingController user_name = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_phone = TextEditingController();
  TextEditingController user_reward = TextEditingController();
//  TextEditingController  = TextEditingController();
  TextEditingController descrip = TextEditingController();
//  TextEditingController cashbackLinkCont = TextEditingController();
//  TextEditingController salaryCont = TextEditingController();
//  TextEditingController locationCont = TextEditingController();
//  TextEditingController durationCont = TextEditingController();
//  TextEditingController categoryCont = TextEditingController();
//  TextEditingController designationCont = TextEditingController();
//  TextEditingController startDateCont = TextEditingController();
//  TextEditingController applyByCont = TextEditingController();
//  TextEditingController skillsReqCont = TextEditingController();
//
  init() {}

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff051094),
        title: Text(
          "Offers",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color(CommonStyle().backgroundColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: commonWidget.commonTextField(
                    controller: com_name, inputText: "Offer Name")),
            SizedBox(
              height: 20,
            ),
            DropdownButton(
              hint: Text("Select the offers"),
              value: selectedType,
              items: List.generate(
                  2,
                  (index) => DropdownMenuItem(
                        child: Text(types[index]),
                        value: types[index],
                      )),
              onChanged: (val) {
                setState(() {
                  selectedType = val;
                });
              },
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_name, inputText: "Name")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_email, inputText: "email address")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_phone, inputText: "Phone No")),
            SizedBox(
              height: 20,
            ),
            Center(
                child: commonWidget.commonTextField(
                    controller: user_reward, inputText: "Reward")),
            SizedBox(
              height: 20,
            ),
//            Center(child: commonWidget.commonTextField(controller: descrip,inputText: "Description")),
//            SizedBox(
//              height: 30,
//            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 260),
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
//                  checkTaskService();
                  String company = com_name.text.trim().toString();
                  String name = user_name.text.trim().toString();
                  String phone = user_phone.text.trim().toString();
                  String email = user_email.text.trim().toString();
                  String reward = user_reward.text.trim().toString();
                  // String desc = descrip.toString();

//                  String company="google";
//                  String name="ashish";
//                  String phone="8532956668";
//                  String reward="20";
//                  String desc="nmndmnsd";
//                  String email="ashish@gmail.com";
//                  print(company.length);
//                  print(company.isEmpty);

                  if (company.isEmpty ||
                      name.isEmpty ||
                      phone.isEmpty ||
                      email.isEmpty ||
                      reward.isEmpty) {
                    print("Please enter the data");
                  } else {
                    List<DocumentSnapshot> users =
                        await CommonFunction().getPost("Users");
                    List<DocumentSnapshot> campaigns;
                    if (selectedType == "Moneyback") {
                      campaigns = await CommonFunction()
                          .getPost("Posts/Offers/Cashbacks");
                    } else {
                      campaigns =
                          await CommonFunction().getPost("Posts/Gigs/50 on 50");
                    }
                    //  print(users);
                    //print(campaigns);

                    DocumentSnapshot use;
                    DocumentSnapshot campaign;
                    for (var user in users) {
//                      print(user.documentID.toString()=="+91${phone}");
                      // print(user.data);
//                      print(user.data["emailId"]);
                      //                    print(email);
                      //                  print("\n");
                      if (user.documentID.toString() == "+91${phone}" &&
                          user.data["emailId"] == email) {
                        print("user Got it");
                        setState(() {
                          use = user;
                        });
                      }
                    }
                    for (var cam in campaigns) {
                      print(cam.data["taskTitle"]);
                      if (cam.data["taskTitle"].toString() == company) {
                        print(" campaign Got it");
                        setState(() {
                          campaign = cam;
                        });
                      }
                      if (use != null && campaign != null) {
                        print("found");
                        _showMyDialog(use, campaign);
                      } else {
                        print("Data not Found");
                      }
                    }
                    _showMyDialog(use ,campaign);
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  fieldClear() {
    //selectedType = null;
    com_name.clear();
    user_name.clear();
    user_phone.clear();
    user_email.clear();
    user_reward.clear();
  }

  Future<void> _showMyDialog(
      DocumentSnapshot user, DocumentSnapshot campaign) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do want to Accept that product?'),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('approved'),
              onPressed: () {
                //_pending_approved(user, campaign);
                // _pending_approved(userId);
                // Navigator.pop(context);
                upload_data(user, campaign, "approved");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('pending'),
              onPressed: () {
                //_pending_approved(user, campaign);
                // _pending_approved(userId);
                Navigator.pop(context);
                upload_data(user, campaign, "pending");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('rejected'),
              onPressed: () async {
                upload_data(user, campaign, "rejected");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Firestore _firestore = Firestore();
  Future<void> _pending_approved(
      DocumentSnapshot user, DocumentSnapshot campaign) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do want to Accept that product?'),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('approved'),
              onPressed: () async {
                upload_data(user, campaign, "approved");

                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Pending'),
              onPressed: () async {
                upload_data(user, campaign, "pending");

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  upload_data(
      DocumentSnapshot user, DocumentSnapshot campaign, String status) async {
    // For the user Side
    var u = user.data;
    print(u["name"]);
    final firestoreInstance = Firestore.instance;
    setState(() {
      if (status == "pending") {
        firestoreInstance.collection("Users").document(user.documentID).updateData({"pendingAmount":u["pendingAmount"]+int.parse(user_reward.text)});
        firestoreInstance.collection("UsersOffers").add({
          "offer name":com_name.text.toString(),
          "reward":user_reward.text.toString(),
          "time":Timestamp.now(),
          "status":status,
          "user phone":user.documentID
        }).then((value) {Fluttertoast.showToast(msg: "offer added in pending list");});
      } else if (status == "approved") {
        firestoreInstance.collection("Users").document(user.documentID).updateData({"approvedAmount":u["approvedAmount"]+int.parse(user_reward.text)});
        firestoreInstance.collection("UsersOffers").add({
          "offer name":com_name.text.toString(),
          "reward":user_reward.text.toString(),
          "time":Timestamp.now(),
          "status":status,
          "user phone":user.documentID
        }).then((value) {Fluttertoast.showToast(msg: "offer added in approved list");});
      }
      else{
        firestoreInstance.collection("UsersOffers").add({
          "offer name":com_name.text.toString(),
          "reward":user_reward.text.toString(),
          "time":Timestamp.now(),
          "status":status,
          "user phone":user.documentID
        }).then((value) {Fluttertoast.showToast(msg: "offer added in rejected list");});
      }
      //var users_cam = u["offersList"];
      //users_cam["${user.documentID}"] = false;
      ////print(u["campaignList"]);
      //// users_cam.add(({"${campaign.documentID}" : false}));
      //u["offersList"] = users_cam;
    });
    print(u);

    // For Task Side

    //List<DocumentSnapshot> campaigns_task =
    //    await CommonFunction().getPost("Posts/Offers/Tasks");
//
    //int flag = 0;
    //DocumentSnapshot cam;
    //for (var cams in campaigns_task) {
    //  if (cams.documentID.toString() == campaign.documentID) {
    //    setState(() {
    //      flag = 1;
    //      cam = cams;
    //    });
    //  }
    //}
//
    //print(flag);
//
    //List userr;
    //if (flag == 1) {
    //  userr = cam.data["submittedBy"];
    //  for (var ut in userr) {
    //    //print(ut);
    //    if (ut["name"] == u["name"]) {
    //      print("user present");
    //      print(userr.indexOf(ut));
    //      userr.remove(ut);
    //      break;
    //    }
    //  }
    //  userr.add({
    //    "name": u["name"] ?? "",
    //    "emailId": u["emailId"] ?? "",
    //    "uploadWorkUri": campaign.data["imgUri"] ?? "",
    //    "taskTitle": campaign.data["taskTitle"],
    //    "companyName": campaign.data["companyName"],
    //    "userId": u["userId"] ?? "",
    //    "phoneNo": u["phoneNo"] ?? "",
    //    "description": "kdskdsk",
    //    "status": status,
    //    "reward": user_reward.text.trim().toString()
    //  });
    //} else {
    //  userr = [];
    //  userr.add({
    //    "name": u["name"] ?? "",
    //    "emailId": u["emailId"] ?? "",
    //    "uploadWorkUri": campaign.data["imgUri"] ?? "",
    //    "taskTitle": campaign.data["taskTitle"],
    //    "companyName": campaign.data["companyName"],
    //    "userId": u["userId"] ?? "",
    //    "phoneNo": u["phoneNo"] ?? "",
    //    "description": "kdskdsk",
    //    "status": status,
    //    "reward": user_reward.text.trim().toString()
    //  });
    //}
//
    //print(userr);
    //Map<String, dynamic> updatedPost = {"submittedBy": userr};
    //print(updatedPost);
//
    //await _firestore
    //    .collection("Posts")
    //    .document("Offers")
    //    .collection("Tasks")
    //    .document(campaign.documentID)
    //    .setData(updatedPost, merge: true);
  }
}

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:markBoot/common/commonFunc.dart';
//import 'package:markBoot/common/common_widget.dart';
//import 'package:markBoot/common/style.dart';
//import 'package:markBoot/pages/homeScreen/adminPages/taskUserList_page.dart';
//
//class OffersPageTab extends StatefulWidget {
//
//  bool isRedirectFromProfile;
//  Map<String,dynamic> docList ;
//
//  OffersPageTab({this.docList,this.isRedirectFromProfile});
//
//  @override
//  _OffersPageTabState createState() => _OffersPageTabState();
//}
//
//class _OffersPageTabState extends State<OffersPageTab>with SingleTickerProviderStateMixin {
//
//  List<DocumentSnapshot> cashbackDocumentList ;
//  List<DocumentSnapshot> on500DocumentList ;
//  List<DocumentSnapshot> couponsDocumentList ;
//  TabController _tabController ;
//  List<Map<String,dynamic>> cashbackMapList = new List();
//  List<Map<String,dynamic>> on500MapList = new List();
//  List<Map<String,dynamic>> couponsMapList = new List();
//
//  List<int> cardColor = [CommonStyle().cardColor1,CommonStyle().cardColor2,CommonStyle().cardColor3,CommonStyle().cardColor4];
//
//
//
//  Future<void> _onCashbackRefresh() async{
//    cashbackDocumentList = await CommonFunction().getPost("Posts/Offers/Cashbacks");
//
//    return;
//  }
//  Future<void> _on500Refresh() async{
//    on500DocumentList = await CommonFunction().getPost("Posts/Offers/50 on 500");
//    setState(() {
//
//    });
//    return;
//  }
//  Future<void> _onCouponsRefresh() async{
//    on500DocumentList = await CommonFunction().getPost("Posts/Offers/Coupons");
//    setState(() {
//
//    });
//    return;
//  }
//
//  init() async {
//    try {
//      cashbackDocumentList = await CommonFunction().getPost("Posts/Offers/Cashbacks");
//      setState(() {
//
//      });
//      on500DocumentList = await CommonFunction().getPost("Posts/Offers/50 on 500");
//
//      setState(() {
//
//      });
//      couponsDocumentList = await CommonFunction().getPost("Posts/Offers/Coupons");
//      setState(() {
//
//      });
//    }
//    catch(e) {
//      debugPrint("Exception : (init)-> $e");
//    }
//  }
//
//  @override
//  void initState() {
//    _tabController = TabController(length: 3, vsync: this);
//    init();
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        backgroundColor: Colors.white,
//        appBar: AppBar(
//            backgroundColor: Color(CommonStyle().blueColor),
//            title: Text(widget.isRedirectFromProfile == true ?"Applied" : "Offers",
//              style: TextStyle(color: Colors.white),
//            ),
//            bottom: TabBar(
//              labelColor:Color(CommonStyle().lightYellowColor),
//              unselectedLabelColor: Colors.grey,
//              controller: _tabController,
//              tabs: <Widget>[
//                // moneyback- cashbacks ,wow offers-50 on 500,top offers - coupons
//                Tab(
//                  child: Text("Moneyback"),
//                ),
//                Tab(
//                    child: Text("Wow Offers")
//                ),
//                Tab(
//                    child: Text("Top Offers")
//                ),
//              ],
//            )
//        ),
//        body: TabBarView(
//          controller: _tabController,
//          children: <Widget>[
//            cashbackWidget(),
//            on500Widget(),
//            couponsWidget(),
//          ],
//        )
//    );
//  }
//
//  cashbackWidget() {
//    int index =0;
//    return RefreshIndicator(
//      onRefresh: _onCashbackRefresh,
//      child: CustomScrollView(
//        primary: false,
//        slivers: <Widget>[
//          cashbackDocumentList !=null && cashbackDocumentList.length >0 ?
//          SliverPadding(
//            padding: const EdgeInsets.all(20),
//            sliver: SliverGrid.count(
//              crossAxisSpacing: 10,
//              mainAxisSpacing: 10,
//              crossAxisCount: 2,
//              childAspectRatio: 2/3,
//              children: cashbackDocumentList.map((item) {
//                index++;
//                return  singleCard(item,context,"Admin",path: "Posts/Offers/Cashbacks",snapshots: cashbackDocumentList);
//              }).toList(),
//            ),
//          ) :
//          (
//              cashbackDocumentList == null ?
//              SliverToBoxAdapter(
//                  child: Container(
//                    margin: EdgeInsets.only(top: 50),
//                    child: Center(
//                      child: Container(
//                          width: 30,
//                          height: 30,
//                          child: CircularProgressIndicator()),
//                    ),
//                  )
//              )
//                  : SliverToBoxAdapter(
//                child: Container(
//                  height: MediaQuery.of(context).size.height-200,
//                  child: Center(
//                    child: Container(
//                      child: Text("No Data Found",
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontWeight:FontWeight.bold,
//                            fontSize: 18
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              )
//          ),
//        ],
//      ),
//    );
//  }
//  on500Widget() {
//    int index =0;
//    return RefreshIndicator(
//      onRefresh: _onCashbackRefresh,
//      child: CustomScrollView(
//        primary: false,
//        slivers: <Widget>[
//          on500DocumentList !=null && on500DocumentList.length >0 ?
//          SliverPadding(
//            padding: const EdgeInsets.all(20),
//            sliver: SliverGrid.count(
//              crossAxisSpacing: 10,
//              mainAxisSpacing: 10,
//              crossAxisCount: 2,
//              childAspectRatio: 2/3,
//              children: on500DocumentList.map((item) {
//                index++;
//                return  singleCard(item,context,"Admin",path : "Posts/Offers/50 on 500",snapshots: on500DocumentList);
//              }).toList(),
//            ),
//          ) :
//          (
//              on500DocumentList == null ?
//              SliverToBoxAdapter(
//                  child: Container(
//                    margin: EdgeInsets.only(top: 50),
//                    child: Center(
//                      child: Container(
//                          width: 30,
//                          height: 30,
//                          child: CircularProgressIndicator()),
//                    ),
//                  )
//              )
//                  : SliverToBoxAdapter(
//                child: Container(
//                  height: MediaQuery.of(context).size.height-200,
//                  child: Center(
//                    child: Container(
//                      child: Text("No Data Found",
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontWeight:FontWeight.bold,
//                            fontSize: 18
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              )
//          ),
//        ],
//      ),
//    );
//  }
//  couponsWidget() {
//    int index =0;
//    return RefreshIndicator(
//      onRefresh: _onCashbackRefresh,
//      child: CustomScrollView(
//        primary: false,
//        slivers: <Widget>[
//          couponsDocumentList !=null && couponsDocumentList.length >0 ?
//          SliverPadding(
//            padding: const EdgeInsets.all(20),
//            sliver: SliverGrid.count(
//              crossAxisSpacing: 10,
//              mainAxisSpacing: 10,
//              crossAxisCount: 2,
//              childAspectRatio: 2/3,
//              children: couponsDocumentList.map((item) {
//                index++;
//                return  singleCard(item,context,"Admin",path: "Posts/Offers/Coupons",snapshots: couponsDocumentList);
//              }).toList(),
//            ),
//          ) :
//          (
//              couponsDocumentList == null ?
//              SliverToBoxAdapter(
//                  child: Container(
//                    margin: EdgeInsets.only(top: 50),
//                    child: Center(
//                      child: Container(
//                          width: 30,
//                          height: 30,
//                          child: CircularProgressIndicator()),
//                    ),
//                  )
//              )
//                  : SliverToBoxAdapter(
//                child: Container(
//                  height: MediaQuery.of(context).size.height-200,
//                  child: Center(
//                    child: Container(
//                      child: Text("No Data Found",
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontWeight:FontWeight.bold,
//                            fontSize: 18
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              )
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget singleCard(DocumentSnapshot snapshot,context,postType,{subtype,path,snapshots} ) {
//    return Stack(
//      children: <Widget>[
//        Container(
//          decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(10)
//          ),
//          child: Material(
//              borderRadius: BorderRadius.circular(10),
//              color: Colors.blue,
//              child: InkWell(
//                onTap: (){
//                    Navigator.push(context, MaterialPageRoute(
//                        builder: (context)=>TaskUserListPage(taskUserList: snapshot["offersSubmittedBy"] ?? new List(),)
//                    ));
//
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                      color: Color(CommonStyle().blueCardColor),
//                      borderRadius: BorderRadius.circular(10)
//                  ),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Expanded(
//                        child: Container(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(10),
//                              image: DecorationImage(
//                                  fit: BoxFit.cover,
//                                  image: NetworkImage(snapshot["imgUri"])
//                              )
//                          ),
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 4,right: 2,top: 2,bottom: 2),
//                        child: Text(snapshot["companyName"] ?? "",
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 14,
//                          ),
//                        ),
//                      ),
//                      Container(
//                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                        height: 50,
//                        child: Text(snapshot["taskTitle"],
//                          overflow: TextOverflow.clip,
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 10
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              )
//          ),
//        ),
//        Positioned(
//            top: 5,
//            right: 8,
//            child: CircleAvatar(
//              backgroundColor:Colors.green,
//              radius: 18,
//              child: Text(snapshot["offersSubmittedBy"] == null ? "0" : snapshot["offersSubmittedBy"].length.toString(),
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 15
//                ),
//              ),
//            )
//        ),
//        Positioned(
//            top: 5,
//            left: 8,
//            child: CircleAvatar(
//              backgroundColor:Colors.grey,
//              radius: 18,
//              child: IconButton(
//                icon: Icon(Icons.delete,size: 20,color: Colors.red,),
//                onPressed: ()async{
//                  try{
//                    CommonFunction().showProgressDialog(isShowDialog: true, context: context);
//                    await Firestore.instance.collection(path).document(snapshot.documentID).delete();
//                    Fluttertoast.showToast(msg: "delete successfully",
//                        textColor: Colors.white,backgroundColor: Colors.green
//                    );
//                    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
//                    snapshots.remove(snapshot);
//                    setState(() {
//
//                    });
//                  }
//                  catch(e){
//
//                  }
//                },
//              ),
//            )
//        )
//      ],
//    );
//  }
//
//}
