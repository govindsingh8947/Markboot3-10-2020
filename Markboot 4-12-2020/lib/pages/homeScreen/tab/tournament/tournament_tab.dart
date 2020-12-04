import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class TournamentPageTab extends StatefulWidget {
  bool isRedirectFromProfile;
  Map<String, dynamic> docList;

  TournamentPageTab({this.docList, this.isRedirectFromProfile});

  @override
  _TournamentPageTabState createState() => _TournamentPageTabState();
}

class _TournamentPageTabState extends State<TournamentPageTab> {
  List<DocumentSnapshot> documentList;

  Future<void> _onRefresh() async {
    documentList =
        await CommonFunction().getPost("Posts/Tournament/Tournament");
    debugPrint("REFRESHSNAP $documentList");
    return;
  }

  init() async {
    try {
      documentList =
          await CommonFunction().getPost("Posts/Tournament/Tournament");
      print(documentList);
      if (widget.isRedirectFromProfile == true) {
        List<DocumentSnapshot> localSnapshot = new List();
        for (DocumentSnapshot snapshot in documentList) {
          if (widget.docList.containsKey(snapshot.documentID)) {
            localSnapshot.add(snapshot);
          }
        }
        documentList = localSnapshot;
      }
      debugPrint("DocumentSNAP $documentList");
      setState(() {});
    } catch (e) {
      debugPrint("Exception : (init)-> $e");
    }
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
        // backgroundColor: Color(CommonStyle().blueColor),
        title: Text(
          widget.isRedirectFromProfile == true ? "Applied" : "Tournament",
        ),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          documentList != null && documentList.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 3,
                    children: documentList.map((item) {
                      return CommonWidget().commonCard(
                          item, context, "Tournament",
                          subtype: "Tournament");
                    }).toList(),
                  ),
                )
              : (documentList == null
                  ? SliverToBoxAdapter(
                      child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()),
                      ),
                    ))
                  : SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 100,
                        child: Center(
                          child: Container(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                  color: Colors.black,
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
