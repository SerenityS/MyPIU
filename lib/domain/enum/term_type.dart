enum TermType {
  privacyPolicy("개인정보 처리방침", "privacy_policy"),
  termOfUse("서비스 이용약관", "term_of_use");

  const TermType(this.title, this.fileName);

  final String title;
  final String fileName;
}
