import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String requestAmount = "";
  SharedPreferences prefs;
  String phoneNo;
  List<dynamic> transactions = new List();
  bool isShowInitBar = true;
  List<dynamic> req;
  init() async {
    isShowInitBar = true;
    prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString("userPhoneNo") ?? "";
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("Users").document(phoneNo).get();
    req = snapshot.data["request"];
    transactions = snapshot.data["transaction"] ?? new List();
    requestAmount = snapshot.data["requestAmount"] ?? "";
    print(req.length);
    setState(() {});
    isShowInitBar = false;
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
          //backgroundColor: Color(CommonStyle().blueColor),
          title: Text(
            "Transactions",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: isShowInitBar == false
            ? Container(
                height: 400,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          color: Color(0xff051094),
                          borderRadius: BorderRadius.circular(10)),
                      height: 80,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Id : ${req[index]["transaction_id"]}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Amount",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Image.asset("assets/icons/bank.png",
                                      width: 15,
                                      height: 15,
                                      color: Colors.white),
                                  Text(
                                    req[index]["requestAmount"] + "" ?? "",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              req[index]["status"] == "success"
                                  ? Text(
                                      "Paid on : ${req[index]["paid_on"]}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  : Text("")
                            ],
                          ),
                          req[index]["status"] == "success"
                              ? Text(
                                  "Success",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                )
                              : Text(
                                  "Processing",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                )
                        ],
                      ),
                    );
                  },
                  itemCount: req.length,
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
