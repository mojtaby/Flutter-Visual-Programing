// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'dart:convert';

import 'package:example/colors.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';

import 'package:smart_dropdown/smart_dropdown.dart';
import 'package:example/widgets.dart';
import 'package:flutter/material.dart';
import 'package:context_menu_macos/context_menu_macos.dart';
import 'package:metooltip/metooltip.dart';
import 'package:uuid/uuid.dart';
import 'node.dart';
import 'package:widget_arrows/widget_arrows.dart';

class NodeManger extends StatefulWidget {
  NodeManger(
      {Key? key,
      this.nodes = const [],
      required this.onSelect,
      required this.onDelete,
      required this.onPaste,
      required this.updateApp,
      required this.onDeleteClass,
      required this.onDeClass,
      required this.onClass,
      required this.onStopRun,
      required this.onRun})
      : super(key: key);

  List<Node> nodes;
  Function(Node) onSelect;
  Function(Node) onDelete;
  Function() onStopRun;
  Function(Node, Map<dynamic, dynamic>) onRun;
  Function(Node node, Node body) onClass;
  Function(Node node) onDeClass;
  Function(Node node) onDeleteClass;
  Function updateApp;
  Function(Node, TapDownDetails) onPaste;
  @override
  State<NodeManger> createState() => _NodeMangerState();
}

class _NodeMangerState extends State<NodeManger> {
  TransformationController controller = TransformationController();
  Node selectedNode = Node();
  dynamic hoveredInput;
  dynamic copyedNode = "null";
  // node:node,input:input
  var from = {};
  // node:node,input:input
  var target = {};
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        body: InteractiveViewer(
          child: Stack(
            children: widget.nodes
                .map(
                  (e) => Positioned(
                      top: e.y,
                      left: e.x,
                      child: GestureDetector(
                          onTap: () {
                            selectedNode = e;
                            widget.onSelect(selectedNode);
                            setState(() {});
                          },
                          onSecondaryTapDown: (details) {
                            contextMune(details, e);
                          },
                          onPanUpdate: (d) {
                            selectedNode = e;
                            e.x = d.delta.dx + e.x;
                            e.y = d.delta.dy + e.y;
                            setState(() {});
                          },
                          child: node(e))),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget node(Node e) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: IconButton(
              onPressed: () {
                e.visble = !e.visble;

                setState(() {});
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color:
                    selectedNode.id == e.id ? selectedNodeColor : Colors.white,
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// --------------------------------------- [inputs]-----------------------------------------

            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: e.inputs.map((en) {
                  if (en["canSetFromNode"] == true) {
                    return MeTooltip(
                      message: en["valueType"],
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (en["FromId"] != null) {
                            Node nd = widget.nodes[
                                widget.nodes.indexOf(en["FromId"]["node"])];
                            dynamic output = nd.outputs[
                                nd.outputs.indexOf(en["FromId"]["output"])];

                            output["targetId"] = null;
                            output["targetNode"] = null;
                            output["targetInputInedx"] = null;
                            if (en["valueType"] == "Num") {
                              en["value"] = 0;
                            } else if (en["valueType"] == "Color") {
                              en["value"] = Color.fromARGB(255, 9, 124, 255);
                            } else if (en["valueType"] == "IconData") {
                              en["value"] = Icons.abc;
                            }

                            en["isConected"] = false;

                            if (nd.isItVar) {
                              dynamic ndout =
                                  nd.outputs[nd.outputs.indexOf(output)];

                              ndout["targetNodesId"].remove(e);
                              ndout["targetsId"].remove(en["FromId"]["index"]);
                            }

                            en["fromVar"] = false;
                            en["FromId"] = null;
                            widget.updateApp();
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: [
                            MouseRegion(
                              onEnter: (event) {
                                if (e != from) {
                                  target["node"] = e;
                                  target["input"] = en;
                                }
                                hoveredInput = en;
                                setState(() {});
                              },
                              onExit: (e) {
                                target = {};
                                hoveredInput = null;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: e.visble ? 25 : 0,
                                    bottom: e.visble ? 25 : 0,
                                    right: e.visble ? 5 : 0),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: hoveredInput == en
                                        ? selectedNodeColor.withOpacity(0.5)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: nodeInputAndLineColor,
                                        width: 2)),
                                child: ArrowElement(
                                    color: nodeInputAndLineColor,
                                    stretchMax: 250,
                                    bow: 0,
                                    tipLength: 5,
                                    padEnd: 5,
                                    padStart: 2,
                                    id: en['id'].toString(),
                                    child: SizedBox()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }).toList()),

            /// --------------------------------------- [title]-----------------------------------------
            Visibility(
              visible: e.visble,
              replacement: Container(
                width: e.size.width,
                height: 30,
                decoration: BoxDecoration(
                  color: nodeTitleContaner,
                  border: Border.all(
                      width: 2,
                      color: e == selectedNode
                          ? selectedNodeColor
                          : nodeTextColorTwo),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Center(
                  child: Text(e.title,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          color: e == selectedNode
                              ? selectedNodeColor
                              : nodeTextColorTwo)),
                ),
              ),
              child: Container(
                  height: e.size.height,
                  width: e.size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedNode.id == e.id
                              ? selectedNodeColor
                              : Colors.transparent,
                          width: 2),
                      color: nodesColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: nodeTitleContaner,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          nodeIconSeter(
                              e.type,
                              e == selectedNode
                                  ? selectedNodeColor
                                  : nodeInputAndLineColor,
                              20),
                          Text(
                            e.title,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: nodeTextColorTwo),
                          ),
                          Text(e.varName,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  color: nodeTextColorTwo)),
                          Row(
                              children: e.inputs.map((en) {
                            if (en["haveDropDown"] != null &&
                                en["haveDropDown"] == true &&
                                en["showOnTitle"] != null &&
                                en["showOnTitle"] == true) {
                              return SizedBox(
                                width: 90,
                                child: DropDown(
                                  name: en["name"],
                                  items: en["DropDownList"] ?? [],
                                  onSelect: (itme) {
                                    en["value"] = itme;
                                    widget.updateApp();
                                    setState(() {});
                                  },
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }).toList())
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: e.inputs
                              .map(
                                (en) => en["show"] == null
                                    ? Visibility(
                                        visible: en["haveDropDown"] != null &&
                                            en["haveDropDown"] == true,
                                        child: Container(
                                            height: 40,
                                            width: 125,
                                            child: DropDown(
                                              name: en["name"],
                                              items: en["DropDownList"] ?? [],
                                              onSelect: (itme) {
                                                en["value"] = itme;
                                                widget.updateApp();
                                                setState(() {});
                                              },
                                            )),
                                        replacement: Visibility(
                                          visible: en["haveTextFiled"] &&
                                              !en["isConected"] &&
                                              en["valueType"] != "null",
                                          replacement: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 30),
                                            child: Visibility(
                                              visible: en["haveDropDown"] ==
                                                      null ||
                                                  en["haveDropDown"] == false,
                                              child: Text(
                                                e.type != "StatefulWidget"
                                                    ? en["name"]
                                                    : en["name"] !=
                                                            "StatefulWidget"
                                                        ? en["name"]
                                                        : e.varName,
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: nodeTextColorTwo),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                              width: 100,
                                              height: 60,
                                              child: en["valueType"] !=
                                                          "Color" &&
                                                      en["valueType"] !=
                                                          "IconData"
                                                  ? TextFiledForWork(
                                                      onIcon: () {
                                                        en["max"] = !en["max"];
                                                        widget.updateApp();
                                                        setState(() {});
                                                      },
                                                      haveIcon:
                                                          en["HaveMax"] != null
                                                              ? en["HaveMax"]
                                                              : false,
                                                      name: en["name"],
                                                      maxLength: 20,
                                                      type: en["valueType"],
                                                      value: en["value"]
                                                          .toString(),
                                                      onChanged: (eg) {
                                                        if (eg.isNotEmpty) {
                                                          if (en["valueType"] ==
                                                              "Num") {
                                                            en["value"] =
                                                                double.parse(
                                                                    eg);
                                                          } else {
                                                            en["value"] = eg;
                                                          }
                                                          widget.updateApp();
                                                          setState(() {});
                                                        }
                                                      })
                                                  : en["valueType"] == "Color"
                                                      ? Button(
                                                          text: en["name"],
                                                          onClick: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ColorPick(
                                                                      pikcerColor: en["value"] !=
                                                                              null
                                                                          ? en[
                                                                              "value"]
                                                                          : Colors
                                                                              .blue,
                                                                      colore:
                                                                          (ec) {
                                                                        en["value"] =
                                                                            ec;
                                                                        widget
                                                                            .updateApp();
                                                                        setState(
                                                                            () {});
                                                                      });
                                                                });
                                                          })
                                                      : IconPick(
                                                          newIcon: (icon) {
                                                          en["value"] = icon;
                                                          widget.updateApp();
                                                          setState(() {});
                                                        })),
                                        ),
                                      )
                                    : SizedBox(),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: e.outputs
                              .map(
                                (en) => Text(
                                  en["name"],
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: nodeTextColorTwo),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    )
                  ])),
            ),

            /// --------------------------------------- [outputs]-----------------------------------------

            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: e.outputs
                    .map(
                      (en) => GestureDetector(
                        onDoubleTap: () {
                          if (en["targetId"] != null && e.isItVar == false) {
                            dynamic nodee = widget
                                .nodes[widget.nodes.indexOf(en["targetNode"])]
                                .inputs[en[
                                    "targetNode"]
                                .inputs
                                .indexOf(en["targetInputInedx"])];
                            nodee["isConected"] = false;
                            nodee["FromId"] = null;
                            nodee["fromVar"] = false;
                            nodee["child"] != null
                                ? nodee["child"] = null
                                : nodee["value"] = null;

                            if (en["targetNode"].type == "Run") {
                              widget.onStopRun();
                            } else if (nodee["valueType"] == "Function") {
                              nodee["value"].remove(e);
                            } else if (en["targetNode"].type == "Screen") {
                              nodee["child"] = null;
                              widget.onDeClass(en["targetNode"]);
                              widget.updateApp();
                            } else if (en["targetNode"].title == "Row" ||
                                en["targetNode"].title == "Column" ||
                                en["targetNode"].title == "Stack") {
                              nodee["value"].remove(e);
                            }

                            en["targetId"] = null;
                            widget.updateApp();
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          margin: EdgeInsets.all(e.visble ? 5 : 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: e == selectedNode
                                      ? selectedNodeColor
                                      : nodeInputAndLineColor,
                                  width: 2)),
                          child: MeTooltip(
                            message: en["valueType"],
                            preferOri: PreferOrientation.up,
                            child: Padding(
                              padding: EdgeInsets.only(top: 4, left: 4),
                              child: GestureDetector(
                                child: ArrowElement(
                                  color: e == selectedNode
                                      ? selectedNodeColor
                                      : nodeInputAndLineColor,
                                  straights: false,
                                  stretchMax: 250,
                                  bow: 0.001,
                                  tipLength: 5,
                                  padEnd: 0,
                                  padStart: 2,
                                  id: Uuid().v1(),
                                  targetIds: e.isItVar
                                      ? en["targetsId"].length > 0
                                          ? en["targetsId"]
                                          : null
                                      : null,
                                  targetId: e.isItVar ? null : en["targetId"],
                                  child: CustomPaint(
                                    foregroundPainter: LinePinter(
                                        line:
                                            Offset(en["LineDx"], en["LineDy"])),
                                    child: GestureDetector(
                                      onTap: () {},
                                      onPanUpdate: (d) {
                                        from["node"] = e;
                                        from["input"] =
                                            e.outputs[e.outputs.indexOf(en)];
                                        en['isDraging'] = true;
                                        en['LineDx'] =
                                            en['LineDx'] + d.delta.dx;
                                        en['LineDy'] =
                                            en['LineDy'] + d.delta.dy;

                                        setState(() {});
                                      },
                                      onPanEnd: (d) {
                                        conect(en);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ],
        ),
      ],
    );
  }

// on conect 2node
  void conect(en) {
    if (from.isNotEmpty &&
        target.isNotEmpty &&
        from["node"] != target["node"] &&
        target["input"]["isConected"] == false) {
      if (target["input"]["valueType"] == "Any" ||
          en["valueType"] == target["input"]["valueType"]) {
        Node trgt = widget.nodes[widget.nodes.indexOf(target["node"])];
        Node frm = widget.nodes[widget.nodes.indexOf(from["node"])];

        if (trgt.title != "Row" &&
            trgt.title != "Column" &&
            trgt.title != "Stack" &&
            target["input"]["valueType"] != "Function") {
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["value"] = frm;
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["isConected"] =
              true;
        } else if (target["input"]["valueType"] == "Function") {
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["value"].add(frm);
        } else if (trgt.title == "Row" ||
            trgt.title == "Column" ||
            trgt.title == "Stack") {
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["value"].add(frm);
        }
        frm.outputs[frm.outputs.indexOf(from["input"])]["targetId"] =
            trgt.inputs[trgt.inputs.indexOf(target["input"])]["id"];

        en["targetInputInedx"] =
            trgt.inputs[trgt.inputs.indexOf(target["input"])];
        trgt.inputs[trgt.inputs.indexOf(target["input"])]["FromId"] = {
          "node": frm,
          "output": from["input"],
          "index": trgt.inputs[trgt.inputs.indexOf(target["input"])]["id"]
        };
        en["targetNode"] = trgt;
        if (frm.isItVar) {
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["varId"] =
              frm.outputs[0]["varId"] - 1;
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["fromVar"] = true;

          frm.outputs[frm.outputs.indexOf(from["input"])]["targetsId"]
              .add(trgt.inputs[trgt.inputs.indexOf(target["input"])]["id"]);
          frm.outputs[frm.outputs.indexOf(from["input"])]["targetNodesId"]
              .add(trgt);

          widget.updateApp();
        }
        if (trgt.type == "Math" && trgt.inputs.indexOf(target["input"]) == 2) {
          trgt.inputs[2]["value"] = frm.outputs[0]["varId"] - 1;
        }
        if (trgt.type == "GetItme" &&
            trgt.inputs.indexOf(target["input"]) == 0) {
          trgt.inputs[2]["ItmeType"] = frm.title == "List(Color)"
              ? "Color"
              : frm.title == "List(String)"
                  ? "String"
                  : frm.title == "List(Num)"
                      ? "Num"
                      : "IconData";
        }
        if (frm.title == "Itme" && frm.inputs.indexOf(from["input"]) == 0) {
          frm.outputs[2]["valueType"] = trgt.inputs[2]["ItmeType"];
        } else if (frm.title == "Itme" &&
            frm.inputs.indexOf(from["input"]) == 2) {
          frm.outputs[2]["value"] =
              trgt.inputs[trgt.inputs.indexOf(target["input"])]["value"];
        }
        if (trgt.title == "SetVar") {
          trgt.inputs[trgt.inputs.indexOf(target["input"])]["value"] =
              frm.outputs[0]["varId"] - 1;
          trgt.inputs[1]["valueType"] = frm.outputs[0]["valueType"];

          trgt.inputs[trgt.inputs.indexOf(target["input"])]["isConected"] =
              true;
        }
        if (target["node"].type != "var" && target["node"].type != "Run") {
          if (target["node"].isItCalss) {
            trgt.inputs[1]["child"] = frm;
            widget.onClass(trgt, frm);
          } else {
            trgt.inputs[trgt.inputs.indexOf(target["input"])]["child"] = frm;
          }
        } else if (target["node"].type == "Run") {
          widget.onRun(frm, target);
        }

        widget.updateApp();
        from = {};
        target = {};
        en['LineDx'] = 0;
        en['LineDy'] = 0;
      } else {
        from = {};
        en['LineDx'] = 0;
        en['LineDy'] = 0;
      }
    } else {
      from = {};
      en['LineDx'] = 0;
      en['LineDy'] = 0;
    }
    setState(() {});
  }

  dynamic contextMune(details, Node node) {
    return showMacosContextMenu(
      context: context,
      globalPosition: details.globalPosition,
      children: [
        MacosContextMenuItem(
          content: Text('Delete'),
          onTap: () {
            Future.delayed(Duration(milliseconds: 1), () {
              widget.onDelete(node);
              Navigator.pop(context);
            });
            if (node.isItCalss) {
              widget.onDeleteClass(node);
            }
            node.inputs.forEach((en) {
              print(widget.nodes[widget.nodes.indexOf(en["targetNode"])]
                  .outputs[en["targetInputInedx"]]["targetId"]);
              widget.nodes[widget.nodes.indexOf(en["targetNode"])]
                  .outputs[en["targetInputInedx"]]["targetId"] = null;
            });
            node.outputs.forEach((en) {
              dynamic tartget =
                  widget.nodes[widget.nodes.indexOf(en["targetNode"])];
              dynamic targetinputs = tartget
                  .inputs[tartget.inputs.indexOf(en["targetInputInedx"])];

              if (en["targetNode"].type == "Screen") {
                widget.onDeClass(en["targetNode"]);
              }

              targetinputs["value"] = null;
              targetinputs["targetId"] = null;
              targetinputs["targetNode"] = null;
              targetinputs["fromVar"] = false;

              targetinputs["child"] = null;
              targetinputs["isConected"] = false;
              en["targetId"] = null;
              en["targetNode"] = null;
              en["targetInputInedx"] = null;
              if (tartget.type == "Run") {
                widget.onStopRun();
              }
            });
            widget.updateApp();
            setState(() {});
          },
        ),
      ],
    );
  }
}

class LinePinter extends CustomPainter {
  LinePinter({this.line = const Offset(0, 0)});
  Offset line;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.strokeCap = StrokeCap.round;
    paint.color = nodeInputAndLineColor;
    paint.strokeWidth = 4;
    paint.strokeJoin = StrokeJoin.round;
    paint.style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), line, paint);
  }

  @override
  bool shouldRepaint(LinePinter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(LinePinter oldDelegate) => true;
}
