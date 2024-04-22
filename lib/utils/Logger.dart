import 'dart:io' as io;
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:logger/logger.dart' as d;
import 'package:intl/intl.dart';

class Logger {
  static bool isInfo = false;
  static log(String message, {Level level = Level.error}) async {
    var logger = d.Logger(
      printer: d.PrettyPrinter(printTime: true),
      output: AppFileOutput(),
      filter: MyFilter(),
    );
    logger.i(message);
  }

  static WarningLog(String message) async {
    var logger = d.Logger(
      printer: d.PrettyPrinter(printTime: true),
      output: AppFileOutput(),
      filter: MyFilter(),
    );
    logger.w(message);
  }

  static ErrorLog(String message) async {
    var logger = d.Logger(
      printer: d.PrettyPrinter(printTime: true),
      output: AppFileOutput(),
      filter: MyFilter(),
    );
    logger.e(message);
  }

  static InfoLog(String message) async {
    if (isInfo == true || kDebugMode == true) {
      var logger = d.Logger(printer: d.PrettyPrinter(printTime: true), output: AppFileOutput(), filter: MyFilter());
      logger.i(message);
    }
  }
}

class AppFileOutput extends LogOutput {
  AppFileOutput();

  static io.File? _logFile;

  @override
  void output(OutputEvent event) async {
    if (Platform.isWindows) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(DateTime.now());
      io.Directory current = io.Directory.current;
      final path = current.path + "/Logs";
      var checkDirectory = await io.Directory(path).exists();
      if (!checkDirectory) {
        io.Directory(path).create();
      }
      var syncPath = await path + "/" + "$formatted-logs.log";
      var checkFile = await io.File(syncPath).exists();
      if (checkFile) {
        _logFile = File(syncPath);
      } else {
        _logFile = io.File(path + "/" + formatted + "-logs.log");
      }

      for (var line in event.lines) {
        await _logFile?.writeAsString("${line.toString()}\n", mode: FileMode.writeOnlyAppend);
        print(line); //print to console as well
      }
    }
  }
}

class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      if (event.level.index >= level!.index) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
