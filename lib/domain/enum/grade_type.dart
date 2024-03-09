// ignore_for_file: constant_identifier_names

enum GradeType {
  SSSp("sss_p.png"),
  SSS("sss.png"),
  SSp("ss_p.png"),
  SS("ss.png"),
  Sp("s_p.png"),
  S("s.png"),
  AAAp("aaa_p.png"),
  AAA("aaa.png"),
  AAp("aa_p.png"),
  AA("aa.png"),
  Ap("a_p.png"),
  A("a.png"),
  B("b.png"),
  C("c.png");

  final String fileName;
  const GradeType(this.fileName);

  static GradeType fromString(String text) {
    for (GradeType entry in GradeType.values) {
      if (text.contains(entry.fileName)) {
        return entry;
      }
    }
    return GradeType.values.last;
  }
}
