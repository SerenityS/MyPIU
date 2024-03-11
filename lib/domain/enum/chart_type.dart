// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

enum ChartType {
  @JsonValue("SINGLE")
  SINGLE("s", "s_bg.png", "s_text.png"),
  @JsonValue("SINGLE PERFORMANCE")
  SINGLE_PERFORMANCE("sp", "sp_bg.png", "sp_text.png"),
  @JsonValue("DOUBLE")
  DOUBLE("d", "d_bg.png", "d_text.png"),
  @JsonValue("DOUBLE PERFORMANCE")
  DOUBLE_PERFORMANCE("dp", "dp_bg.png", "dp_text.png"),
  @JsonValue("CO-OP")
  COOP("c", "c_bg.png", "c_text.png"),
  @JsonValue("UCS")
  UCS("u", "u_bg.png", "u_text.png");

  final String name;
  final String bgFileName;
  final String textFileName;
  const ChartType(this.name, this.bgFileName, this.textFileName);

  static ChartType fromString(String text) {
    for (ChartType entry in ChartType.values) {
      if (text.contains(entry.textFileName)) {
        return entry;
      }
    }

    return ChartType.values.last;
  }
}
