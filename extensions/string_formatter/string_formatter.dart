class StringFormatter {
  static const needleRegex = r'%s';
  static final RegExp exp = new RegExp(needleRegex);

  static String format(String string, List<String> args) {
    Iterable<RegExpMatch> matches = exp.allMatches(string);

    assert(args.length == matches.length);

    var i = -1;
    return string.replaceAllMapped(exp, (match) {
      i = i + 1;
      return '${args[i]}';
    });
  }
}
