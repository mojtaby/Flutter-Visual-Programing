// ignore_for_file: unnecessary_statements

import 'package:example/code_viwer.dart';
import 'package:example/colors.dart';
import 'package:clipboard/clipboard.dart';
import 'package:example/console.dart';

import 'package:example/node.dart';
import 'package:example/node_manger.dart';
import 'package:example/nodes.dart';
import 'package:example/widgets.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:widget_arrows/widget_arrows.dart';

class WorkPage extends StatefulWidget {
  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  List<Node> nodes = [];
  int index = 0;
  List<Screen> userScreens = [];
  int selectedVar = -1;
  int selectedScreenNode = 0;
  int screenIndex = 0;
  Node appe = Node();
  bool isRunningWidgetCreated = false;
  bool isRunning = false;
  bool showApp = true;
  bool appBar = true;
  Size privewSize = Size(350, 300);
  String log = "Create Screen";
  Node runningWidget = Node();
  dynamic runningWidgetInput;
  List<String> logs = [];
  @override
  Widget build(BuildContext context) {
    privewSize = Size(350, MediaQuery.of(context).size.height - 40);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Visibility(
        visible: !isRunning,
        replacement: Container(
          height: double.infinity,
          width: double.infinity,
          color: backGroundColor,
          child: Stack(
            children: [
              IconButton(
                  onPressed: () {
                    isRunning = false;

                    setState(() {});
                  },
                  icon: Icon(
                    Icons.back_hand_rounded,
                    color: selectedNodeColor,
                    size: 40,
                  )),
              Center(
                child: appPley(),
              ),
            ],
          ),
        ),
        child: Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ArrowContainer(
                    child: NodeManger(
                      onDeleteClass: (e) {
                        userScreens.remove(userScreens[e.classId]);

                        setState(() {});
                      },
                      onClass: (node, body) {
                        selectedScreenNode = node.classId - 1;

                        userScreens[selectedScreenNode].child =
                            node.inputs[1]["child"];
                        if (isRunning == false) {
                          appe = node.inputs[1]["child"];
                        }

                        setState(() {});
                      },
                      onStopRun: () {
                        appe = Node();
                        isRunning = false;
                        setState(() {});
                      },
                      onDeClass: (e) {
                        appe = Node();
                        userScreens[e.classId - 1].child = Node();

                        setState(() {});
                      },
                      onRun: (e, en) {
                        isRunning = true;

                        if (e.inputs[1]["child"] != null) {
                          runningWidget = e;
                          runningWidgetInput = en;
                          appe = e.inputs[1]["child"];
                          userScreens[screenIndex].child = appe;
                        } else {
                          appe = e;
                        }

                        setState(() {});
                      },
                      updateApp: () {
                        if (userScreens.length > screenIndex) {
                          userScreens[screenIndex].child = appe;
                          setState(() {});
                        }
                      },
                      nodes: nodes,
                      onPaste: (e, p) {
                        nodes.add(Node(
                            id: Uuid().v1(),
                            inputs: e.inputs
                                .map((e) => {
                                      'targetId': e['targetId'],
                                      'id': Uuid().v1(),
                                      'LineDx': 0,
                                      'LineDy': 0,
                                      'valueType': e["valueType"],
                                      'value': null
                                    })
                                .toList(),
                            outputs: e.outputs
                                .map((e) => {
                                      'targetId': e['targetId'],
                                      'id': Uuid().v1(),
                                      'LineDx': 0,
                                      'LineDy': 0,
                                      'valueType': e["valueType"],
                                      'value': null
                                    })
                                .toList(),
                            title: e.title,
                            color: e.color,
                            x: p.globalPosition.dx,
                            y: p.globalPosition.dy));
                        setState(() {});
                      },
                      onDelete: (e) {
                        nodes.remove(e);
                        setState(() {});
                      },
                      onSelect: (e) {
                        if (e.isItCalss && isRunning == false) {
                          selectedScreenNode = e.classId - 1;
                          screenIndex = e.classId - 1;
                          appe = e.inputs[1]["child"] ?? Node();
                          userScreens[screenIndex].child = appe;
                          setState(() {});
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              if (e.isItVar && e.type != "List") {
                                selectedVar = e.outputs[0]["varId"];
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: nodeBarColor,
                                        border: Border.all(
                                            color: selectedNodeColor, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 300,
                                    width: 500,
                                    child: Column(
                                      children: [
                                        TextFiledForWork(
                                            onIcon: () {},
                                            haveIcon: false,
                                            name: "Var Name",
                                            maxLength: 20,
                                            type: "String",
                                            value: e.varName,
                                            onChanged: (eg) {
                                              e.varName =
                                                  eg.replaceAll(" ", "");
                                              userScreens[screenIndex]
                                                  .vars[selectedVar - 1]
                                                  .varName = e.varName;
                                              userScreens[screenIndex].child =
                                                  appe;
                                              setState(() {});
                                            }),
                                        e.title != "Color" &&
                                                e.title != "IconData"
                                            ? TextFiledForWork(
                                                onIcon: () {},
                                                haveIcon: false,
                                                name: "Var Value",
                                                maxLength: 20,
                                                type: e.title,
                                                value: e.outputs[0]["value"]
                                                    .toString(),
                                                onChanged: (eg) {
                                                  if (eg.isNotEmpty) {
                                                    if (e.outputs[0]
                                                            ["valueType"] ==
                                                        "Num") {
                                                      e.outputs[0]["value"] =
                                                          double.parse(eg);
                                                      userScreens[screenIndex]
                                                          .vars[selectedVar - 1]
                                                          .value = double.parse(eg);
                                                      userScreens[screenIndex]
                                                          .child = appe;
                                                    } else {
                                                      e.outputs[0]["value"] =
                                                          eg;
                                                      userScreens[screenIndex]
                                                          .vars[selectedVar - 1]
                                                          .value = eg;
                                                      userScreens[screenIndex]
                                                          .child = appe;
                                                    }

                                                    setState(() {});
                                                  }
                                                })
                                            : e.title == "Color"
                                                ? Button(
                                                    text: "Pick Color",
                                                    onClick: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return ColorPick(
                                                                pikcerColor: e
                                                                        .outputs[
                                                                    0]["value"],
                                                                colore: (eg) {
                                                                  e.outputs[0][
                                                                      "value"] = eg;
                                                                  userScreens[
                                                                          screenIndex]
                                                                      .vars[
                                                                          selectedVar -
                                                                              1]
                                                                      .value = eg;
                                                                  userScreens[
                                                                          screenIndex]
                                                                      .child = appe;

                                                                  setState(
                                                                      () {});
                                                                });
                                                          });
                                                    },
                                                  )
                                                : IconPick(newIcon: (icone) {
                                                    e.outputs[0]["value"] =
                                                        e.outputs[0]["value"] =
                                                            icone;
                                                    userScreens[screenIndex]
                                                        .vars[selectedVar - 1]
                                                        .value = icone;
                                                    userScreens[screenIndex]
                                                        .child = appe;

                                                    setState(() {});
                                                  })
                                      ],
                                    ),
                                  ),
                                );
                              } else if (e.type == "List") {
                                selectedVar = e.outputs[0]["varId"];
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: nodeBarColor,
                                        border: Border.all(
                                            color: selectedNodeColor, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 300,
                                    width: 500,
                                    child: Column(
                                      children: [
                                        TextFiledForWork(
                                            onIcon: () {},
                                            haveIcon: false,
                                            name: "Var Name",
                                            maxLength: 20,
                                            type: "String",
                                            value: e.varName,
                                            onChanged: (eg) {
                                              e.varName =
                                                  eg.replaceAll(" ", "");
                                              userScreens[screenIndex]
                                                  .vars[selectedVar - 1]
                                                  .varName = e.varName;
                                              userScreens[screenIndex].child =
                                                  appe;
                                              setState(() {});
                                            }),
                                        Column(
                                          children: userScreens[screenIndex]
                                              .vars[selectedVar - 1]
                                              .value
                                              .map<Widget>((eg) {
                                            dynamic varr =
                                                e.outputs[0]["value"];
                                            int itme = varr.indexOf(eg);
                                            return AddItmeToList(
                                                varr: e,
                                                onDelete: () {
                                                  varr.remove(eg);

                                                  userScreens[screenIndex]
                                                      .vars[selectedVar - 1]
                                                      .value = varr;
                                                  Navigator.pop(context);
                                                },
                                                onEdit: (e) {
                                                  varr[itme] = e;
                                                  userScreens[screenIndex]
                                                      .vars[selectedVar - 1]
                                                      .value[itme] = varr[itme];
                                                  userScreens[screenIndex]
                                                      .child = appe;

                                                  setState(() {});
                                                },
                                                value: varr[varr.indexOf(eg)]);
                                          }).toList(),
                                        ),
                                        Button(
                                            text: "Add Itme",
                                            onClick: () {
                                              dynamic value = e.title ==
                                                      "List(Color)"
                                                  ? Colors.red
                                                  : e.title == "List(String)"
                                                      ? "String"
                                                      : e.title == "List(Num)"
                                                          ? 0
                                                          : Icons.abc;

                                              e.outputs[0]["value"].add(value);
                                              userScreens[screenIndex]
                                                      .vars[selectedVar - 1]
                                                      .value =
                                                  e.outputs[0]["value"];

                                              Navigator.pop(context);
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              } else if (e.isItCalss == true) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: nodeBarColor,
                                        border: Border.all(
                                            color: selectedNodeColor, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 400,
                                    width: 600,
                                    child: Column(
                                      children: [
                                        TextFiledForWork(
                                            onIcon: () {},
                                            haveIcon: false,
                                            name: "Class name",
                                            maxLength: 20,
                                            type: "String",
                                            value: e.varName,
                                            onChanged: (eg) {
                                              e.varName = eg;
                                              userScreens[selectedScreenNode]
                                                  .name = eg;

                                              setState(() {});
                                            }),
                                        userScreens[selectedScreenNode]
                                                    .vars
                                                    .length >
                                                0
                                            ? VarPicker(
                                                vars: userScreens[
                                                        selectedScreenNode]
                                                    .vars,
                                                onPick: (e) {},
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            });
                      },
                    ),
                  ),
                ),
                widgets(),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, left: 9, right: 9, bottom: 2),
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedNodeColor),
                        child: TextButton(
                          onPressed: () {
                            if (userScreens.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CodeViwer(
                                    userScreen: userScreens,
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(
                            Icons.code,
                            color: nodeBarColor,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, left: 9, right: 9, bottom: 2),
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedNodeColor),
                        child: TextButton(
                          onPressed: () {
                            logs.add("value");
                            showApp = !showApp;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.visibility,
                            color: nodeBarColor,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, left: 9, right: 9, bottom: 2),
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedNodeColor),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Console(
                                    logs: logs,
                                    onDelete: () {
                                      Future.delayed(Duration.zero, () {
                                        logs = [];

                                        setState(() {});
                                      });
                                    });
                              },
                            );
                          },
                          child: Icon(
                            Icons.logo_dev,
                            color: nodeBarColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: showApp,
                      child: Visibility(visible: !isRunning, child: appPley())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appPley() {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Container(
          height: privewSize.height,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: backGroundColor,
              border: Border.all(color: selectedNodeColor, width: 2)),
          width: privewSize.width,
          child: Stack(
            children: [
              userScreens.length > 0
                  ? widgetSelector(userScreens[screenIndex].child)
                  : Center(
                      child: Text(
                        log,
                        style: TextStyle(color: selectedNodeColor),
                      ),
                    ),
            ],
          )),
    );
  }

  Widget widgets() {
    return Container(
      width: 200,
      height: privewSize.height + 30,
      decoration: BoxDecoration(
          color: appBar ? nodeBarColor : Colors.transparent,
          border: Border(
              right: BorderSide(
                  color: appBar ? selectedNodeColor : Colors.transparent,
                  width: 2))),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 5, left: 9, right: 9),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: selectedNodeColor),
              child: TextButton(
                onPressed: () {
                  appBar = !appBar;
                  setState(() {});
                },
                child: Icon(
                  Icons.disabled_visible,
                  color: nodeBarColor,
                  size: 30,
                ),
              )),
          Visibility(
            visible: appBar,
            child: SizedBox(
              height: privewSize.height - 10,
              width: 200,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: IntrinsicHeight(
                  child: Wrap(
                    children: [
                      ///---------------[widgets]--------------
                      Column(
                        children: [
                          Text(
                            " Widgets",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: selectedNodeColor,
                                fontFamily: 'Inter'),
                          ),
                          Wrap(
                            children: [
                              NodeSelectorBox(
                                name: "Screen",
                                onAdd: (eg) {
                                  userScreens.add(
                                      Screen(id: Uuid().v1(), child: Node()));
                                  nodes.add(node("Screen", userScreens.length,
                                      eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Scaffold",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Scaffold", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "AppBar",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "AppBar", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Text",
                                onAdd: (eg) {
                                  nodes.add(
                                      node("Text", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Container",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Container", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Row",
                                onAdd: (eg) {
                                  nodes.add(
                                      node("Row", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Column",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Column", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Stack",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Stack", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Center",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Center", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Icon",
                                onAdd: (eg) {
                                  nodes.add(
                                      node("Icon", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Button",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Button", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "GestureDetector",
                                onAdd: (eg) {
                                  nodes.add(node("GestureDetector", -1, eg,
                                      userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Image",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Image", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "SizedBox",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "SizedBox", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      ///---------------------------[Functions]-----------------------
                      Column(
                        children: [
                          Text(
                            " Functions",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: selectedNodeColor,
                                fontFamily: 'Inter'),
                          ),
                          Wrap(
                            children: [
                              NodeSelectorBox(
                                name: "Add",
                                onAdd: (eg) {
                                  nodes.add(
                                      node("Add", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Subtract",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Subtract", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Dividing",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Dividing", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Multiply",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Multiply", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Nav",
                                onAdd: (eg) {
                                  nodes.add(
                                      node("Nav", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "SetVar",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "SetVar", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Print",
                                onAdd: (eg) {
                                  nodes.add(node(
                                      "Print", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "If",
                                onAdd: (eg) {
                                  nodes.add(
                                      node("If", -1, eg, userScreens.length));
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Run",
                                onAdd: (eg) {
                                  if (isRunningWidgetCreated == false) {
                                    nodes.add(node(
                                        "Run", -1, eg, userScreens.length));
                                    isRunningWidgetCreated = true;
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// ----------------------------[Vars]-------------------
                      Column(
                        children: [
                          Text(
                            " Vars",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: selectedNodeColor,
                                fontFamily: 'Inter'),
                          ),
                          Wrap(
                            children: [
                              NodeSelectorBox(
                                name: "String",
                                onAdd: (eg) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ScreenPicker(
                                          screens: userScreens,
                                          onPick: (e) {
                                            userScreens[userScreens.indexOf(e)]
                                                .vars
                                                .add(ScreenVar(
                                                    varName: "myVar",
                                                    value: "String",
                                                    type: "String",
                                                    id: "one"));
                                            nodes.add(node(
                                                "string",
                                                userScreens[
                                                        userScreens.indexOf(e)]
                                                    .vars
                                                    .length,
                                                eg,
                                                userScreens.length));
                                            setState(() {});
                                          });
                                    },
                                  );
                                  setState(() {});
                                },
                              ),
                              NodeSelectorBox(
                                name: "Num",
                                onAdd: (eg) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ScreenPicker(
                                          screens: userScreens,
                                          onPick: (e) {
                                            userScreens[userScreens.indexOf(e)]
                                                .vars
                                                .add(ScreenVar(
                                                    varName: "myVar",
                                                    value: 0,
                                                    type: "double",
                                                    id: "one"));
                                            nodes.add(node(
                                                "Num",
                                                userScreens[
                                                        userScreens.indexOf(e)]
                                                    .vars
                                                    .length,
                                                eg,
                                                userScreens.length));
                                            setState(() {});
                                          });
                                    },
                                  );
                                },
                              ),
                              NodeSelectorBox(
                                name: "IconData",
                                onAdd: (eg) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ScreenPicker(
                                          screens: userScreens,
                                          onPick: (e) {
                                            userScreens[userScreens.indexOf(e)]
                                                .vars
                                                .add(ScreenVar(
                                                    varName: "myVar",
                                                    value: Icons.abc,
                                                    type: "IconData",
                                                    id: "one"));
                                            nodes.add(node(
                                                "IconData",
                                                userScreens[
                                                        userScreens.indexOf(e)]
                                                    .vars
                                                    .length,
                                                eg,
                                                userScreens.length));
                                            setState(() {});
                                          });
                                    },
                                  );
                                },
                              ),
                              NodeSelectorBox(
                                  name: "Color",
                                  onAdd: (eg) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ScreenPicker(
                                            screens: userScreens,
                                            onPick: (e) {
                                              userScreens[
                                                      userScreens.indexOf(e)]
                                                  .vars
                                                  .add(ScreenVar(
                                                      varName: "myVar",
                                                      value: Colors.blue,
                                                      type: "Color",
                                                      id: "one"));
                                              nodes.add(node(
                                                  "color",
                                                  userScreens[userScreens
                                                          .indexOf(e)]
                                                      .vars
                                                      .length,
                                                  eg,
                                                  userScreens.length));
                                              setState(() {});
                                            });
                                      },
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetSelector(Node node) {
    if (node.title == "Text") {
      return Text(
        node.inputs[0]["isConected"]
            ? node.inputs[0]["fromVar"]
                ? userScreens[screenIndex]
                    .vars[node.inputs[0]["varId"]]
                    .value
                    .toString()
                : node.inputs[0]["value"].outputs[1]["value"].toString()
            : node.inputs[0]["value"],
        style: TextStyle(
          fontWeight: node.inputs[3]["isConected"]
              ? node.inputs[3]["fromVar"]
                  ? userScreens[screenIndex].vars[node.inputs[3]["varId"]].value
                  : node.inputs[3]["value"]
              : node.inputs[3]["value"],
          color: node.inputs[1]["isConected"]
              ? node.inputs[1]["fromVar"]
                  ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
                  : node.inputs[1]["value"]
              : node.inputs[1]["value"],
          fontSize: node.inputs[2]["isConected"]
              ? node.inputs[2]["fromVar"]
                  ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
                  : node.inputs[2]["value"]
              : node.inputs[2]["value"],
        ),
      );
    } else if (node.title == "Scaffold") {
      return SizedBox(
        height: privewSize.height - 25,
        width: privewSize.width - 25,
        child: Scaffold(
            backgroundColor: node.inputs[1]["isConected"]
                ? node.inputs[1]["fromVar"]
                    ? userScreens[screenIndex]
                        .vars[node.inputs[1]["varId"]]
                        .value
                    : node.inputs[1]["value"]
                : node.inputs[1]["value"],
            drawer: node.inputs[4]["isConected"]
                ? widgetSelector(node.inputs[4]["value"])
                : null,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(node.inputs[3]["isConected"]
                    ? node.inputs[3]["fromVar"]
                        ? userScreens[screenIndex]
                            .vars[node.inputs[3]["varId"]]
                            .value
                        : node.inputs[3]["value"]
                    : node.inputs[3]["value"]),
                child: node.inputs[2]["isConected"]
                    ? widgetSelector(node.inputs[2]["value"])
                    : SizedBox()),
            body: node.inputs[0]["isConected"]
                ? widgetSelector(node.inputs[0]["value"])
                : null),
      );
    } else if (node.title == "AppBar") {
      return AppBar(
        flexibleSpace: node.inputs[2]["isConected"]
            ? node.inputs[2]["fromVar"]
                ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
                : node.inputs[2]["value"] != null
                    ? widgetSelector(node.inputs[2]["value"])
                    : null
            : node.inputs[2]["value"] != null
                ? widgetSelector(node.inputs[2]["value"])
                : null,
        title: node.inputs[0]["isConected"]
            ? node.inputs[0]["fromVar"]
                ? userScreens[screenIndex].vars[node.inputs[0]["varId"]].value
                : node.inputs[0]["value"] != null
                    ? widgetSelector(node.inputs[0]["value"])
                    : null
            : node.inputs[0]["value"] != null
                ? widgetSelector(node.inputs[0]["value"])
                : null,
        backgroundColor: node.inputs[1]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
            : node.inputs[1]["value"],
        shadowColor: node.inputs[3]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[3]["varId"]].value
            : node.inputs[3]["value"],
      );
    } else if (node.title == "Container") {
      return Container(
        height: node.inputs[0]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[0]["varId"]].value
            : node.inputs[0]["max"]
                ? privewSize.height
                : node.inputs[0]["value"],
        width: node.inputs[1]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
            : node.inputs[1]["max"]
                ? privewSize.width
                : node.inputs[1]["value"],
        color: node.inputs[2]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
            : node.inputs[2]["value"],
        child: node.inputs[3]["isConected"]
            ? node.inputs[3]["fromVar"]
                ? userScreens[screenIndex].vars[node.inputs[3]["varId"]].value
                : node.inputs[3]["value"] != null
                    ? widgetSelector(node.inputs[3]["value"])
                    : null
            : node.inputs[3]["value"] != null
                ? widgetSelector(node.inputs[3]["value"])
                : null,
      );
    } else if (node.title == "Button") {
      return ElevatedButton(
          onPressed: node.inputs[5]["value"].length > 0
              ? () {
                  node.inputs[5]["value"].forEach((Node nde) {
                    event(nde);
                  });
                }
              : () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: node.inputs[0]["isConected"]
                  ? userScreens[screenIndex].vars[node.inputs[0]["varId"]].value
                  : node.inputs[0]["value"],
              foregroundColor: node.inputs[1]["isConected"]
                  ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
                  : node.inputs[1]["value"],
              shadowColor: node.inputs[2]["isConected"]
                  ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
                  : node.inputs[2]["value"],
              elevation: node.inputs[3]["isConected"]
                  ? userScreens[screenIndex].vars[node.inputs[3]["varId"]].value
                  : node.inputs[3]["value"]),
          child: node.inputs[4]["isConected"]
              ? node.inputs[4]["fromVar"]
                  ? userScreens[screenIndex].vars[node.inputs[4]["varId"]].value
                  : node.inputs[4]["value"] != null
                      ? widgetSelector(node.inputs[4]["value"])
                      : SizedBox()
              : node.inputs[4]["value"] != null
                  ? widgetSelector(node.inputs[4]["value"])
                  : SizedBox());
    } else if (node.title == "Row") {
      List<Widget> children = node.inputs[0]["value"].isNotEmpty
          ? node.inputs[0]["value"]
              .map<Widget>((e) => widgetSelector(e))
              .toList()
          : [];
      return Row(
        mainAxisAlignment: node.inputs[1]["value"] != null
            ? node.inputs[1]["value"]
            : MainAxisAlignment.start,
        crossAxisAlignment: node.inputs[2]["value"] != null
            ? node.inputs[2]["value"]
            : CrossAxisAlignment.start,
        children: children,
      );
    } else if (node.title == "Column") {
      List<Widget> children = node.inputs[0]["value"].isNotEmpty
          ? node.inputs[0]["value"]
              .map<Widget>((e) => widgetSelector(e))
              .toList()
          : [];
      return Column(
        mainAxisAlignment: node.inputs[1]["value"] != null
            ? node.inputs[1]["value"]
            : MainAxisAlignment.start,
        crossAxisAlignment: node.inputs[2]["value"] != null
            ? node.inputs[2]["value"]
            : CrossAxisAlignment.start,
        children: children,
      );
    } else if (node.title == "Stack") {
      List<Widget> children = node.inputs[0]["value"].isNotEmpty
          ? node.inputs[0]["value"]
              .map<Widget>((e) => widgetSelector(e))
              .toList()
          : [];
      return Stack(
        alignment: node.inputs[1]["value"] != null
            ? node.inputs[1]["value"]
            : AlignmentDirectional.topStart,
        children: children,
      );
    } else if (node.title == "GestureDetector") {
      return GestureDetector(
        child: node.inputs[0]["isConected"]
            ? node.inputs[0]["value"] != null
                ? widgetSelector(node.inputs[0]["value"])
                : null
            : null,
        onTap: node.inputs[1]["value"].length > 0
            ? () {
                node.inputs[1]["value"].forEach((Node nde) {
                  event(nde);
                });
              }
            : () {},
        onDoubleTap: node.inputs[2]["value"].length > 0
            ? () {
                node.inputs[2]["value"].forEach((Node nde) {
                  event(nde);
                });
              }
            : () {},
        onLongPress: node.inputs[3]["value"].length > 0
            ? () {
                node.inputs[3]["value"].forEach((Node nde) {
                  event(nde);
                });
              }
            : () {},
      );
    } else if (node.title == "Center") {
      return Center(
          child: node.inputs[0]["isConected"]
              ? widgetSelector(node.inputs[0]["value"])
              : null);
    } else if (node.title == "Icon") {
      return Icon(
        node.inputs[0]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[0]["varId"]].value
            : node.inputs[0]["value"],
        size: node.inputs[1]["max"]
            ? privewSize.width
            : node.inputs[1]["isConected"]
                ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
                : node.inputs[1]["value"],
        color: node.inputs[2]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
            : node.inputs[2]["value"],
      );
    } else if (node.title == "Image") {
      return Image.network(
        node.inputs[0]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[0]["varId"]].value
            : node.inputs[0]["value"],
        fit: node.inputs[3]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[3]["varId"]].value
            : node.inputs[3]["value"],
        height: node.inputs[1]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
            : node.inputs[1]["max"]
                ? privewSize.height
                : node.inputs[1]["value"],
        width: node.inputs[2]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
            : node.inputs[2]["max"]
                ? privewSize.width
                : node.inputs[2]["value"],
      );
    } else if (node.title == "SizedBox") {
      return SizedBox(
        height: node.inputs[0]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[0]["varId"]].value
            : node.inputs[0]["max"]
                ? privewSize.height
                : node.inputs[0]["value"],
        width: node.inputs[1]["isConected"]
            ? userScreens[screenIndex].vars[node.inputs[1]["varId"]].value
            : node.inputs[1]["max"]
                ? privewSize.width
                : node.inputs[1]["value"],
        child: node.inputs[2]["isConected"]
            ? node.inputs[2]["fromVar"]
                ? userScreens[screenIndex].vars[node.inputs[2]["varId"]].value
                : node.inputs[2]["value"] != null
                    ? widgetSelector(node.inputs[2]["value"])
                    : null
            : node.inputs[2]["value"] != null
                ? widgetSelector(node.inputs[2]["value"])
                : null,
      );
    } else {
      return SizedBox();
    }
  }

  void event(Node nde) {
    if (nde.title == "SetVar") {
      if (nde.inputs[1]["fromVar"]) {
        userScreens[screenIndex].vars[nde.inputs[0]["value"]].value =
            userScreens[screenIndex].vars[nde.inputs[1]["value"]].value;
      } else {
        userScreens[screenIndex].vars[nde.inputs[0]["value"]].value =
            nde.inputs[1]["value"];
      }
    } else if (nde.type == "Math") {
      double num1 = nde.inputs[0]["isConected"]
          ? userScreens[screenIndex].vars[nde.inputs[0]["varId"]].value
          : nde.inputs[0]["value"];

      double num2 = nde.inputs[1]["isConected"]
          ? userScreens[screenIndex].vars[nde.inputs[1]["varId"]].value
          : nde.inputs[1]["value"];
      if (nde.title == "Add") {
        userScreens[screenIndex].vars[nde.inputs[2]["value"]].value =
            num1 + num2;
      } else if (nde.title == "Subtract") {
        userScreens[screenIndex].vars[nde.inputs[2]["value"]].value =
            num1 + num2;
      } else if (nde.title == "Multiply") {
        userScreens[screenIndex].vars[nde.inputs[2]["value"]].value =
            num1 + num2;
      } else if (nde.title == "Dividing") {
        userScreens[screenIndex].vars[nde.inputs[2]["value"]].value =
            num1 + num2;
      }
    } else if (nde.title == "Nav") {
      selectedScreenNode = nde.inputs[0]["value"].classId - 1;
      screenIndex = nde.inputs[0]["value"].classId - 1;
      appe = nde.inputs[0]["value"].inputs[1]["child"] ?? Node();
      userScreens[screenIndex].child = appe;
    } else if (nde.title == "If") {
      dynamic num1 = nde.inputs[0]["isConected"]
          ? userScreens[screenIndex].vars[nde.inputs[0]["varId"]].value
          : nde.inputs[0]["value"];

      dynamic num2 = nde.inputs[2]["isConected"]
          ? userScreens[screenIndex].vars[nde.inputs[2]["varId"]].value
          : nde.inputs[2]["value"];
      if (nde.inputs[1]["value"] == "==") {
        if (num1 == num2) {
          nde.inputs[3]["value"] != null
              ? nde.inputs[3]["value"].forEach((element) {
                  event(element);
                })
              : null;
        } else {
          nde.inputs[4]["value"] != null
              ? nde.inputs[4]["value"].forEach((element) {
                  event(element);
                })
              : null;
        }
      } else if (nde.inputs[1]["value"] == ">") {
        if (num1 > num2) {
          nde.inputs[3]["value"] != null
              ? nde.inputs[3]["value"].forEach((element) {
                  event(element);
                })
              : null;
        } else {
          nde.inputs[4]["value"] != null
              ? nde.inputs[4]["value"].forEach((element) {
                  event(element);
                })
              : null;
        }
      } else if (nde.inputs[1]["value"] == "<") {
        if (num1 < num2) {
          nde.inputs[3]["value"] != null
              ? nde.inputs[3]["value"].forEach((element) {
                  event(element);
                })
              : null;
        } else {
          nde.inputs[4]["value"] != null
              ? nde.inputs[4]["value"].forEach((element) {
                  event(element);
                })
              : null;
        }
      } else if (nde.inputs[1]["value"] == "!=") {
        if (num1 != num2) {
          nde.inputs[3]["value"] != null
              ? nde.inputs[3]["value"].forEach((element) {
                  event(element);
                })
              : null;
        } else {
          nde.inputs[4]["value"] != null
              ? nde.inputs[4]["value"].forEach((element) {
                  event(element);
                })
              : null;
        }
      } else if (nde.inputs[1]["value"] == ">=") {
        if (num1 >= num2) {
          nde.inputs[3]["value"] != null
              ? nde.inputs[3]["value"].forEach((element) {
                  event(element);
                })
              : null;
        } else {
          nde.inputs[4]["value"] != null
              ? nde.inputs[4]["value"].forEach((element) {
                  event(element);
                })
              : null;
        }
      } else if (nde.inputs[1]["value"] == "<=") {
        if (num1 <= num2) {
          nde.inputs[3]["value"] != null
              ? nde.inputs[3]["value"].forEach((element) {
                  event(element);
                })
              : null;
        } else {
          nde.inputs[4]["value"] != null
              ? nde.inputs[4]["value"].forEach((element) {
                  event(element);
                })
              : null;
        }
      }
    } else if (nde.title == "Print") {
      logs.add(nde.inputs[0]["fromVar"]
          ? userScreens[screenIndex].vars[nde.inputs[0]["varId"]].value
          : nde.inputs[0]["value"]);
    }

    userScreens[screenIndex].child = appe;
    setState(() {});
  }
}

class Screen {
  Screen(
      {this.id = "",
      this.name = "MyClass",
      this.type = "StatefulWidget",
      required this.child});
  String id = "";
  String name = "MyClass";
  String type = "StatefulWidget";
  List<ScreenVar> vars = [];
  Node child = Node();
}

class ScreenVar {
  ScreenVar({this.value, this.varName = "", this.id = "", this.type = ""});
  String id;
  String varName = "";
  String type;
  dynamic value;
}
