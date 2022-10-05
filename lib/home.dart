import 'package:example/colors.dart';
import 'package:example/widgets.dart';
import 'package:example/work_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Stack(children: [
        Image.network(
          "https://i.postimg.cc/wjBJXKr0/Cover-1.png",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flutter Node App Builder",
                style: TextStyle(
                    color: selectedNodeColor,
                    fontSize: 70,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 700,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    text("Build app in", nodeTextColorTwo),
                    text("seconds !", selectedNodeColor),
                    text("Free ", selectedNodeColor),
                    text(",", nodeTextColorTwo),
                    text("Open Source", selectedNodeColor),
                    text(",", nodeTextColorTwo),
                    text("Easy ", selectedNodeColor),
                    text(",", nodeTextColorTwo),
                    text("Fun ", selectedNodeColor),
                    text(",", nodeTextColorTwo),
                    text("and You ", selectedNodeColor),
                    text(",", nodeTextColorTwo),
                    text("Don't need any ", selectedNodeColor),
                    text("Experience ", selectedNodeColor),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(200.0),
              child: SizedBox(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Button(
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkPage()));
                      },
                      text: "Start",
                    ),
                    Button(
                      onClick: () {
                        launchUrlString(
                            "https://github.com/mojtaby/Flutter-Visual-Programing",
                            mode: LaunchMode.platformDefault);
                        //
                      },
                      text: "Source",
                    )
                  ],
                ),
              ),
            ))
      ]),
    );
  }

  Text text(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}
