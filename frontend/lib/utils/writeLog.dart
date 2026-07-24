import 'dart:io';

void writeLog({required String logName, required String log}) async {
  var logFile = File("../log/ERR.log");

  var date = DateTime.now().toString();

  await logFile.writeAsString("[$date] ERROR: $logName MESSAGE: $log");
}
