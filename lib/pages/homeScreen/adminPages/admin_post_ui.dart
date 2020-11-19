import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPostAdminPage extends StatefulWidget {
  String type;
  String subtype;

  AddPostAdminPage({this.type, this.subtype});

  @override
  _AddPostAdminPageState createState() => _AddPostAdminPageState();
}

class _AddPostAdminPageState extends State<AddPostAdminPage> {
  CommonWidget commonWidget = CommonWidget();
  List<String> types = ["Gigs", "Offers", "Internship", "Tournament"];
  String selectedType;
  TextEditingController titleCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController companyCont = TextEditingController();
  TextEditingController amountCont = TextEditingController();
  TextEditingController maxStatusCont = TextEditingController();
  TextEditingController targetCont = TextEditingController();
  TextEditingController cashbackCont = TextEditingController();
  TextEditingController instructionCont = TextEditingController();
  TextEditingController cashbackLinkCont = TextEditingController();
  TextEditingController salaryCont = TextEditingController();
  TextEditingController locationCont = TextEditingController();
  TextEditingController durationCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();
  TextEditingController startDateCont = TextEditingController();
  TextEditingController applyByCont = TextEditingController();
  TextEditingController skillsReqCont = TextEditingController();
  File _fileImg;
  File _companyFileImg;
  File _sampleFileImg;
  File _offerFileImg;
  final picker = ImagePicker();
  String selectedSubType;
  List<String> subTypeList = new List();
  bool isClickcompanyLogo = false;
  bool isShowTasksUI = false;
  bool isShowCampaignUI = false;
  bool isShowCashbacksUI = false;
  bool isShow50on500UI = false;
  bool isShowCouponsUI = false;
  bool isShowInternshipUI = false;
  bool isShowTournamentUI = false;
  bool isImportant=false;
  bool isClickOfferPic=false;
  TextEditingController questionCont = TextEditingController();
  TextEditingController option1Cont = TextEditingController();
  TextEditingController option2Cont = TextEditingController();
  TextEditingController option3Cont = TextEditingController();
  TextEditingController option4Cont = TextEditingController();
  bool isClickSamplePic = false;

  List<Map<String, String>> questionMapList = new List();

  init() {
    if (widget.type.contains("Gigs")) {
      if (widget.subtype.contains("Gigs")) {
        isShowTasksUI = true;
      } else {
        isShowCampaignUI = true;
      }
    } else if (widget.type.contains("Offers")) {
      if (widget.subtype.contains("Cashback")) {
        isShowCashbacksUI = true;
      } else if (widget.subtype.contains("Coupons")) {
        isShowCouponsUI = true;
      } else {
        isShow50on500UI = true;
      }
    } else if (widget.type.contains("Internship")) {
      isShowInternshipUI = true;
    } else if (widget.type.contains("Tournament")) {
      isShowTournamentUI = true;
    }
    setState(() {});
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
      appBar: AppBar(
        backgroundColor: Color(0xff051094),
        title: Text(
          "Create a Post",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: commonWidget.commonTextField(
                    controller: companyCont, inputText: "Company Name")),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Company Logo",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  showPickImageDialog(_companyFileImg);
                  isClickcompanyLogo = true;
                  setState(() {});
                },
                child: showCamera(_companyFileImg)),
            Center(
                child: commonWidget.commonTextField(
                    controller: titleCont, inputText: "Task Title ")),
            Visibility(
              visible: (isShowCashbacksUI || isShow50on500UI) ?? false,
              child: SwitchListTile(
                  title: Text("Starred"),
                  value: isImportant, onChanged: (a) {
                setState(() {
                  isImportant=!isImportant;
                });
              }),
            ),
            Visibility(
              visible: (isShowTournamentUI) ?? false,
              child: tournamentPostUI(),
            ),
            Visibility(
              visible: (isShowTasksUI ||
                      isShowCampaignUI ||
                      isShowCashbacksUI ||
                      isShow50on500UI ||
                      isShowCouponsUI ||
                      isShowInternshipUI) ??
                  false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: descCont,
                      inputText: "Description ",
                      lines: 5)),
            ),
            Visibility(
              visible: (isShowCashbacksUI || isShow50on500UI) ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: cashbackCont,
                      inputText: "Cashback Amount",
                      keyboardType: TextInputType.number)),
            ),
            Visibility(
              visible:
                  (isShowCashbacksUI || isShow50on500UI || isShowCouponsUI) ??
                      false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: instructionCont,
                      inputText: "Instruction",
                      lines: 5,
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: (isShowCashbacksUI ||
                      isShow50on500UI ||
                      isShowCouponsUI ||
                      isShowTasksUI) ??
                  false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: cashbackLinkCont,
                      inputText: "Link",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowCampaignUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: targetCont, inputText: "Target ", lines: 2)),
            ),
            Visibility(
                visible:
                ( isShowCampaignUI ) ??
                    false,
                child: Center(
                    child: commonWidget.commonTextField(
                        controller: maxStatusCont,
                        inputText: "Max status value ",
                        keyboardType: TextInputType.number))),
            Visibility(
                visible:
                    (isShowTasksUI || isShowCampaignUI || isShowTournamentUI) ??
                        false,
                child: Center(
                    child: commonWidget.commonTextField(
                        controller: amountCont,
                        inputText: "Reward",
                        keyboardType: TextInputType.number))),
            Visibility(
                visible:
                    (isShowTasksUI || isShowCampaignUI || isShowCashbacksUI) ??
                        false,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Sample Picture",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          showPickImageDialog(_sampleFileImg);
                          isClickSamplePic = true;
                          setState(() {});
                        },
                        child: showCamera(_sampleFileImg)),
                  ],
                )),
            Visibility(
                visible:
                (isImportant) ??
                    false,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Offer Picture",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          showPickImageDialog(_offerFileImg);
                          isClickOfferPic = true;
                          setState(() {});
                        },
                        child: showCamera(_offerFileImg)),
                  ],
                )),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: salaryCont,
                      inputText: "Salary",
                      keyboardType: TextInputType.number)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: locationCont,
                      inputText: "Location",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: durationCont,
                      inputText: "Duration",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: categoryCont,
                      inputText: "Category",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: designationCont,
                      inputText: "Designation",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: startDateCont,
                      inputText: "Start Date",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: applyByCont,
                      inputText: "Apply By",
                      keyboardType: TextInputType.text)),
            ),
            Visibility(
              visible: isShowInternshipUI ?? false,
              child: Center(
                  child: commonWidget.commonTextField(
                      controller: skillsReqCont,
                      inputText: "Skills Required",
                      keyboardType: TextInputType.text)),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Post Image",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      isClickcompanyLogo = false;
                      setState(() {});
                      showPickImageDialog(_fileImg);
                    },
                    child: showCamera(_fileImg)),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 260),
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  checkTaskService();
                },
                child: Text(
                  "Save",
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

  Widget tournamentPostUI() {
    int index = 0;
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Color(CommonStyle().blueCardColor),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: questionMapList.map((e) {
              index++;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$index.  ${e["question"]}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "1. ${e["option1"]}  ",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("2. ${e["option2"]}  ",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15)),
                        SizedBox(
                          width: 10,
                        ),
                        Text("3. ${e["option3"]}  ",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15)),
                        SizedBox(
                          width: 10,
                        ),
                        Text("4. ${e["option4"]}  ",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15)),
                      ],
                    ),
                  )
                ],
              );
            }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: 120,
              height: 50,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  showQuestionDialog();
                },
                child: Text(
                  "Add a question",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showQuestionDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
                child: Container(
              decoration: BoxDecoration(color: Colors.white),
              height: 400,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: questionCont,
                    maxLines: 4,
                    decoration: InputDecoration(hintText: "Enter question"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: option1Cont,
                    decoration: InputDecoration(hintText: "Enter option1"),
                  ),
                  TextField(
                    controller: option2Cont,
                    decoration: InputDecoration(hintText: "Enter option2"),
                  ),
                  TextField(
                    controller: option3Cont,
                    decoration: InputDecoration(hintText: "Enter option3"),
                  ),
                  TextField(
                    controller: option4Cont,
                    decoration: InputDecoration(hintText: "Enter option4"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        if (questionCont.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enter question",
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                          return;
                        } else if (option1Cont.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enter option 1",
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                          return;
                        } else if (option2Cont.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enter option 2",
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                          return;
                        } else if (option3Cont.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enter option 3",
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                          return;
                        } else if (option4Cont.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enter option 4",
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                          return;
                        } else {
                          questionMapList.add({
                            "question": questionCont.text,
                            "option1": option1Cont.text,
                            "option2": option2Cont.text,
                            "option3": option3Cont.text,
                            "option4": option4Cont.text
                          });
                          questionCont.clear();
                          option4Cont.clear();
                          option3Cont.clear();
                          option2Cont.clear();
                          option1Cont.clear();
                          setState(() {});
                          Fluttertoast.showToast(
                              msg: "Added successfully",
                              backgroundColor: Colors.green,
                              textColor: Colors.white);
                        }
                      },
                      child: Text("Save"),
                    ),
                  )
                ],
              ),
            )),
          );
        });
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
                    color: Color(CommonStyle().blueColor),
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
          await picker.getImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {
        debugPrint("ISCLICK $isClickcompanyLogo");
        if (isClickcompanyLogo == true) {
          _companyFileImg = File(pickedFile.path);
        } else if (isClickSamplePic == true) {
          _sampleFileImg = File(pickedFile.path);
          isClickSamplePic = false;
        } else if(isClickOfferPic){
          _offerFileImg=File(pickedFile.path);
          isClickOfferPic=false;
        }
        else {
          _fileImg = File(pickedFile.path);
        }
        isClickcompanyLogo = false;
      });
    } catch (e) {
      debugPrint("Exception : (pickImage) -> $e");
    }
  }

  pickImageCamera(showfileImg) async {
    try {
      final pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 100);
      setState(() {
        if (isClickcompanyLogo == true) {
          debugPrint("COMPANYLOOOOOGO");
          _companyFileImg = File(pickedFile.path);
        } else if (isClickSamplePic == true) {
          _sampleFileImg = File(pickedFile.path);
          isClickSamplePic = false;
        }
        else if(isClickOfferPic){
          _offerFileImg=File(pickedFile.path);
          isClickOfferPic=false;
        }
        else {
          _fileImg = File(pickedFile.path);
        }
        isClickcompanyLogo = false;
      });
    } catch (e) {
      debugPrint("Exception : (pickImage) -> $e");
    }
  }

  checkTaskService() async {
    String title = titleCont.text.trim().toString();
    String description = descCont.text.trim().toString();
    String amount = amountCont.text.trim().toString();
    String target = targetCont.text.trim().toString();
    String companyName = companyCont.text.trim().toString();
    String cashbackAmount = cashbackCont.text.trim().toString();
    String instruction = instructionCont.text.trim().toString();
    String link = cashbackLinkCont.text.trim().toString();
    String salary = salaryCont.text.trim().toString();
    String location = locationCont.text.trim().toString();
    String duration = durationCont.text.trim().toString();
    String category = categoryCont.text.trim().toString();
    String designation = designationCont.text.trim().toString();
    String startDate = startDateCont.text.trim().toString();
    String applyBy = applyByCont.text.trim().toString();
    int maxStatus= isShowCampaignUI?int.parse(maxStatusCont.text.trim().toString() ?? "0"):null;
    String skillReq = skillsReqCont.text.trim().toString();
    FirebaseAuth _firebase=FirebaseAuth.instance;
    FirebaseUser user= await _firebase.currentUser();
    print(user);
    if (companyName.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter company name",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }
    else if (maxStatus == null && isShowCampaignUI) {
      Fluttertoast.showToast(
          msg: "enter max status value",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }
    else if (_companyFileImg == null) {
      Fluttertoast.showToast(
          msg: "Select Company logo",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    } else if (title.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter task title",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    } else if (_fileImg == null) {
      Fluttertoast.showToast(
          msg: "Select Image",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }
    if (isShowTasksUI == true) {
      if (amount.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Reward",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (_sampleFileImg == null) {
        Fluttertoast.showToast(
            msg: "Please capture sample picture",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (link.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Website link",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      String samplePicUri = await uploadToStorage(_sampleFileImg);
      Map<String, String> postData = {
        "companyName": companyName,
        "taskTitle": title,
        "taskDesc": description,
        "reward": amount,
        "link": link,
        "samplePicUri": samplePicUri
      };
      uploadData(postData);
    } else if (isShowCampaignUI == true) {
      if (amount.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Reward",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (_sampleFileImg == null) {
        Fluttertoast.showToast(
            msg: "Please capture sample picture",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (target.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter target",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      String samplePicUri = await uploadToStorage(_sampleFileImg);
      Map<String, dynamic> postData = {
        "companyName": companyName,
        "taskTitle": title,
        "taskDesc": description,
        "reward": amount,
        "target": target,
        "samplePicUri": samplePicUri,
        "maxStatus":isShowCampaignUI?maxStatus:0,
      };
      uploadData(postData);
    } else if (isShowCashbacksUI || isShow50on500UI) {
      if (cashbackAmount.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter CashBack amount",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (instruction.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Instruction",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (link.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Link",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      String offerPicUri="";
      if(isImportant){
        offerPicUri = await uploadToStorage(_offerFileImg);
      }
      if (isShowCashbacksUI == true) {
        if (_sampleFileImg == null) {
          Fluttertoast.showToast(
              msg: "upload sample picture",
              backgroundColor: Colors.red,
              textColor: Colors.white);
          return;
        }
        CommonFunction()
            .showProgressDialog(isShowDialog: true, context: context);
        String samplePicUri = await uploadToStorage(_sampleFileImg);
        Map<String, dynamic> postData =isImportant?
        {
          "companyName": companyName,
          "taskTitle": title,
          "taskDesc": description,
          "cashbackAmount": cashbackAmount,
          "instruction": instruction,
          "link": link,
          "samplePicUri": samplePicUri,
          "offerPicUri":offerPicUri,
          "isImportant":isImportant,
        }:
        {
          "companyName": companyName,
          "taskTitle": title,
          "taskDesc": description,
          "cashbackAmount": cashbackAmount,
          "instruction": instruction,
          "link": link,
          "samplePicUri": samplePicUri,
        };
        uploadData(postData);
      } else {
        CommonFunction()
            .showProgressDialog(isShowDialog: true, context: context);
        Map<String, dynamic> postData = isImportant?{
          "companyName": companyName,
          "taskTitle": title,
          "taskDesc": description,
          "cashbackAmount": cashbackAmount,
          "instruction": instruction,
          "link": link,
          "offerPicUri":offerPicUri,
          "isImportant":isImportant,
        } :{
          "companyName": companyName,
          "taskTitle": title,
          "taskDesc": description,
          "cashbackAmount": cashbackAmount,
          "instruction": instruction,
          "link": link,
        };
        uploadData(postData);
      }
    } else if (isShowCouponsUI) {
      if (instruction.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Instruction",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (link.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Link",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      Map<String, String> postData = {
        "companyName": companyName,
        "taskTitle": title,
        "taskDesc": description,
        "instruction": instruction,
        "link": link
      };

      uploadData(postData);
    } else if (isShowInternshipUI) {
      if (description.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter description",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (salary.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter salary",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (location.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter location",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (duration.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Duration",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (category.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter category",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (designation.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter designation",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (startDate.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Start Date",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (applyBy.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Apply By ",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (skillReq.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Skill Required",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }

      Map<String, String> postData = {
        "companyName": companyName,
        "taskTitle": title,
        "taskDesc": description,
        "salary": salary,
        "location": location,
        "duration": duration,
        "category": category,
        "designation": designation,
        "startDate": startDate,
        "applyBy": applyBy,
        "skillReq": skillReq
      };
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      uploadData(postData);
    } else if (isShowTournamentUI) {
      if (questionMapList.length == 0) {
        Fluttertoast.showToast(
            msg: "Please add a question",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      debugPrint("CALLEd");
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      Map<String, dynamic> postData = {
        "companyName": companyName,
        "taskTitle": title,
        "questionList": questionMapList
      };
      uploadData(postData);
    }
  }

  uploadData(postData) async {
    try {
      String companyLogoUri = await uploadToStorage(_companyFileImg);
      String fileLogoUri = await uploadToStorage(_fileImg);
      String offerUri =  isImportant? await uploadToStorage(_offerFileImg):"";
      if (companyLogoUri != null && fileLogoUri != null) {
        postData["imgUri"] = fileLogoUri;
        postData["logoUri"] = companyLogoUri;
        isImportant?postData["offerUri"]=offerUri:print("A");
        savePostData(postData);
      } else {
        await CommonFunction()
            .showProgressDialog(isShowDialog: false, context: context);
      }
    } catch (e) {
      debugPrint("Exception : ${e.message}");
    }
  }

  Future<String> uploadToStorage(File uploadfile) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("image").child(uploadfile.path);
    final StorageUploadTask uploadTask = storageReference.putFile(uploadfile);
    debugPrint("Upload ${uploadTask.isComplete}");
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    var downloadUrl = await snapshot.ref.getDownloadURL();
    debugPrint("URL $downloadUrl");
    return downloadUrl;
  }

  savePostData(postData) async {
    try {
      Firestore firestore = Firestore();

      await firestore
          .collection("Posts")
          .document(widget.type)
          .collection(widget.subtype)
          .document()
          .setData(postData)
          .whenComplete(() async {
            String desc = descCont.text;
            String title = titleCont.text;
        await CommonFunction()
            .sendAndRetrieveMessage(desc, title);
        Fluttertoast.showToast(
            msg: "Save successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white);
            fieldClear();
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "getting some error.please contact to developer",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }).timeout(Duration(seconds: 30), onTimeout: () async {
        Fluttertoast.showToast(
            msg: "server not responding or your connection is too slow",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      });
    } catch (e) {
      debugPrint("error:${e.message}");
      debugPrint("Exception : (SavePostData)-> $e");
    }
    await CommonFunction()
        .showProgressDialog(isShowDialog: false, context: context);
    return;
  }
  fieldClear() {
    selectedType = null;
    titleCont.clear();
    targetCont.clear();
    descCont.clear();
    companyCont.clear();
    amountCont.clear();
    cashbackLinkCont.clear();
    instructionCont.clear();
    cashbackLinkCont.clear();
    cashbackCont.clear();
    salaryCont.clear();
    locationCont.clear();
    durationCont.clear();
    designationCont.clear();
    startDateCont.clear();
    applyByCont.clear();
    skillsReqCont.clear();
    _fileImg = null;
    _companyFileImg = null;
    questionMapList.clear();
    setState(() {});
  }
}
