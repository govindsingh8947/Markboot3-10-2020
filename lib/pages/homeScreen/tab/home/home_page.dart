import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  double _containerMaxHeight = 56, _offset, _delta = 0, _oldOffset = 0;
  Firestore _firestore = Firestore.instance;

  init() {
    getRecentPost();
  }

  @override
  void initState() {
    init();
    super.initState();
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
      });
  }

  Future<void> getRecentPost() async {
    try {
      debugPrint("SnapshotNAME 123");
      QuerySnapshot querySnapshot =
          await _firestore.collection("Posts/hunt/tasks").getDocuments();
      for (DocumentSnapshot snapshot in querySnapshot.documents) {
        debugPrint("SnapshotNAME ${snapshot["task"]}");
      }
    } catch (e) {
      debugPrint("Exception (getRecentPost) : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListView.builder(
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              itemCount: 20,
              itemBuilder: (context, index) =>
                  ListTile(title: Text(index.toString())),
            ),
            Positioned(
              bottom: _offset,
              width: constraints.maxWidth,
              child: Container(
                width: double.infinity,
                height: _containerMaxHeight,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildItem(Icons.home, "Home"),
                    _buildItem(Icons.blur_circular, "Collection"),
                    _buildItem(Icons.supervised_user_circle, "Community"),
                    _buildItem(Icons.notifications, "Notifications"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(IconData icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28),
        Text(title, style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
