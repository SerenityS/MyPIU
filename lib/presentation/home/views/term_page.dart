import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:piu_util/domain/enum/term_type.dart';

class TermPage extends StatelessWidget {
  TermPage({super.key});

  final TermType termType = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(termType.title)),
      body: FutureBuilder(
        future: rootBundle.loadString("assets/term/${termType.fileName}.md"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data,
              padding: const EdgeInsets.all(20.0),
              physics: const ClampingScrollPhysics(),
              styleSheet: MarkdownStyleSheet(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
