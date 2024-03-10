extension GetFileNameExtension on String {
  String getFileNameExtension() {
    Iterable<RegExpMatch> match = RegExp("/([^/]+.(png|jpg|jpeg|gif|bmp|svg|webp))").allMatches(this);

    return match.first.group(1) ?? '';
  }
}
