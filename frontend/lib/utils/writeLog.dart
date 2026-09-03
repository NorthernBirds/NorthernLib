import 'dart:io';
import 'package:frontend/config.dart';

void writeLog({required String logName, required String log}) async {
  if (!await logDir.exists()) {
    await logDir.create(recursive: true);
  }

  File logFile = File('${logDir.path}/ERR.log');

  if (!await logFile.exists()) {
    await logFile.create();
  }

  var date = DateTime.now().toString();
  await logFile.writeAsString(
    "[$date] ERROR: $logName MESSAGE: $log\n",
    mode: FileMode.append,
  );
}
