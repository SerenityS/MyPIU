// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

enum ChartType {
  @JsonValue("SINGLE")
  SINGLE("s_text.png"),
  @JsonValue("DOUBLE")
  DOUBLE("d_text.png"),
  @JsonValue("CO-OP")
  COOP("c_text.png");

  final String fileName;
  const ChartType(this.fileName);

  static ChartType fromString(String text) {
    for (ChartType entry in ChartType.values) {
      if (text.contains(entry.fileName)) {
        return entry;
      }
    }

    return ChartType.values.last;
  }
}
