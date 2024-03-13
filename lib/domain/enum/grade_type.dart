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
  SSSp("sss_p.png", 1.5),
  SSS("sss.png", 1.44),
  SSp("ss_p.png", 1.38),
  SS("ss.png", 1.32),
  Sp("s_p.png", 1.26),
  S("s.png", 1.2),
  AAAp("aaa_p.png", 1.15),
  AAA("aaa.png", 1.1),
  AAp("aa_p.png", 1.05),
  AA("aa.png", 1.0),
  Ap("a_p.png", 0.9),
  A("a.png", 0.8),
  B("b.png", 0.7),
  C("c.png", 0.6),
  D("d.png", 0.5),
  F("f.png", 0.0);

  final String fileName;
  final double ratingPrefix;
  const GradeType(this.fileName, [this.ratingPrefix = 0.0]);

  static GradeType fromString(String text) {
    for (GradeType entry in GradeType.values) {
      if (text.contains(entry.fileName)) {
        return entry;
      }
    }
    return GradeType.values.last;
  }
}
