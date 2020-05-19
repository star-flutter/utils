import 'string_formatter.dart';

extension StringFormat on String {
  String format(List<dynamic> args) {
    return StringFormatter.format(this, args.map((arg) => arg.toString()).toList());
  }
}