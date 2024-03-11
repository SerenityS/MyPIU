// ignore_for_file: constant_identifier_names

enum PlateType {
  PG("pg.png", "s_pg.png"),
  UG("ug.png", "s_ug.png"),
  EG("eg.png", "s_eg.png"),
  SG("sg.png", "s_sg.png"),
  MG("mg.png", "s_mg.png"),
  TG("tg.png", "s_tg.png"),
  FG("fg.png", "s_fg.png"),
  RG("rg.png", "s_rg.png");

  final String fileName;
  final String smallFileName;
  const PlateType(this.fileName, this.smallFileName);

  static PlateType fromString(String text) {
    for (PlateType entry in PlateType.values) {
      if (text.contains(entry.fileName)) {
        return entry;
      }
    }
    return PlateType.values.last;
  }
}
