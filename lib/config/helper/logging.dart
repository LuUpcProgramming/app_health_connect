import 'package:logger/logger.dart';

logger(Type type) {
  return Logger(
    printer: CustomerPrinter(type.toString()),
    level: Level.debug,
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    output: null, // Use the default LogOutput (-> send everything to console)
  );
}

class CustomerPrinter extends LogPrinter {
  final String className;

  CustomerPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji $className: $message')];
  }
}
