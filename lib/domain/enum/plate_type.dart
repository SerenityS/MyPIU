// ignore_for_file: constant_identifier_names

enum PlateType {
  PG("pg.png"),
  UG("ug.png"),
  EG("eg.png"),
  SG("sg.png"),
  MG("mg.png"),
  TG("tg.png"),
  FG("fg.png"),
  RG("rg.png");

  final String fileName;
  const PlateType(this.fileName);

  static PlateType fromString(String text) {
    for (PlateType entry in PlateType.values) {
      if (text.contains(entry.fileName)) {
        return entry;
      }
    }
    return PlateType.values.last;
  }
}
