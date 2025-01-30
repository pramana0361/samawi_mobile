// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Print to console only in debug mode
printDebug(Object? object, {bool isError = false, bool showPin = false}) {
  if (kDebugMode) {
    String line = "$object";
    if (isError) {
      dev.log('\x1B[31m' + (showPin ? '📌 ' : '') + line + '\x1B[0m');
      return;
    }
    dev.log('\x1B[32m' + (showPin ? '📌 ' : '') + line + '\x1B[0m');
  }
}

String milisecondsToDateString(int timestamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  return DateFormat('dd-MM-yyyy').format(dt);
}

int generateRandomInt(int length) {
  final Random secureRandom = Random.secure();
  final List<int> numbers =
      List<int>.generate(length, (int _) => secureRandom.nextInt(10));

  return int.parse(numbers.join(''));
}
