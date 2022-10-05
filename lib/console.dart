import 'package:clipboard/clipboard.dart';
import 'package:example/colors.dart';
import 'package:flutter/material.dart';

class Console extends StatefulWidget {
  Console({this.logs = const [], required this.onDelete});
  List<String> logs;
  Function onDelete;

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 500,
        width: 550,
        decoration: BoxDecoration(
            color: backGroundColor,
            border: Border.all(width: 2, color: selectedNodeColor),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: text("Console"),
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      iconButton(() {
                        Future.delayed(Duration.zero, () {
                          FlutterClipboard.copy(widget.logs.toString());
                        });
                      }, Icons.copy_all),
                      IconButton(
                        onPressed: () {
                          widget.onDelete();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: selectedNodeColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: selectedNodeColor,
              thickness: 1,
            ),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.logs
                      .map(
                        (e) => text(e),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text text(String txt) {
    return Text(
      txt,
      style: TextStyle(
          color: selectedNodeColor, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  IconButton iconButton(Function onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed(),
      icon: Icon(
        icon,
        color: selectedNodeColor,
      ),
    );
  }
}
