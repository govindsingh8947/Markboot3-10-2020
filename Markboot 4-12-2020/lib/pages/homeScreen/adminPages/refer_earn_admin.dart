import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'refer_detail_page.dart';

class ReferEarn extends StatefulWidget {
  @override
  _ReferEarnState createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  Firestore _firestore = Firestore();
  Future referandearn;
  QuerySnapshot doc;

  Future<QuerySnapshot> init() async {
    try {
      doc = await _firestore.collection("invitecodes").getDocuments();

      //   .then((value) {
      // //print(value.documents.first.data);
      // value.documents.forEach((element) {
      //   //print(element.data["invitedTo"]);
      //   element.data["invitedTo"].forEach((value) {
      //     //print("fjkbdjkfbd");
      //   });
      //   // element.data.forEach((key, value) {
      //   //   //print(key);
      //   //   //print(value);s
      //   //   // if(value["invitedTo"].length){
      //   //   //   print(value.length);
      //   //   // }
      //   // });
    } catch (e) {
      print(e);
    }

    return doc;
  }

  @override
  void initState() {
    referandearn = init();
    super.initState();
  }

  TextEditingController t1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add a new Refer code'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        controller: t1,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Enter New Refer Code",
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Add'),
                    onPressed: () async {
                      if (t1.text.trim().length != 6) {
                        Fluttertoast.showToast(msg: "Enter 6 Digit Valid Code");
                        return;
                      }
                      try {
                        await Firestore.instance
                            .collection("invitecodes")
                            .document("${t1.text.toUpperCase().trim()}")
                            .setData({
                          "invitedBy": "admin",
                          "invitedTo": [],
                          "referCode": t1.text.toUpperCase().trim(),
                          "userEmail": "markbootcompany@gmail.com",
                          "userPhone": "+918947056858"
                        }, merge: true);
                        Fluttertoast.showToast(
                            msg: "Code entered Successfully");
                      } catch (err) {
                        Fluttertoast.showToast(
                            msg:
                                "Sorry there was an error while uploading please add a new code or check your connection ");
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Back"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.yellow,
      ),
      appBar: AppBar(
        title: Text("Refer and Earn"),
      ),
      body: FutureBuilder(
          future: referandearn,
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            print(snapshot.data.documents[0].toString());
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data.documents[index];
                print(doc.data);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReferDetailPage(
                                  a: doc.data['invitedTo'],
                                  rid: doc.data['referCode'].toString(),
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(top: 10, left: 10),
                    height: doc.data['invitedTo'].length > 8 ? 150 : 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.data['userEmail'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "ReferCode :- ${doc.data['referCode'].toString()}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Downloads (${doc.data['invitedTo'].length})',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width / 3.5,
                          height: size.height / 8,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    itemCount: doc.data['invitedTo'].length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        "[${index + 1}]${doc.data['invitedTo'][index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 12),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
