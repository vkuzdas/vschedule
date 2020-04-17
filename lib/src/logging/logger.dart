import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          printEmojis: false,
          printTime: true,
          lineLength: 200,
          colors: true
      )
  );
}
