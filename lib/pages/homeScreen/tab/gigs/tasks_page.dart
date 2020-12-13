import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';


// This is kinda like the more information page of the items displayed in the home page
class TasksPageDetails extends StatefulWidget {
  DocumentSnapshot snapshot;
  String type;
  String subType;
  bool isDisabled; // This is false by default
  TasksPageDetails(
      {@required this.snapshot,
      this.type,
      this.subType,
      this.isDisabled = false});
  @override
  _TasksPageDetailsState createState() => _TasksPageDetailsState();
}

class _TasksPageDetailsState extends State<TasksPageDetails>
    with SingleTickerProviderStateMixin {
  Firestore _firestore = Firestore();
  String phoneNo;
  SharedPreferences prefs;
  Map<String, dynamic> userData;
  bool isApplied = false;
  List<String> pendingPostList=[];
  List<int> textColors = [0xff00E676, 0xffEEFF41, 0xffE0E0E0, 0xffffffff];
  List<int> colors = [
    0xff11232D,
    0xff1C2D41,
    0Xff343A4D,
    0xff4F4641,
    0xff434343,
    0xff2A2A28
  ];
  Random random = Random();
  final picker = ImagePicker();

  // Animation ------------------
  AnimationController animationController;
  bool isCampaign=false;
  Animation animation;
  File _workedImgFile;
  String name;
  String emailId;
  String userId;
  TextEditingController collegeNameCont = TextEditingController();
  TextEditingController showUser2 = TextEditingController();
  TextEditingController showUser1 = TextEditingController();
  bool isGetCampaignCode = false;
  String referralCode;
  final key = new GlobalKey<ScaffoldState>();
  Map<String, dynamic> pendingTasksMap = new Map();
  List<String> pendingTaskList = new List();
  bool isSubmitted = false;
  String referredUser = "0";
  Map<String, dynamic> campaignList = new Map();
  String _localPath;
  String status;
  Color col;
  String linkRefer;
  String linkEnter;
  String ongoing;
  int userStatus=0;
  int maxStatus=0;
  Firestore firestore=Firestore.instance;
  Future<void> init() async {
    print("hello+${widget.snapshot.data}");
    // print();
    print("Posts/${widget.type}/${widget.subType}");
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("userName");
    phoneNo = prefs.getString("userPhoneNo");
    emailId = prefs.getString("userEmailId");
    userId = prefs.getString("userId");
    referralCode = prefs.getString("referralCode") ?? "";
    //print(name);
    //print(phoneNo);
    try {
      List tasks = await CommonFunction()
          .getPost("Posts/${widget.type}/${widget.subType}");
      print("Tasks =${tasks}");
      for (DocumentSnapshot doc in tasks) {
        if (widget.snapshot.documentID == doc.documentID) {
          List users = doc.data["submittedBy"];   // this will contain a map from the database with all the information
          //print("GOt it");
          print("Above the users list printing------------------------------");
          print(users);
          //print(name);

          /// Added this null safety feature !!!!!!!!!!!!! this won't actually run for the gigs section
          if(users!=null){
            print("Inside this ");
            for (var user in users) {
              // print(user["userId"]);
              print("abbfbbgbg=================");

              /// Here changed the name to phone number
              /// Have to change the code over here find the new document verify the uid of the user using his phone
              /// number
              if (phoneNo == user["phoneNo"]) {
                await
                print("user find");
                print(name);
                print(user["name"]);
                isApplied = true;
                status = user["status"];
                print(status);
                if (widget.subType == "Tasks") {
                  if (status == "applied") {
                    status = "Submitted";
                    col = Color(0xff051094);
                  } else if (status == "rejected") {
                    status = "Rejected";
                    col = Colors.red;
                  } else {
                    status = "Accepted";
                    col = Colors.green;
                  }
                } else {
                  if (status == "applied") {
                    status = "Applied";
                    col = Color(0xff051094);
                  } else if (status == "rejected") {
                    status = "Rejected";
                    col = Colors.red;
                  } else if (status == "ongoing") {
                    //var ref= await firestore.collection("/Posts/Gigs/Campaign Tasks").document("${widget.snapshot.documentID}").get();
                    userStatus = user["UserStatus"];
                    status = "ongoing";
                    col = Colors.red;
                    linkRefer = user["link"];
                    linkEnter = user["linkToShow"];
                    print("link rfidbfbdibfbdbfdbfbdubfdbfg");
                    print(linkEnter);
                    //print("${widget.snapshot.data["UserStatus"]}");
                  } else {
                    status = "Accepted";
                    col = Colors.green;
                  }
                }
              }
            }
          }

        }
      }

      print(isApplied);
      print(status);

      // pendingPostList =
      //     prefs.getStringList("pendingTasks") ?? new List<String>();
      // if (pendingPostList.contains(widget.snapshot.documentID.toString())) {
      //   isApplied = true;
      //   setState(() {});
      // }
      // phoneNo = prefs.getString("userPhoneNo") ?? "";
      // DocumentSnapshot snapshot =
      //     await _firestore.collection("Users").document(phoneNo).get();
      // userData = snapshot.data;
      // referredUser = userData["referredUser"] ?? "0";
      // pendingTasksMap = userData["pendingTasks"] ?? new Map();
      // debugPrint("PEndingTask $pendingTasksMap");
      // if (pendingTasksMap.containsKey(widget.snapshot.documentID)) {
      //   isApplied = true;
      // }
      // referralCode = userData["referralCode"] ?? "";
      // campaignList = userData["campaignList"] ?? new Map();
      // if (campaignList.containsKey(widget.snapshot.documentID)) {
      //   isGetCampaignCode = true;
      // }
      // debugPrint("DATA $userData");
      _localPath =
          (await _findLocalPath()) + Platform.pathSeparator + 'Download';

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
      setState(() {});
    } catch (e) {
      debugPrint("Exception: (Init) -> $e");
    }
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
    init();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("hello");
    return SafeArea(
      child: Scaffold(
          key: key,
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (animationController.isCompleted) {
                    animationController.reverse();
                  }
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                        backgroundColor: Colors.transparent,
                        stretch: true,
                        expandedHeight: MediaQuery.of(context).size.height * 0.70,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Visibility(visible: widget.subType  // this is actually never true
                              .toLowerCase()
                              .contains("campaign tasks") ??
                              false ,child: Text("$userStatus/${widget.snapshot.data["maxStatus"]}")),
                          background: Hero(
                            tag: "img",
                            child: Container(
                            padding: EdgeInsets.symmetric(vertical: 30),
                              decoration: BoxDecoration(
                                  color: Colors.white38,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          widget.snapshot["imgUri"]))),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 20,right: 10,top: 15,),
                                      child: Text(widget.snapshot["taskTitle"]??"",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 50),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                widget.snapshot["logoUri"]),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(widget.snapshot["companyName"]??"",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(""),
                                    ),

                                    // This visibility will also be never shown then why is it here!!!
                                    Visibility(
                                      visible: widget.subType
                                              .toLowerCase()
                                              .contains("campaign tasks") ??
                                          false,
                                      child: Container(
                                        height: 80,
                                        padding: EdgeInsets.only(left: 20),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Text(
                                            //   "PROGRESS",
                                            //   style: TextStyle(
                                            //       color: Colors.yellowAccent),
                                            // ),
                                            // Row(
                                            //   children: <Widget>[
                                            //     Text(
                                            //       "$referredUser/",
                                            //       style: TextStyle(
                                            //         fontSize: 28,
                                            //         color: Colors.black,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       "20",
                                            //       style: TextStyle(
                                            //           color: Colors.black,
                                            //           fontSize: 15),
                                            //     )
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            placeholderBuilder: (context, size, widget) {
                              return Container(
                                height: 150.0,
                                width: 150.0,
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        )),
                    SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Title",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            // color: Color(
                                            //     CommonStyle().lightYellowColor),
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.snapshot["taskTitle"] ?? "",
                                        style: TextStyle(
                                            fontSize: 15,
                                            //     color: Color(0xff051094)),
                                            color: Colors.black54),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Company Name ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                            // color: Color(
                                            //     CommonStyle().lightYellowColor),
                                            ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.snapshot["companyName"] ?? "",
                                        style: TextStyle(
                                            fontSize: 15,
                                            // color: Color(0xff051094)
                                            color: Colors.black54),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),



                              /// This will only be visible for the tournament page when at the moment has no data
                              Visibility(
                                visible: widget.subType
                                        .toLowerCase()
                                        .contains("task") ??
                                    false,
                                child: Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Visibility(
                                          visible:  !widget.subType
                                              .toLowerCase()
                                              .contains("campaign"),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Task",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                    // color: Color(
                                                    //     CommonStyle().lightYellowColor),
                                                    ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                widget.snapshot["taskDesc"] ?? "",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    // color: Color(0xff051094)
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),


                              /// This will also be most probably never shown
                              Visibility(
                                visible: widget.subType
                                        .toLowerCase()
                                        .contains("campaign") ??
                                    false,
                                child: Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Description",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                              // color: Color(
                                              //     CommonStyle().lightYellowColor),
                                              ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.snapshot["taskDesc"] ?? "",
                                          style: TextStyle(
                                              fontSize: 15,
                                              // color: Color(0xff051094)
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text(
                                  "REWARD",
                                  style: TextStyle(
                                      color: Colors.black,
                                      // color:
                                      //     Color(CommonStyle().lightYellowColor),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/icons/bank.png",
                                        width: 15,
                                        height: 15,
                                        color: Color(0xff051094),
                                      ),
                                      Text(
                                        widget.snapshot["reward"] ?? "",
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Color(0xff051094)),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  downloadTaskImg(
                                      widget.snapshot["samplePicUri"]);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, right: 8),
                                  child: GestureDetector(
                                    child: Text(
                                      "See Sample Picture",
                                      style: TextStyle(
                                          color: Color(0xff051094), fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),


                              /// This will also never be visible, it will be visible only in the case of tournament
                              Visibility(
                                visible: widget.subType == "Tasks" ? true : false,
                                child: isApplied == true
                                    ? Container(
                                        //margin: EdgeInsets.only(top: 8),
                                        child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Divider(
                                            thickness: 5,
                                          ),
                                          Text(
                                            "Status",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                // color: Color(
                                                //     CommonStyle().lightYellowColor),
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            status,
                                            style: TextStyle(
                                                fontSize: 15,
                                                //     color: Color(0xff051094)),
                                                color: col),
                                          )
                                        ],
                                      ))
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 50,
                                            child: RaisedButton(
                                              //color: Colors.white,
                                              color: Color(0xff051094),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              onPressed: () {
                                                _launchURL(
                                                    widget.snapshot["link"] ??
                                                        "");
                                              },
                                              child: Text(
                                                "Visit Website",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 50,
                                            child: RaisedButton(
                                              //color: Colors.blueAccent,
                                              color: Color(0xff051094),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              onPressed: () {

                                                if (!widget.isDisabled) {
                                                  if (isApplied == false) {
                                                    if (animationController
                                                        .isCompleted) {
                                                      animationController
                                                          .reverse();
                                                    } else {
                                                      animationController
                                                          .forward();
                                                    }

                                                  }
                                                }
                                              },
                                              child: Text(
                                                "SUBMIT",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                              ),



                              /// I don't know what the person that made this login had in mind but i just removed the exclamation and
                              /// this is working now
                              !(widget.subType == "Campaign Tasks")
                                  ? Text("")// this will be shown for all the other cases
                                  : isApplied == false
                                      ? Container(
                                          height: 50,
                                          child: RaisedButton(
                                            //  color: Colors.blueAccent,
                                            color: Color(0xff051094),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () {
                                              apply_post_service_cam();
                                            },
                                            child: Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        )
                                      : Container(
                                            child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              status == "ongoing"
                                                  ? Column(children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            children: [
                                                                SingleChildScrollView(
                                                                  scrollDirection:Axis.horizontal,
                                                                  child: Text(
                                                                    "Link",
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        // color: Color(
                                                                        //     CommonStyle().lightYellowColor),
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),

                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              SingleChildScrollView(
                                                                scrollDirection:Axis.horizontal,
                                                                child: Container(
                                                                  width:MediaQuery.of(context).size.
                                                                      width*0.6,
                                                                  child: Text(
                                                                    linkRefer.isNotEmpty ? "ggjg" : linkEnter,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        //     color: Color(0xff051094)),
                                                                        color: Color(
                                                                            0xff051094)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SingleChildScrollView(
                                                                scrollDirection:Axis.horizontal,
                                                                child: Container(
                                                                  width:MediaQuery.of(context).size.
                                                                  width*0.6,
                                                                  child: Text(
                                                                    linkRefer.isNotEmpty ? linkRefer : "",
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        //     color: Color(0xff051094)),
                                                                        color: Color(
                                                                            0xff051094)),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),linkEnter != null?GestureDetector(
                                                            onTap: () {
                                                               Clipboard.setData(
                                                                   new ClipboardData(
                                                                       text:
                                                                           linkEnter));
                                                               Fluttertoast.showToast(msg: "copied link to clipboard");
                                                            },
                                                            child: Icon(
                                                                Icons.content_copy),
                                                          ) : linkRefer != null?GestureDetector(
                                                            onTap: () {
                                                              Clipboard.setData(
                                                                  new ClipboardData(
                                                                      text:
                                                                      linkEnter));
                                                              Fluttertoast.showToast(msg: "copied link to clipboard");
                                                            },
                                                            child: Icon(
                                                                Icons.content_copy),
                                                          ):Container(),
                                                          IconButton(icon: Icon(Icons.share_rounded), onPressed: () {Share.share(linkRefer,);})
                                                        ],
                                                      )

                                                    ],
                                              )
                                                  : Text(""),
                                              Divider(
                                                thickness: 5,
                                              ),
                                              Text(
                                                "Status",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    // color: Color(
                                                    //     CommonStyle().lightYellowColor),
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                status,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    //     color: Color(0xff051094)),
                                                    color: col),
                                              )
                                            ],
                                          )),

                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: animation != null
                      ? MediaQuery.of(context).size.height * 0.5 * animation.value
                      : 0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: animation != null ? 50 * animation?.value : 0,
                      ),
                      Container(
                        height: animation != null ? 50 * animation?.value : 0,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: collegeNameCont,
                          onTap: () {},
                          decoration: InputDecoration(hintText: "Email ID"),
                        ),
                      ),
                      widget.snapshot["showUser1"] != null ? Container(
                        height: animation != null ? 50 * animation?.value : 0,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: showUser1,
                          onTap: () {},
                          decoration: InputDecoration(hintText: widget.snapshot["showUser1"]),
                        ),
                      ) : Container(),

                      widget.snapshot["showUser2"] != null ? Container(
                        height: animation != null ? 50 * animation?.value : 0,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: showUser2,
                          onTap: () {},
                          decoration: InputDecoration(hintText: widget.snapshot["showUser2"]),
                        ),
                      ) : Container(),

                      SizedBox(
                        height: animation != null ? 20 * animation?.value : 0,
                      ),
                      GestureDetector(
                          onTap: () {
                            showPickImageDialog(_workedImgFile);
                          },
                          child: showCamera(_workedImgFile)),
                      SizedBox(
                        height: animation != null ? 40 * animation.value : 0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        height: 50 * animation.value,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          //color: Color(CommonStyle().blueColor),
                          color: Color(0xff051094),

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            debugPrint("Pressed");
                            FocusScope.of(context).unfocus();
                            if (collegeNameCont.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Enter all fields",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                              return;
                            } else {
                              applyPostService();
                            }
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget showCamera(fileImg) {
    return Center(
        child: fileImg == null
            ? Container(
                width: 100,
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      "assets/icons/camera.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    )),
              )
            : Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white38)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      fileImg,
                      fit: BoxFit.fill,
                    )),
              ));
  }

  showPickImageDialog(showfileImg) {
    return showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff051094),
                    borderRadius: BorderRadius.circular(10)),
                height: 260,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        pickImageGallery(showfileImg);
                      },
                      child: Text("Gallery"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        pickImageCamera(showfileImg);
                      },
                      child: Text("Camera"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  pickImageGallery(pickFileImg) async {
    try {
      final pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 30);

      setState(() {
        _workedImgFile = File(pickedFile.path);
      });
    } catch (e) {
      debugPrint("Exception : (pickImage) -> $e");
    }
  }

  pickImageCamera(showfileImg) async {
    try {
      final pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 30);

      setState(() {
        _workedImgFile = File(pickedFile.path);
      });
    } catch (e) {
      debugPrint("Exception : (pickImage) -> $e");
    }
  }

  Widget bottomButton(context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  debugPrint("PPPPPP");
                  _launchURL(widget.snapshot["link"] ?? "");
                },
                child: Text(
                  "Visit Website",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 50,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget singleItem(title, desc, {crossAlign = CrossAxisAlignment.center}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: Color(CommonStyle().blueCardColor), //Color(0xff1f7872),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAlign,
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                  color: Color(CommonStyle().lightYellowColor), fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              desc ?? "",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  _launchURL(url) async {
    if (!url.contains("http")) {
      url = "https://" + url;
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> downloadTaskImg(imgUri) async {
    try {
      // Saved with this method.
      final taskId = await FlutterDownloader.enqueue(
        url: imgUri,
        savedDir: _localPath,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
      if (taskId != null && taskId.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "Downloading...",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Download failed",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Widget header() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/icons/list.png"))),
    );
  }

  Future<void> requestAccessAPI() async {
    try {
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      bool isSubmitted = true;
      String referralCode = generateCode();
      userData["referralCode"] = referralCode;
      campaignList[widget.snapshot.documentID] = false;
      userData["campaignList"] = campaignList;
      String pendigAmount = userData["pendingAmount"] ?? "0";
      pendigAmount = (int.parse(pendigAmount ?? "0") +
              int.parse(widget.snapshot["reward"] ?? "0"))
          .toString();
      userData["pendingAmount"] = pendigAmount;

      await _firestore
          .collection("Users")
          .document(phoneNo)
          .setData(userData, merge: true)
          .whenComplete(() {
        isApplied = true;
        pendingPostList.add(widget.snapshot.documentID.toString());
        debugPrint("PPPPPPPPPPPPPPP $pendingTaskList");
        prefs.setStringList("pendingTasks", pendingPostList);
        prefs.setString("referralCode", referralCode);
        isGetCampaignCode = true;
        setState(() {});
      }).catchError((error) {
        isSubmitted = false;
      });

      if (isSubmitted == true) {
        Fluttertoast.showToast(
            msg: "Access successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "please try again",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
// update post data
    } catch (e) {
      debugPrint("Exception : (ReqAccessAPI)> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  String generateCode() {
    List<String> abc = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ];
    List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

    Random random = Random();
    String randomCode = "";

    for (int i = 0; i < 7; i++) {
      int chooseList = random.nextInt(2);
      if (chooseList == 0) {
        randomCode += abc[random.nextInt(26)];
      } else {
        randomCode += numbers[random.nextInt(9)];
      }
    }

    return randomCode;
  }

  Future<void> apply_post_service_cam() async {
    List<DocumentSnapshot> d =
        await CommonFunction().getPost("Posts/Gigs/Campaign Tasks");
    print("d =${d}");
    DocumentSnapshot present_absent = null;
    for (DocumentSnapshot snapshot in d) {
      if (snapshot.documentID == widget.snapshot.documentID) {
        setState(() {
          present_absent = snapshot;
        });
      }
    }
    if (present_absent != null) {
    } else {}

    print(widget.snapshot.documentID);
    print("Posts/Gigs/Campaign Tasks/${widget.snapshot.documentID}");
    try {
      bool isSubmitted = true;
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);

      // update post data
      Map<String, String> map = new Map<String, String>();
      // s// }

      // String workedImgFileUri = await uploadToStorage(_workedImgFile);
      // debugPrint("IIIIIIIIIIIIIMMMMMMMMMMMM $workedImgFileUri");
      // if (workedImgFileUri != null) {
      map = {
        "name": name,
        "emailId": emailId,
        "phoneNo": phoneNo,
        "userId": userId,
        //   "uploadWorkUri": workedImgFileUri,
        "imgUri": widget.snapshot["imgUri"],
        "logoUri": widget.snapshot["logoUri"],
        "target": widget.snapshot["target"],
        "taskDesc": widget.snapshot["taskDesc"],
        "reward": widget.snapshot["reward"] ?? "",
        "status": "applied",
        "companyName": widget.snapshot["companyName"],
        "taskTitle": widget.snapshot["taskTitle"],
        "linkToShow" : "",
      };
      print(map);
      widget.snapshot.data["submitedBy"] = map;
      Map<String, dynamic> updatedPost;
      if (present_absent != null) {
        var m = present_absent["submittedBy"];
        m.add(map);
        setState(() {
          updatedPost = {"submittedBy": m};
        });
        print("Data =$m");
        print("%${updatedPost}");
      } else {
        setState(() {
          updatedPost = {
            "submittedBy": [map]
          };
        });
      }
      print("%${updatedPost}");
//          Map<String,dynamic> updatedPost = {
//            "submittedBy" : map
//          };
      pendingTasksMap[widget.snapshot.documentID] = false;

      /// Adding the task information to the users account
      await _firestore
          .collection("Users")
          .document(phoneNo)
          .setData({"pendingTasks": pendingTasksMap}, merge: true);
      await _firestore
          .collection("Posts")
          .document("Gigs")
          .collection("Campaign Tasks")
          .document(widget.snapshot.documentID)
          .setData(updatedPost, merge: true);
      pendingPostList.add(widget.snapshot.documentID.toString());
      debugPrint("PPPPPPPPPPPPPPP $pendingTaskList");
      prefs.setStringList("pendingTasks", pendingPostList);
      // } else {
      //   isSubmitted = false;
      // }

////      String pendigAmount = userData["pendingAmount"] ?? "0";
////      pendigAmount = (int.parse(pendigAmount??"0") + int.parse(widget.snapshot["reward"]??"0")).toString() ;
////      userData["pendingAmount"] = pendigAmount;
////      if(isSubmitted == true) {
////        await  _firestore.collection("Users").document(phoneNo).setData(userData,merge: true)
////            .whenComplete(() {
////          isApplied = true;
////          pendingPostList.add(widget.snapshot.documentID.toString());
////          prefs.setStringList("pendingPost", pendingPostList);
////        })
////            .catchError((error){
////              isSubmitted = false;
////
////        });
////      }
//
      if (isSubmitted == true) {
        Fluttertoast.showToast(
            msg: "Submitted successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "getting some error",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      debugPrint("Exception : (applyPostService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  Future<void> applyPostService() async {
    List<DocumentSnapshot> d =
        await CommonFunction().getPost("Posts/Gigs/Tasks");
    print("d =${d}");
    DocumentSnapshot present_absent = null;
    for (DocumentSnapshot snapshot in d) {
      if (snapshot.documentID == widget.snapshot.documentID) {
        setState(() {
          present_absent = snapshot;
        });
      }
    }
    // if (present_absent != null) {
    // } else {}

    print(widget.snapshot.documentID);
    print("Posts/Gigs/Tasks/${widget.snapshot.documentID}");
    try {
      bool isSubmitted = true;
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);

      // update post data
      Map<String, String> map = new Map<String, String>();
      List userTaskList =
          widget.snapshot["submittedBy"] ?? new List<Map<String, String>>();
      debugPrint("USERRR $userTaskList");
      for (var item in userTaskList) {
        map = ({
          "name": item["name"] ?? "",
          "emailId": item["emailId"] ?? "",
          "uploadWorkUri": item["uploadWorkUri"] ?? "",
          "userId": item["userId"] ?? "",
          "phoneNo": item["phoneNo"] ?? "",
        });
      }

      String workedImgFileUri = await uploadToStorage(_workedImgFile);
      debugPrint("IIIIIIIIIIIIIMMMMMMMMMMMM $workedImgFileUri");
      if (workedImgFileUri != null) {
        map = {
          "name": name,
          "emailId": emailId,
          "phoneNo": phoneNo,
          "userId": userId,
          "uploadWorkUri": workedImgFileUri,
          "imgUri": widget.snapshot["imgUri"],
          "logoUri": widget.snapshot["logoUri"],
          //"target": widget.snapshot["target"],
          "taskDesc": widget.snapshot["taskDesc"],
          "reward": widget.snapshot["reward"] ?? "",
          "status": "applied",
          "companyName": widget.snapshot["companyName"],
          "taskTitle": widget.snapshot["taskTitle"],
          "user email": collegeNameCont.text,
          "showUser1":showUser1.text ?? " ",
          "showUser2":showUser1.text ?? " ",
        };
        widget.snapshot.data["submitedBy"] = map;
        Map<String, dynamic> updatedPost;
        if (present_absent != null) {
          var m = present_absent["submittedBy"];
          m.add(map);
          setState(() {
            updatedPost = {"submittedBy": m};
          });
          print("Data =$m");
          print("%${updatedPost}");
        } else {
          setState(() {
            updatedPost = {
              "submittedBy": [map]
            };
          });
        }
        print("%${updatedPost}");
//          Map<String,dynamic> updatedPost = {
//            "submittedBy" : map
//          };
        pendingTasksMap[widget.snapshot.documentID] = false;
        await _firestore
            .collection("Users")
            .document(phoneNo)
            .setData({"pendingTasks": pendingTasksMap}, merge: true);
        await _firestore
            .collection("Posts")
            .document("Gigs")
            .collection("Tasks")
            .document(widget.snapshot.documentID)
            .setData(updatedPost, merge: true);
        pendingPostList.add(widget.snapshot.documentID.toString());
        debugPrint("PPPPPPPPPPPPPPP $pendingTaskList");
        prefs.setStringList("pendingTasks", pendingPostList);
        setState(() {
          isSubmitted=true;
        });
      } else {
        isSubmitted = false;
      }

////      String pendigAmount = userData["pendingAmount"] ?? "0";
////      pendigAmount = (int.parse(pendigAmount??"0") + int.parse(widget.snapshot["reward"]??"0")).toString() ;
////      userData["pendingAmount"] = pendigAmount;
////      if(isSubmitted == true) {
////        await  _firestore.collection("Users").document(phoneNo).setData(userData,merge: true)
////            .whenComplete(() {
////          isApplied = true;
////          pendingPostList.add(widget.snapshot.documentID.toString());
////          prefs.setStringList("pendingPost", pendingPostList);
////        })
////            .catchError((error){
////              isSubmitted = false;
////
////        });
////      }
//
      if (isSubmitted == true) {
        Fluttertoast.showToast(
            msg: "Submitted successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "getting some error",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      debugPrint("Exception : (applyPostService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  Future<String> uploadToStorage(File file) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(file.path);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    debugPrint("Upload ${uploadTask.isComplete}");
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
