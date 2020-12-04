import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    // TODO: implement initState
    referandearn = init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer and Earn"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
              future: referandearn,
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                print(snapshot.data.documents[0].toString());
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection:Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.documents[index];
                    print(doc.data);
                    return Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.only(top: 20, left: 20),
                      height:doc.data['invitedTo'].length > 8 ? 300 : 200 ,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.data['userEmail'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "ReferCode :- ${doc.data['referCode'].toString()}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          Container(
                            width: size.width/4,
                            //height: size.height /3,
                            child: Column(
                              children: [
                                Text(
                                  'Downloads (${doc.data['invitedTo'].length})',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    itemCount: doc.data['invitedTo'].length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        "[${index+1}]${doc.data['invitedTo'][index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 12),
                                      );
                                    })
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
