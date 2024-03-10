// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TitleType {
  Platinum('col1', Color(0xFF336699), Color(0xFF99CCCC)),
  Gold('col2', Color(0xFFFFD700), Color(0xFF996633)),
  Silver('col3', Color(0xFFD9D8D8), Color(0xFF666666)),
  Bronze('col4', Color(0xFF663333), Color(0xFFCC9966)),
  Beginner('col5', Color(0xFF336666), Color(0xFF009966)),
  Special('col6', Color(0xFF222933), Color(0xFF222933));

  const TitleType(this.cssStyle, this.startColor, this.endColor);
  final String cssStyle;
  final Color startColor;
  final Color endColor;

  static TitleType fromString(String text) {
    return TitleType.values.firstWhere((e) => text.contains(e.cssStyle));
  }
}
