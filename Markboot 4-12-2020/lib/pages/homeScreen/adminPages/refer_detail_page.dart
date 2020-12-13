import 'package:flutter/material.dart';
class ReferDetailPage extends StatelessWidget {
  List<dynamic> a=[];
  final String rid;
  ReferDetailPage({@required this.rid,@required this.a});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(rid),),
      body: ListView.builder(itemBuilder: (context,i) {
        Divider();
        return ListTile(title: Text(a[i]),);
      },scrollDirection: Axis.vertical,itemCount: a.length,),
    );
  }
}
