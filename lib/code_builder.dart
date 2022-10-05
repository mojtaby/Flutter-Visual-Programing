// ignore_for_file: unnecessary_statements

import 'package:example/node.dart';
import 'package:example/work_page.dart';
import 'package:flutter/cupertino.dart';

class CodeBuilder {
  CodeBuilder({this.screens = const []});
  List<Screen> screens;

  dynamic classBuilder(
    Screen screen,
  ) {
    if (screen.type == "StatefulWidget") {
      return '''
${screens.map((e) => '''
#de
class ${e.name} extends StatefulWidget {
  const ${e.name}({super.key});

  @override
  State<${e.name}> createState() => _${e.name}State();
}

class _${e.name}State extends State<${e.name}> {
  @override
  Widget build(BuildContext context) {
    return ${e.child != null ? widgetBuilder(e, e.child) : ' Container();'}
  }
  ${e.vars.isNotEmpty ? e.vars.map((varre) => '''

${varBuilder(varre)}''').toString().replaceAll("(", "").replaceAll(")", "") : ''}
}#de''')}''';
    } else {
      return "";
    }
  }

  String varBuilder(ScreenVar varr) {
    return '${varr.type} ${varr.varName}= ${varr.type == "String" ? '"${varr.value}"' : varr.value};';
  }

  String widgetBuilder(Screen screen, Node node) {
    if (node.title == "Scaffold") {
      return '''
Scaffold(
       backgroundColor: ${node.inputs[1]["isConected"] ? node.inputs[1]["fromVar"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["value"] : node.inputs[1]["value"]},
       drawer: ${node.inputs[3]["isConected"] ? widgetBuilder(screen, node.inputs[3]["value"]) : null},
       appBar: ${node.inputs[2]["isConected"] ? widgetBuilder(screen, node.inputs[2]["value"]) : null},        
       body: ${node.inputs[0]["isConected"] ? widgetBuilder(screen, node.inputs[0]["value"]) : null}),
    ''';
    } else if (node.title == "Text") {
      return '''Text(
      ${node.inputs[0]["isConected"] ? screen.vars[node.inputs[0]["varId"]].varName : '"${node.inputs[0]["value"]}"'},
        style: TextStyle(
           fontWeight: ${node.inputs[3]["isConected"] ? node.inputs[3]["fromVar"] ? screen.vars[node.inputs[3]["varId"]].varName : node.inputs[3]["value"] : node.inputs[3]["value"]},
          color:${node.inputs[1]["isConected"] ? node.inputs[1]["fromVar"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["value"] : node.inputs[1]["value"]},
          fontSize:   ${node.inputs[2]["isConected"] ? node.inputs[2]["fromVar"] ? screen.vars[node.inputs[2]["varId"]].varName : node.inputs[2]["value"] : node.inputs[2]["value"]},
        ),
      ),''';
    } else if (node.title == "AppBar") {
      return ''' PreferredSize(
          preferredSize: Size.fromHeight(
           ${node.inputs[2]["isConected"] ? screen.vars[node.inputs[2]["varId"]].varName : node.inputs[2]["max"] ? 'MediaQuery.of(context).size.height' : node.inputs[2]["value"]},
          ),
          child: AppBar(
            flexibleSpace: ${node.inputs[3]["isConected"] ? node.inputs[3]["fromVar"] ? screen.vars[node.inputs[3]["varId"]].varName : node.inputs[3]["value"] != null ? widgetBuilder(screen, node.inputs[3]["value"]) : null : node.inputs[3]["value"] != null ? widgetBuilder(screen, node.inputs[3]["value"]) : null},
            title: ${node.inputs[0]["isConected"] ? node.inputs[0]["fromVar"] ? screen.vars[node.inputs[0]["varId"]].varName : node.inputs[0]["value"] != null ? widgetBuilder(screen, node.inputs[0]["value"]) : null : node.inputs[0]["value"] != null ? widgetBuilder(screen, node.inputs[0]["value"]) : null},
            backgroundColor: ${node.inputs[1]["isConected"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["value"]},
          )),''';
    } else if (node.title == "Container") {
      return ''' Container(
        height: ${node.inputs[0]["isConected"] ? screen.vars[node.inputs[0]["varId"]].varName : node.inputs[0]["max"] ? 'MediaQuery.of(context).size.height' : node.inputs[0]["value"]},
        width:${node.inputs[1]["isConected"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["max"] ? 'MediaQuery.of(context).size.width' : node.inputs[1]["value"]},
        color: ${node.inputs[2]["isConected"] ? screen.vars[node.inputs[2]["varId"]].varName : node.inputs[2]["value"]},
        child:${node.inputs[3]["isConected"] ? node.inputs[3]["fromVar"] ? screen.vars[node.inputs[3]["varId"]].varName : node.inputs[3]["value"] != null ? widgetBuilder(screen, node.inputs[3]["value"]) : null : node.inputs[3]["value"] != null ? widgetBuilder(screen, node.inputs[3]["value"]) : null},
      ),''';
    } else if (node.title == "Button") {
      return '''ElevatedButton(
          onPressed: ${node.inputs[5]["value"].length > 0 ? '''() {
           ${node.inputs[5]["value"].map((Node nde) {
              return '''#de
            ${event(screen, nde)};
             #dee''';
            })}
            setState(() {});
            }''' : '() {}'},
          style: ElevatedButton.styleFrom(
              backgroundColor: ${node.inputs[0]["isConected"] ? screen.vars[node.inputs[0]["varId"]].value : node.inputs[0]["value"]},
              foregroundColor: ${node.inputs[1]["isConected"] ? screen.vars[node.inputs[1]["varId"]].value : node.inputs[1]["value"]},
              shadowColor: ${node.inputs[2]["isConected"] ? screen.vars[node.inputs[2]["varId"]].value : node.inputs[2]["value"]},
              elevation: ${node.inputs[3]["isConected"] ? screen.vars[node.inputs[3]["varId"]].value : node.inputs[3]["value"]},
          child: ${node.inputs[4]["isConected"] ? node.inputs[4]["fromVar"] ? screen.vars[node.inputs[4]["varId"]].value : node.inputs[4]["value"] != null ? widgetBuilder(screen, node.inputs[4]["value"]) : SizedBox() : node.inputs[4]["value"] != null ? widgetBuilder(screen, node.inputs[4]["value"]) : SizedBox()},
          ),''';
    } else if (node.title == "Row") {
      return '''Row(
        mainAxisAlignment: ${node.inputs[1]["value"] != null ? node.inputs[1]["value"] : ' MainAxisAlignment.start'},
        crossAxisAlignment: ${node.inputs[2]["value"] != null ? node.inputs[2]["value"] : 'CrossAxisAlignment.start'},
        children: ${node.inputs[0]["value"].isNotEmpty ? node.inputs[0]["value"].map((e) => widgetBuilder(screen, e)).toList() : '[]'},
      )''';
    } else if (node.title == "Column") {
      return '''Column(
        mainAxisAlignment: ${node.inputs[1]["value"] != null ? node.inputs[1]["value"] : ' MainAxisAlignment.start'},
        crossAxisAlignment: ${node.inputs[2]["value"] != null ? node.inputs[2]["value"] : 'CrossAxisAlignment.start'},
        children: ${node.inputs[0]["value"].isNotEmpty ? node.inputs[0]["value"].map((e) => widgetBuilder(screen, e)).toList() : '[]'},
      )''';
    } else if (node.title == "Stack") {
      return '''Stack(
       alignment: ${node.inputs[1]["value"] != null ? node.inputs[1]["value"] : 'AlignmentDirectional.topStart'},
        children: ${node.inputs[0]["value"].isNotEmpty ? node.inputs[0]["value"].map((e) => widgetBuilder(screen, e)).toList().toString().replaceAll(',,', ',') : '[]'},
      )''';
    } else if (node.title == "GestureDetector") {
      return ''' GestureDetector(
        child: ${node.inputs[0]["isConected"] ? node.inputs[0]["value"] != null ? widgetBuilder(screen, node.inputs[0]["value"]) : null : null},
        onTap: ${node.inputs[1]["value"].length > 0 ? '''() {
           ${node.inputs[1]["value"].map((Node nde) {
              return '''#de
            ${event(screen, nde)};
             #dee''';
            })}
            setState(() {});
            }''' : '() {}'},
        onDoubleTap: ${node.inputs[2]["value"].length > 0 ? '''() {
           ${node.inputs[1]["value"].map((Node nde) {
              return '''#de
            ${event(screen, node)}
             #de''';
            })}
           setState(() {});
        }''' : '() {}'},
        onLongPress:${node.inputs[3]["value"].length > 0 ? '''() {
           ${node.inputs[1]["value"].map((Node nde) {
              return '''#de
            ${event(screen, node)}
             #de''';
            })}
           setState(() {});
        }''' : '() {}'},
      )''';
    } else if (node.title == "Icon") {
      return '''Icon(
        ${node.inputs[0]["isConected"] ? screen.vars[node.inputs[0]["varId"]].varName : node.inputs[0]["value"]},
        size: ${node.inputs[1]["max"] ? 'MediaQuery.of(context).size.width' : node.inputs[1]["isConected"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["value"]},
        color:${node.inputs[2]["isConected"] ? screen.vars[node.inputs[2]["varId"]].varName : node.inputs[2]["value"]},
      ),''';
    } else if (node.title == "Center") {
      return '''Center(child:${node.inputs[0]["isConected"] ? widgetBuilder(screen, node.inputs[0]["value"]) : null}),''';
    } else if (node.title == "SizedBox") {
      return '''SizedBox(
        height: ${node.inputs[0]["isConected"] ? screen.vars[node.inputs[0]["varId"]].varName : node.inputs[0]["max"] ? 'MediaQuery.of(context).size.height' : node.inputs[0]["value"]},
        width: ${node.inputs[1]["isConected"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["max"] ? 'MediaQuery.of(context).size.width' : node.inputs[1]["value"]},
        child: ${node.inputs[2]["isConected"] ? widgetBuilder(screen, node.inputs[2]["value"]) : null},
      ),''';
    } else if (node.title == "Image") {
      return '''Image.network(
        "${node.inputs[0]["isConected"] ? screen.vars[node.inputs[0]["varId"]].value : node.inputs[0]["value"]}",
        fit: ${node.inputs[3]["isConected"] ? screen.vars[node.inputs[3]["varId"]].value : node.inputs[3]["value"]},
        height: ${node.inputs[1]["isConected"] ? screen.vars[node.inputs[1]["varId"]].varName : node.inputs[1]["max"] ? 'MediaQuery.of(context).size.height' : node.inputs[1]["value"]},
        width: ${node.inputs[2]["isConected"] ? screen.vars[node.inputs[2]["varId"]].varName : node.inputs[2]["max"] ? 'MediaQuery.of(context).size.width' : node.inputs[2]["value"]},
      ),''';
    } else {
      return '';
    }
  }

  String event(Screen screen, Node nde) {
    if (nde.title == "SetVar") {
      if (nde.inputs[1]["isConected"]) {
        return "${screen.vars[nde.inputs[0]["value"]].varName} = ${screen.vars[nde.inputs[1]["value"]].varName}";
      } else {
        return "${screen.vars[nde.inputs[0]["value"]].varName} = ${nde.inputs[1]["value"]} ";
      }
    } else if (nde.type == "Math") {
      double num1 = nde.inputs[0]["isConected"]
          ? screen.vars[nde.inputs[0]["varId"]].varName
          : nde.inputs[0]["value"];

      double num2 = nde.inputs[1]["isConected"]
          ? screen.vars[nde.inputs[1]["varId"]].varName
          : nde.inputs[1]["value"];

      if (nde.title == "Add") {
        return "${screen.vars[nde.inputs[2]["value"]].varName} = $num1 + $num2";
      } else if (nde.title == "Subtract") {
        return "${screen.vars[nde.inputs[2]["value"]].varName} = $num1 - $num2";
      } else if (nde.title == "Multiply") {
        return "${screen.vars[nde.inputs[2]["value"]].varName} = $num1 * $num2";
      } else if (nde.title == "Dividing") {
        return "${screen.vars[nde.inputs[2]["value"]].varName} = $num1 / $num2";
      } else {
        return "";
      }
    } else if (nde.title == "Nav") {
      return 'Navigator.push(context,MaterialPageRoute(builder: (context) => ${screens[nde.inputs[0]["value"].classId - 1].name}()))';
    } else if (nde.title == "If") {
      dynamic num1 = nde.inputs[0]["isConected"]
          ? screen.vars[nde.inputs[0]["varId"]].varName
          : nde.inputs[0]["value"];

      dynamic num2 = nde.inputs[2]["isConected"]
          ? screen.vars[nde.inputs[2]["varId"]].varName
          : nde.inputs[2]["value"];

      if (nde.inputs[1]["value"] == "==") {
        return '''if($num1 == $num2){
        
          ${nde.inputs[3]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
       }else {
            ${nde.inputs[4]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
        }''';
      } else if (nde.inputs[1]["value"] == ">") {
        return '''if($num1 > $num2){
        
          ${nde.inputs[3]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
       }else {
            ${nde.inputs[4]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
        }''';
      } else if (nde.inputs[1]["value"] == "<") {
        return '''if($num1 < $num2){
        
          ${nde.inputs[3]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
       }else {
            ${nde.inputs[4]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
        }''';
      } else if (nde.inputs[1]["value"] == "!=") {
        return '''if($num1 != $num2){
        
          ${nde.inputs[3]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
       }else {
            ${nde.inputs[4]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
        }''';
      } else if (nde.inputs[1]["value"] == ">=") {
        return '''if($num1 >= $num2){
        
          ${nde.inputs[3]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
       }else {
            ${nde.inputs[4]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
        }''';
      } else if (nde.inputs[1]["value"] == "<=") {
        return '''if($num1 <= $num2){
        
          ${nde.inputs[3]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
       }else {
            ${nde.inputs[4]["value"].map((element) {
          return '#g ${event(screen, element)};';
        })}
        }''';
      } else {
        return "";
      }
    } else if (nde.title == "Print") {
      return "print(${nde.inputs[0]["isConected"] ? screen.vars[nde.inputs[0]["varId"]].varName : "'${nde.inputs[0]["value"]}'"})";
    } else {
      return "";
    }
  }
}
