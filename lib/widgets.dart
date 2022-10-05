// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:example/colors.dart';
import 'package:example/node.dart';
import 'package:example/work_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';

import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:smart_dropdown/smart_dropdown.dart';

class TextFiledForWork extends StatelessWidget {
  TextFiledForWork(
      {required this.onChanged,
      required this.onIcon,
      this.value = "",
      this.type = "String",
      this.maxLength = 10,
      this.haveIcon = false,
      this.name = ""});
  Function(String) onChanged;
  Function() onIcon;
  String value;
  String type;
  String name;

  int maxLength;
  bool haveIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        style: TextStyle(
            fontSize: 12, color: nodeTextColorTwo, fontFamily: 'Inter'),
        decoration: InputDecoration(
          prefixIcon: haveIcon
              ? IconButton(
                  onPressed: () {
                    onIcon();
                  },
                  icon: FittedBox(child: Icon(Icons.fullscreen)))
              : null,
          helperStyle: TextStyle(color: nodeTextColorTwo),
          labelText: name,
          labelStyle: TextStyle(
            color: selectedNodeColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: selectedNodeColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: selectedNodeColor),
          ),
        ),
        inputFormatters:
            type == "Num" ? [FilteringTextInputFormatter.digitsOnly] : [],
        keyboardType: TextInputType.number,
        initialValue: value,
        onChanged: (eg) {
          onChanged(eg);
        },
      ),
    );
  }
}

class IconPick extends StatelessWidget {
  IconPick({this.value = Icons.abc, required this.newIcon});
  IconData value;
  Function(IconData icon) newIcon;

  @override
  Widget build(BuildContext context) {
    _pickIcon() async {
      IconData? icon = await FlutterIconPicker.showIconPicker(
        context,
        iconPackModes: [
          IconPack.cupertino,
          IconPack.fontAwesomeIcons,
          IconPack.lineAwesomeIcons,
          IconPack.material
        ],
        adaptiveDialog: true,
        backgroundColor: backGroundColor,
        iconColor: Colors.white,
      );

      newIcon(icon!);
    }

    return SizedBox(
      height: 40,
      width: 200,
      child: Button(
          text: "Pick Icon",
          onClick: () {
            _pickIcon();
          }),
    );
  }
}

Widget nodeIconSeter(String type, Color color, double size) {
  if (type == "Screen") {
    return Icon(
      Icons.screenshot,
      color: color,
      size: size,
    );
  } else if (type == "StatelessWidget") {
    return Icon(
      Icons.hearing_disabled_rounded,
      color: color,
      size: size,
    );
  } else if (type == "Scaffold") {
    return Icon(
      Icons.web_asset,
      color: color,
      size: size,
    );
  } else if (type == "Run") {
    return Icon(
      Icons.play_circle_fill_outlined,
      color: color,
      size: size,
    );
  } else if (type == "Text") {
    return Icon(
      Icons.text_format,
      color: color,
      size: size,
    );
  } else if (type == "AppBar") {
    return Icon(
      Icons.power_input,
      color: color,
      size: size,
    );
  } else if (type == "var" ||
      type == "Num" ||
      type == "String" ||
      type == "Color" ||
      type == "IconData") {
    return Icon(
      Icons.folder,
      color: color,
      size: size,
    );
  } else if (type == "Container") {
    return Icon(
      Icons.crop_square,
      color: color,
      size: size,
    );
  } else if (type == "Row") {
    return Icon(
      Icons.view_week,
      color: color,
      size: size,
    );
  } else if (type == "Column") {
    return Icon(
      Icons.table_rows,
      color: color,
      size: size,
    );
  } else if (type == "Stack") {
    return Icon(
      Icons.view_quilt,
      color: color,
      size: size,
    );
  } else if (type == "Button") {
    return Icon(
      Icons.smart_button,
      color: color,
      size: size,
    );
  } else if (type == "Event") {
    return Icon(
      Icons.not_started,
      color: color,
      size: size,
    );
  } else if (type == "Add") {
    return Icon(
      Icons.add,
      color: color,
      size: size,
    );
  } else if (type == "Subtract") {
    return Icon(
      Icons.remove,
      color: color,
      size: size,
    );
  } else if (type == "Multiply") {
    return Icon(
      Icons.close,
      color: color,
      size: size,
    );
  } else if (type == "Dividing") {
    return Icon(
      Icons.calculate,
      color: color,
      size: size,
    );
  } else if (type == "SetVar") {
    return Icon(
      Icons.sync,
      color: color,
      size: size,
    );
  } else if (type == "Nav") {
    return Icon(
      Icons.move_up,
      color: color,
      size: size,
    );
  } else if (type == "Screen") {
    return Icon(
      Icons.screenshot,
      color: color,
      size: size,
    );
  } else if (type == "GestureDetector") {
    return Icon(
      Icons.touch_app,
      color: color,
      size: size,
    );
  } else if (type == "Center") {
    return Icon(
      Icons.filter_center_focus,
      color: color,
      size: size,
    );
  } else if (type == "Icon") {
    return Icon(
      Icons.insert_emoticon,
      color: color,
      size: size,
    );
  } else if (type == "If") {
    return Icon(
      Icons.unpublished,
      color: color,
      size: size,
    );
  } else if (type == "Image") {
    return Icon(
      Icons.image,
      color: color,
      size: size,
    );
  } else if (type == "SizedBox") {
    return Icon(
      Icons.crop,
      color: color,
      size: size,
    );
  } else if (type == "Print") {
    return Icon(
      Icons.print,
      color: color,
      size: size,
    );
  } else {
    return Icon(
      Icons.calculate,
      color: color,
      size: size,
    );
  }
}

class NodeSelectorBox extends StatelessWidget {
  NodeSelectorBox({this.name = "", required this.onAdd});
  String name;

  Function(Offset pos) onAdd;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Draggable(
        child: box(name),
        feedback: box(name),
        onDraggableCanceled: (e, eg) {
          if (eg.dx > 180) {
            onAdd(eg);
          }
        },
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  DropDown({this.items = const [], this.name = "", required this.onSelect});
  List<SmartDropdownMenuItem> items;
  String name;
  Function(dynamic itme) onSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartDropDown(
        items: items,
        hintText: name,
        borderRadius: 5,
        borderColor: nodeTextColorTwo,
        expandedColor: selectedNodeColor,
        onChanged: (val) {
          onSelect(val);
        },
      ),
    );
  }
}

Widget box(String text) {
  return Material(
    color: Colors.transparent,
    child: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          border: Border.all(color: selectedNodeColor),
          color: nodeTitleContaner,
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                child: Text(
                  text,
                  style: TextStyle(
                      color: nodeTextColorTwo,
                      fontFamily: 'Inter',
                      fontSize: 23),
                ),
              ),
              nodeIconSeter(text, nodeTextColorTwo, 40)
            ],
          ),
        ),
      ),
    ),
  );
}

class AddItmeToList extends StatelessWidget {
  AddItmeToList(
      {required this.varr,
      required this.onEdit,
      required this.value,
      required this.onDelete});
  Node varr;
  Function(dynamic) onEdit;
  Function() onDelete;
  dynamic value;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 300,
      decoration: BoxDecoration(
          color: backGroundColor,
          border: Border.all(width: 1, color: selectedNodeColor),
          borderRadius: BorderRadius.circular(5)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        varr.title == "List(String)"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FittedBox(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                          color: selectedNodeColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFiledForWork(
                      value: value,
                      name: "itme",
                      onChanged: (e) {
                        onEdit(e);
                      },
                      onIcon: () {}),
                ],
              )
            : varr.title == "List(Color)"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: value),
                      ),
                      Button(
                          onClick: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ColorPick(
                                      pikcerColor: value,
                                      colore: (e) {
                                        onEdit(e);
                                      });
                                });
                          },
                          text: "Pick Color"),
                    ],
                  )
                : varr.title == "List(Num)"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FittedBox(
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                  color: selectedNodeColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextFiledForWork(
                              value: value,
                              name: "Num",
                              onChanged: (e) {
                                onEdit(e);
                              },
                              onIcon: () {}),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FittedBox(
                              child: Icon(
                            value,
                            color: selectedNodeColor,
                          )),
                          IconPick(
                              value: value,
                              newIcon: (e) {
                                onEdit(e);
                              }),
                        ],
                      ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  onDelete();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        )
      ]),
    );
  }
}

class ScreenPicker extends StatelessWidget {
  ScreenPicker({this.screens = const [], required this.onPick});
  List<Screen> screens;
  Function(Screen screen) onPick;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        width: 300,
        decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selectedNodeColor, width: 2)),
        child: Column(
          children: [
            Center(
              child: Text("Screens",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      color: nodeTextColorTwo,
                      fontSize: 20)),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                    children: screens
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              onPick(e);
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 30,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: backGroundColor,
                                  border: Border.all(
                                      color: selectedNodeColor, width: 2),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Text(e.name,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: selectedNodeColor,
                                        fontSize: 20)),
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class VarPicker extends StatelessWidget {
  VarPicker({this.vars = const [], required this.onPick});
  List<ScreenVar> vars;
  Function(ScreenVar screen) onPick;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 350,
      child: Column(
        children: [
          Center(
            child: Text("Screen vars",
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: nodeTextColorTwo,
                    fontSize: 20)),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            width: 270,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                  children: vars
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            onPick(e);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 30,
                            width: 300,
                            decoration: BoxDecoration(
                                color: backGroundColor,
                                border: Border.all(
                                    color: selectedNodeColor, width: 2),
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        e.value.runtimeType == "MaterialColor"
                                            ? "color"
                                            : e.value.runtimeType.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: nodeTextColorTwo,
                                            fontSize: 20)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(e.varName,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: selectedNodeColor,
                                            fontSize: 20)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("=",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: selectedNodeColor,
                                            fontSize: 20)),
                                    Text(e.value.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: nodeTextColorTwo,
                                            fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class ColorPick extends StatelessWidget {
  ColorPick({this.pikcerColor = Colors.red, required this.colore});
  Function(Color color) colore;
  Color pikcerColor;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backGroundColor,
      child: SizedBox(
        width: 240,
        height: 360,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ColorPicker(
                pickerAreaHeightPercent: 0.7,
                enableAlpha: true,
                displayThumbColor: true,
                paletteType: PaletteType.hsvWithHue,
                pickerAreaBorderRadius: BorderRadius.circular(5),
                portraitOnly: true,
                colorPickerWidth: 200,
                hexInputBar: true,
                pickerColor: pikcerColor,
                onColorChanged: (color) {
                  colore(color);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  Button({
    required this.onClick,
    this.textColor = const Color.fromARGB(255, 30, 30, 30),
    this.buttonColor = const Color.fromARGB(255, 175, 251, 88),
    this.text = "",
  });
  Function onClick;
  Color textColor;
  Color buttonColor;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          onPressed: () {
            onClick();
          },
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ));
  }
}
