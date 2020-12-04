import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class payment_transact extends StatefulWidget {
  @override
  _payment_transactState createState() => _payment_transactState();
}

class _payment_transactState extends State<payment_transact> {
  List usersList = new List();
  bool isShowInitBar = true;

  init() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Users").getDocuments();
    if (querySnapshot != null) {
      for (DocumentSnapshot snapshot in querySnapshot.documents) {
        List requests = snapshot["request"] ?? List();
        for (var req in requests) {
          // Map<String, dynamic> userData = snapshot.data[];
          // print(req);
          var r = req;
          String requestAmount = req["requestAmount"] ?? "0";
          if (int.parse(requestAmount) > 0 && req["status"] == "Processing") {
            r["registered_number"] = snapshot.documentID;
            usersList.add(r);
          }
        }
      }
    }
    setState(() {
      print(usersList);
      isShowInitBar = false;
    });
  }

  TextEditingController optional_id = TextEditingController();

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
          title: Text("Amount Request"),
        ),
        body: isShowInitBar == true
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (usersList.length > 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        //height: 80,
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xff051094),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Id : ${usersList[index]["transaction_id"]}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  usersList[index]["user_name"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  usersList[index]["paymentNo"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  usersList[index]["paymentemail"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     show_dialog();
                                //   },
                                //   child: Text(
                                //     optional_id.text.isEmpty
                                //         ? "Add Optional ID"
                                //         : optional_id.text,
                                //     style: TextStyle(
                                //         color: Colors.white, fontSize: 12),
                                //   ),
                                // ),
                                SizedBox(height: 10),
                                Container(
                                    height: 40,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          usersList[index]["requestAmount"],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          usersList[index]["paymentMethod"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Container(
                              child: RaisedButton(
                                color: Color(CommonStyle().lightYellowColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  payService(usersList[index]);
                                },
                                child: Text(
                                  "Pay",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: usersList.length,
                  )
                : Center(
                    child: Container(
                      child: Text(
                        "No users found",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  )));
  }

  show_dialog(var snapshot) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Add Optional Id',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            CommonWidget().commonTextField(
                controller: optional_id,
                lines: 1,
                hintText: "Enter the optional ID",
                keyboardType: TextInputType.text),
            FlatButton(
                onPressed: () async {
                  try {
                    //  print(snapshot["phoneNo"]);
                    CommonFunction().showProgressDialog(
                        isShowDialog: true, context: context);
                    DocumentSnapshot res = await Firestore.instance
                        .collection("Users")
                        .document(snapshot["registered_number"])
                        .get();
                    print("Users/${snapshot["registered_number"]}");
                    print(res);
                    List requests = res.data["request"];
                    List new_requets = [];

                    for (var req in requests) {
                      var r = req;

                      if (req["transaction_id"] == snapshot["transaction_id"]) {
                        r["status"] = "success";
                        r["optional_id"] = optional_id.text;
                        r["paid_on"] = DateTime.now().toString().split(" ")[0];
                      }

                      new_requets.add(r);
                    }
                    print(new_requets);
                    await Firestore.instance
                        .collection("Users")
                        .document(snapshot["registered_number"])
                        .setData({"request": new_requets}, merge: true);
                    //usersList.remove(snapshot);

                    setState(() {});
                    Fluttertoast.showToast(
                        msg: "Pay successfully",
                        backgroundColor: Colors.green,
                        textColor: Colors.white);
                    usersList.clear();
                    init();
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "please try again",
                        textColor: Colors.white,
                        backgroundColor: Colors.red);
                  }

                  CommonFunction().showProgressDialog(
                      isShowDialog: false, context: context);
                  optional_id.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  'Add Optional ID',
                  style: TextStyle(color: Colors.purple, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> payService(var snapshot) async {
    await print(DateTime.now().toString().split(" ")[0]);
    await show_dialog(snapshot);
    print(optional_id.text.toString());
    // try {
    //   //  print(snapshot["phoneNo"]);
    //   CommonFunction().showProgressDialog(isShowDialog: true, context: context);
    //   DocumentSnapshot res = await Firestore.instance
    //       .collection("Users")
    //       .document(snapshot["registered_number"])
    //       .get();
    //   print("Users/${snapshot["registered_number"]}");
    //   print(res);
    //   List requests = res.data["request"];
    //   List new_requets = [];

    //   for (var req in requests) {
    //     var r = req;

    //     if (req["paymentNo"] == snapshot["paymentNo"]) {
    //       r["status"] = "success";
    //     }

    //     new_requets.add(r);
    //   }
    //   print(new_requets);
    //   await Firestore.instance
    //       .collection("Users")
    //       .document(snapshot["registered_number"])
    //       .setData({"request": new_requets}, merge: true);
    //   //usersList.remove(snapshot);

    //   setState(() {});
    //   Fluttertoast.showToast(
    //       msg: "Pay successfully",
    //       backgroundColor: Colors.green,
    //       textColor: Colors.white);
    //   usersList.clear();
    //   init();
    // } catch (e) {
    //   Fluttertoast.showToast(
    //       msg: "please try again",
    //       textColor: Colors.white,
    //       backgroundColor: Colors.red);
    // }

    // CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }
}
