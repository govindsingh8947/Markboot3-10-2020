
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';

class AmountReqUserListPage extends StatefulWidget {
  @override
  _AmountReqUserListPageState createState() => _AmountReqUserListPageState();
}

class _AmountReqUserListPageState extends State<AmountReqUserListPage>
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
        print(map);
        if (map["status"] == "pending") {
          map["documentId"] = snapshot.documentID.toString();
          print("mapi=$map");
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
        print("map=$map");
        if (map["status"] == "pending") {
          map["documentId"] = snapshot.documentID.toString();
          print("maps=$map");
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

    print("gigs=${maps_gigs.length}");
    print("cam=${maps_campaign.length}");
    print(maps_offers.length);
  }

  init() async {
    getpref();
    //    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
//    if(querySnapshot !=null ){
//      for(DocumentSnapshot snapshot in querySnapshot.documents) {
//        Map<String,dynamic>userData = snapshot.data;
//        String requestAmount = userData["requestAmount"] ??"0";
//        if(int.parse(requestAmount)>0) {
//          usersList.add(snapshot);
//        }
//      }
//    }
//    setState(() {
//
//    });
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
            title: Text("Amount Request"),
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
                Container(width: 150, child: Tab(child: Text("Offers"))),
              ],
            )),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[getgigs(), getcampaign(), getoffers()],
        ));
  }

  getgigs() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : (maps_gigs.length > 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  // return Text("hello");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: taskUserCard(maps_gigs[index], "gigs"),
                  );
                },
                itemCount: maps_gigs.length,
              )
            : Center(
                child: Container(
                  child: Text(
                    "No users found",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ));
  }

  getcampaign() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : (maps_campaign.length > 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  // return Text("hello");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: taskUserCard(maps_campaign[index], "campaign"),
                  );
                },
                itemCount: maps_campaign.length,
              )
            : Center(
                child: Container(
                  child: Text(
                    "No users found",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ));
  }
   // ignore: missing_return
   Future<DocumentSnapshot> getUser(String phone) async {
     List<DocumentSnapshot> usersList =
     await CommonFunction().getPost("Users");
     for (var userDocument in usersList) {
       if (userDocument.documentID.toString() == "phone") {
         print(userDocument.documentID.toString());
         return userDocument;
       }
     }
   }
  getoffers() {
    return isShowInitBar == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : StreamBuilder(stream: _firestore.collection("UsersOffers").orderBy('time',descending: true).snapshots(),
      builder: (context,snapShot) {
          if(snapShot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            return ListView.builder(itemCount:snapShot.data.documents.length,itemBuilder: (ctx,index) {
              return FutureBuilder(
                future: Firestore.instance.collection("Users").document(snapShot.data.documents[index]["user phone"]).get(),
                builder: (context, snapshotA) {
                  if (snapshotA.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text(
                        snapShot.data.documents[index]['offer name'],
                        style: TextStyle(color: Colors.white),),
                        backgroundColor:
                        snapShot.data.documents[index]['status'] == "pending"
                            ? Color(0xff051094)
                            :
                        snapShot.data.documents[index]['status'] == "approved"
                            ? Colors.green
                            : Colors.redAccent,),
                      title: Text(snapShot.data.documents[index]['user phone']),
                      subtitle: Text("${snapshotA.data["emailId"]}"),
                      trailing: RaisedButton(
                        child: Text(
                          snapShot.data.documents[index]['status'] == "pending"
                              ? "Pending\nRs.${snapShot.data.documents[index]["reward"].toString()}"
                              : snapShot.data.documents[index]['status'] ==
                              "approved" ? "Approved\nRs.${snapShot.data.documents[index]["reward"].toString()}" : "Rejected\nRs.${snapShot.data.documents[index]["reward"].toString()}",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xff051094),
                      ),
                      onTap: () {
                        if (snapShot.data.documents[index]['status'] == "pending") {
                          updateData(int A) {
                            final firestoreInstance = Firestore.instance;
                            if(A==1){
                            int amount=snapshotA.data["pendingAmount"]-int.parse(snapShot.data.documents[index]["reward"]);
                            firestoreInstance.collection("Users").document(snapShot.data.documents[index]["user phone"]).updateData({"pendingAmount":amount});
                            Navigator.of(context).pop();
                            }
                            else{
                              int pAmount=snapshotA.data["pendingAmount"]-int.parse(snapShot.data.documents[index]["reward"]);
                              int aAmount=snapshotA.data["approvedAmount"]+int.parse(snapShot.data.documents[index]["reward"]);
                              firestoreInstance.collection("Users").document(snapShot.data.documents[index]["user phone"]).updateData({"pendingAmount":pAmount});
                              firestoreInstance.collection("Users").document(snapShot.data.documents[index]["user phone"]).updateData({"approvedAmount":aAmount});
                              Navigator.of(context).pop();
                            }
                            return ;
                          }
                          return showDialog(context: context,builder: (BuildContext context) {
                            final firestoreInstance = Firestore.instance;
                            QuerySnapshot snap = snapShot.data; // Snapshot
                            List<DocumentSnapshot> items = snap.documents; // List of Documents
                            DocumentSnapshot item = items[index];
                            return AlertDialog(
                              title: Text("Choose One"), actions: [
                              FlatButton(child: Text("approve"), onPressed: () {
                                updateData(0);
                                setState(() {
                                  firestoreInstance.collection("UsersOffers").document(item.documentID).updateData({"status":"approved"});
                                });
                              },),
                              FlatButton(onPressed: () {
                                updateData(1);
                                setState(() {
                                  firestoreInstance.collection("UsersOffers").document(item.documentID).updateData({"status":"rejected"});
                                });
                              }, child: Text("reject"))
                            ],);
                          });
                        }
                      },
                    );
                  }
                }
              );
            });
          }
      },);
  }
  Widget taskUserCard(Map<String, dynamic> userData, String type) {
    //print(userData);
    return Container(
      //height: 100,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xff051094)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[leftWidget(userData), rightWidget(userData, type)],
      ),
    );
  }

  Widget leftWidget(Map<String, dynamic> userData) {
    return Padding(
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
    );
  }

  Firestore _firestore = Firestore();

  Widget rightWidget(Map<String, dynamic> userData, String type) {
    print(userData);
    return Row(
      children: <Widget>[
        Container(
          height: 40,
          child: RaisedButton(
            onPressed: () async {
              print("hello");
              List<DocumentSnapshot> d =
                  await CommonFunction().getPost("Users");
              DocumentSnapshot user;
              for (var doc in d) {
                if (doc.documentID.toString() == userData["phoneNo"]) {
                  setState(() {
                    user = doc;
                  });
                }
              }
              var u = user.data;
              //    print("u=${u}");
              print(user.data["pendingAmount"]);
              print(user.data["approvedAmount"]);
              print(userData["reward"]);
              int pending = int.parse(user.data["pendingAmount"].toString() ?? "0");
              int approved = int.parse(user.data["approvedAmount"].toString() ?? "0");
              int reward = int.parse(userData["reward"]);
              setState(() {
                pending = pending - reward;
                approved = approved + reward;
                u["pendingAmount"] = pending;
                u["approvedAmount"] = approved;
              });
              //  print(u);
              await _firestore
                  .collection("Users")
                  .document(userData["phoneNo"])
                  .setData(u, merge: true);

              if (type == "gigs") {
                List<DocumentSnapshot> snaps =
                    await CommonFunction().getPost("Posts/Gigs/Tasks");
                var res;
                for (var task in snaps) {
                  if (task.documentID == userData["documentId"]) {
                    res = task.data["submittedBy"];
                    for (var r in res) {
                      if (r["userId"].toString() ==
                          userData["userId"].toString()) {
                        setState(() {
                          res[res.indexOf(r)]["status"] = "approved";
                          print(res[res.indexOf(r)]);
                        });
                      }
                    }
                  }

                  print(res);
                }
                Map<String, dynamic> updatedPost = {"submittedBy": res};

                await _firestore
                    .collection("Posts")
                    .document("Gigs")
                    .collection("Tasks")
                    .document(userData["documentId"])
                    .setData(updatedPost, merge: true);
              } else if (type == "campaign") {
                List<DocumentSnapshot> snaps =
                    await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
                var res;
                for (var task in snaps) {
                  if (task.documentID == userData["documentId"]) {
                    res = task.data["submittedBy"];
                    // print(res);
                    for (var r in res) {
//                    print("hello");
//                    print(r["userId"]+" "+userData["userId"]);
                      if (r["userId"].toString() ==
                          userData["userId"].toString()) {
                        setState(() {
                          res[res.indexOf(r)]["status"] = "approved";
                          print(res[res.indexOf(r)]);
                        });
                      }
                    }
                  }

                  print(res);
                }
                Map<String, dynamic> updatedPost = {"submittedBy": res};

                await _firestore
                    .collection("Posts")
                    .document("Gigs")
                    .collection("Campaign Tasks")
                    .document(userData["documentId"])
                    .setData(updatedPost, merge: true);
              } else if (type == "offers") {
                List<DocumentSnapshot> snaps =
                    await CommonFunction().getPost("Posts/Offers/Tasks");
                var res;
                for (var task in snaps) {
                  if (task.documentID == userData["documentId"]) {
                    res = task.data["submittedBy"];
                    // print(res);
                    for (var r in res) {
//                    print("hello");
//                    print(r["userId"]+" "+userData["userId"]);
                      if (r["userId"].toString() ==
                          userData["userId"].toString()) {
                        setState(() {
                          res[res.indexOf(r)]["status"] = "approved";
                          print(res[res.indexOf(r)]);
                        });
                      }
                    }
                  }

                  print(res);
                }
                Map<String, dynamic> updatedPost = {"submittedBy": res};

                await _firestore
                    .collection("Posts")
                    .document("Offers")
                    .collection("Tasks")
                    .document(userData["documentId"])
                    .setData(updatedPost, merge: true);
              }

              await getpref();
            },
            child: Row(
              children: <Widget>[
                Text(userData["reward"] + "Rs." ?? ""),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Approve",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        ),
//        Container(
//            child: IconButton(
//              onPressed: (){
//                downloadTaskImg(userData["uploadWorkUri"]);
//              },
//              icon: Icon(Icons.file_download,
//                size: 20,color: Colors.white,
//              ),
//            )
//        )
      ],
    );
  }
}
