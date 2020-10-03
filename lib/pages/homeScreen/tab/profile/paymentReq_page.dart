import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

extension RandomOfDigits on Random {
  /// Generates a non-negative random integer with a specified number of digits.
  ///
  /// Supports [digitCount] values between 1 and 9 inclusive.
  int nextIntOfDigits(int digitCount) {
    assert(1 <= digitCount && digitCount <= 9);
    int min = digitCount == 1 ? 0 : pow(10, digitCount - 1);
    int max = pow(10, digitCount);
    return min + nextInt(max - min);
  }
}

class PaymentRequestPage extends StatefulWidget {
  @override
  _PaymentRequestPageState createState() => _PaymentRequestPageState();
}

class _PaymentRequestPageState extends State<PaymentRequestPage> {
  List<String> paymentMethod = ["Paytm", "PhonePay", "Google Pay"];
  String selectedPayMethod;
  TextEditingController phoneNoCont = TextEditingController();
  TextEditingController amountCont = TextEditingController();
  TextEditingController email = TextEditingController();

  String userPhoneNo;
  SharedPreferences prefs;
  String name;
  init() async {
    prefs = await SharedPreferences.getInstance();
    userPhoneNo = prefs.getString("userPhoneNo") ?? "";
    name = prefs.getString("userName");
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
        //backgroundColor: Color(CommonStyle().blueColor),
        backgroundColor: Color(0xff051094),
        title: Text(
          "Payment Request",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButton(
                hint: Text(
                  "Select Payment Method",
                  style: TextStyle(color: Colors.black),
                ),
                dropdownColor: Color(0xff051094),
                isExpanded: true,
                onChanged: (value) {
                  selectedPayMethod = value;
                  setState(() {});
                },
                value: selectedPayMethod,
                items: paymentMethod.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CommonWidget().commonTextField(
                controller: phoneNoCont,
                hintText: "Phone number",
                keyboardType: TextInputType.number),
            CommonWidget().commonTextField(
                controller: email,
                hintText: "Email ID",
                keyboardType: TextInputType.text),
            CommonWidget().commonTextField(
                controller: amountCont,
                hintText: "Amount",
                keyboardType: TextInputType.number),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  requestAmountService();
                },
                child: Text(
                  "Request",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> requestAmountService() async {
    try {
      FocusScope.of(context).unfocus();
      //String user_name = name;
      String amount = amountCont.text;
      String phoneNo = phoneNoCont.text;
      String emailId = email.text;
      if (phoneNo.length > 10) {
        phoneNo = phoneNo.substring(phoneNo.length - 10);
      }

      if (selectedPayMethod == null) {
        Fluttertoast.showToast(
            msg: "Select payment method.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (amount.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter a valid amount",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (phoneNo.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter valid phone number.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      } else if (emailId.isEmpty || !emailId.contains("@gmail.com")) {
        Fluttertoast.showToast(
            msg: "Enter valid phone number.",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }

      CommonFunction().showProgressDialog(isShowDialog: true, context: context);

      // print("print ${name}");
      Random random = new Random();
      // int randomNumber = random.nextIntOfDigits(9);
      // print(random.nextIntOfDigits(9));
      DocumentSnapshot snapshot = await Firestore.instance
          .collection("Users")
          .document(userPhoneNo)
          .get();
      Map<String, dynamic> userData = snapshot.data;
      //String requestAmount = userData["requestAmount"] ?? "0";
      String approvedAmount = userData["approvedAmount"] ?? "0";
      print(approvedAmount);
      print(userPhoneNo);
      // if (int.parse(requestAmount) > 0) {
      //   Fluttertoast.showToast(
      //       msg: "Another transaction is in progress",
      //       backgroundColor: Colors.red,
      //       textColor: Colors.white);
      //   CommonFunction()
      //       .showProgressDialog(isShowDialog: false, context: context);
      //   return;
      // }

      // requestAmount = (int.parse(requestAmount) + int.parse(amount)).toString();
      approvedAmount =
          (int.parse(approvedAmount) - int.parse(amount)).toString();
      print(approvedAmount);
      if (int.parse(approvedAmount) < 0) {
        Fluttertoast.showToast(
            msg: "please try again or contact to admin",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        CommonFunction()
            .showProgressDialog(isShowDialog: false, context: context);
        return;
      }
      var req = userData["request"] ?? List();
      req.add({
        "user_name": name,
        "transaction_id": random.nextIntOfDigits(9).toString(),
        "requestAmount": amount,
        "paymentMethod": selectedPayMethod,
        "paymentNo": phoneNo,
        "paymentemail": emailId,
        "status": "Processing",
      });
      print("req =$req");
      await Firestore.instance
          .collection("Users")
          .document(userPhoneNo)
          .setData({"approvedAmount": approvedAmount, "request": req},
              merge: true);

      Fluttertoast.showToast(
          msg:
              "Added payment request successfully \n Amount Transfer in 48 Hours",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Please try again",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      debugPrint("Exception :(requestAmountService)-> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }
}
