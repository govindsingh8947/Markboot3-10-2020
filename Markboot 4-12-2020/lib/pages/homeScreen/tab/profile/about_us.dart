import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          margin: EdgeInsets.only(top: 30, left: 10),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "About Us",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 25),
          child: Text(
            "Markboot ​ is an ​ Indian marketing company with a mission to positively impact the country at this"
            "time of COVID-19 which is having a very dangerous impact on businesses and employment. We"
            "are empowering brands and students to work together to unleash their potential. The company’s"
            "exclusive marketing services form a comprehensive Brand Enhancement System. We expertise"
            "in marketing services like - digital marketing, social media marketing, advertisements, lead"
            "generations, content management, etc. Markboot provides a complete ​ marketing guide and"
            "services​ . Markboot comes under first choice to customers searching for marketing their"
            "products or brands. Markboot comprises highly dynamic and energetic people ready to meet"
            "and exceed the client’s expectations."
            "We are open to all kinds of marketing related requests, answer queries, arrange service calls,"
            "follow up, and provide optimum customer experience. Markboot ​ exists to understand the"
            "marketing needs of the customers & provide them the ​ best-in-class services​ . We are a"
            "strategic brand engaging with customers to establish and maintain long-term and high touch"
            "relationships.",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
