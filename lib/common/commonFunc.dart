import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommonFunction {

  final String serverToken = 'AAAALKQaw9U:APA91bHOFcWpFCw1mSZq7bRhlSkQBdKXg_OhV4M1__RrGwzx7uZubmOD37nZdnmZKzfbSNDMwDFGVbAhTpsYpu0lePZkuwjW2SgOUhNb57Cwd0YPI6cbjSXIKvojYFpNirTuB1L3rVkT';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Firestore _firestore = Firestore();

  Future<void> showProgressDialog({@required bool isShowDialog,@required context}) {
    if(isShowDialog) {
      showDialog(context: context,
          builder: (context){
            return Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          });
    }
    else if(Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<List<DocumentSnapshot>> getPost(String path)async {
    try {
      List<DocumentSnapshot> documents = new List<DocumentSnapshot>();
//      debugPrint("SnapshotNAME 123");
//      print(path);
      QuerySnapshot querySnapshot =  await _firestore.collection(path).getDocuments();
      //print(querySnapshot);
      for(DocumentSnapshot snapshot in querySnapshot.documents) {
        print(snapshot.data);
        //debugPrint("SnapshotNAME ${snapshot["task"]}");
        documents.add(snapshot);
      }
      return documents;
    }
    catch(e) {
      debugPrint("Exception (getRecentPost) : ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String body,String title) async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    var jsonRes = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: json.encode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body':body,
            'title':title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/all",
        },
      ),
    );

    var jsonData = jsonRes.body;
    debugPrint("msgReqData $jsonData");

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }


}