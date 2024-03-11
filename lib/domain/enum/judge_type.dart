// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum JudgeType {
  Perfect(Color(0xFF005AFF)),
  Great(Color(0xFF32CD32)),
  Good(Color(0xFFFBFF07)),
  Bad(Color(0xFFCC00FF)),
  Miss(Color(0xFFF00000));

  const JudgeType(this.color);

  final Color color;
}
