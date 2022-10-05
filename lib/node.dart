import 'package:flutter/material.dart';

class Node {
  Node(
      {this.type = "",
      this.id = "0",
      this.title = "",
      this.inputs = const [],
      this.outputs = const [],
      this.x = 0,
      this.y = 0,
      this.classId = "",
      this.isItCalss = false,
      this.varName = "",
      this.isItVar = false,
      this.visble = true,
      this.size = const Size(150, 100),
      this.color = Colors.red});
  bool isItVar;
  bool isItCalss;
  dynamic classId;
  dynamic varName;
  String id;
  String type;
  String title;
  Color color;
  double x;
  double y;
  bool visble;
  Size size;

  List<Map<String, dynamic>> inputs = [];
  List<Map<String, dynamic>> outputs = [];
}
