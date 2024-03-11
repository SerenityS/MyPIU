// ignore_for_file: constant_identifier_names

enum GradeType {
  xSSSp("x_sss_p.png"),
  xSSS("x_sss.png"),
  xSSp("x_ss_p.png"),
  xSS("x_ss.png"),
  xSp("x_s_p.png"),
  xS("x_s.png"),
  xAAAp("x_aaa_p.png"),
  xAAA("x_aaa.png"),
  xAAp("x_aa_p.png"),
  xAA("x_aa.png"),
  xAp("x_a_p.png"),
  xA("x_a.png"),
  xB("x_b.png"),
  xC("x_c.png"),
  xD("x_d.png"),
  xF("x_f.png"),
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
  C("c.png"),
  D("d.png"),
  F("f.png");

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
