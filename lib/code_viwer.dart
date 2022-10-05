import 'package:download/download.dart';
import 'package:example/code_builder.dart';
import 'package:example/colors.dart';
import 'package:example/work_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeViwer extends StatefulWidget {
  CodeViwer({this.userScreen = const []});
  List<Screen> userScreen;
  @override
  State<CodeViwer> createState() => _CodeViwerState();
}

class _CodeViwerState extends State<CodeViwer> {
  @override
  Widget build(BuildContext context) {
    CodeBuilder codeBuiler = CodeBuilder(screens: widget.userScreen);
    String code = codeBuiler
        .classBuilder(widget.userScreen[0])
        .replaceAll("(#de", "")
        .replaceAll(")#de", "")
        .replaceAll("#de, #de", "")
        .replaceAll("}#de)", "}")
        .replaceAll(";#de,", "")
        .replaceAll(";,", ";")
        .replaceAll("#dee)", "")
        .replaceAll("(#dee", "")
        .replaceAll("#dee,", "")
        .replaceAll("#de)", "}")
        .replaceAll("(#g", "")
        .replaceAll("; #g", ";")
        .replaceAll(";)", ";")
        .replaceAll("}#de)", "}");
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 500,
        width: 500,
        decoration: BoxDecoration(
            color: backGroundColor,
            border: Border.all(color: selectedNodeColor, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            SyntaxView(
                code: code,
                syntax: Syntax.DART,
                syntaxTheme: SyntaxTheme.vscodeDark(),
                fontSize: 12.0,
                withZoom: true,
                withLinesCount: true,
                expanded: true),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                  onPressed: () {
                    final stream = Stream.fromIterable(code.codeUnits);
                    download(stream, 'myApp.dart');
                  },
                  icon: Icon(
                    Icons.download,
                    color: selectedNodeColor,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
