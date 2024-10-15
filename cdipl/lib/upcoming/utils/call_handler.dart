import 'dart:developer';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

class CallLogHandler {
  Future<Duration?> getLastCallDuration(String phoneNumber) async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      String normalizedInputNumber = normalizePhoneNumber(phoneNumber);

      int fiveMinutesAgo =
          DateTime.now().subtract(Duration(minutes: 5)).millisecondsSinceEpoch;
      Iterable<CallLogEntry> entries = await CallLog.query(
        dateFrom: fiveMinutesAgo,
        dateTo: DateTime.now().millisecondsSinceEpoch,
      );

      log('Number of recent call log entries: ${entries.length}');

      if (entries.isNotEmpty) {
        log('entries.name-21: ${entries.first.name}');
        log('entries.number-21: ${entries.first.number}');
        log('entries.formattedNumber-22: ${entries.first.formattedNumber}');
        log('entries.duration-23: ${entries.first.duration}');
        log('entries.callType-24: ${entries.first.callType}');
        log('entries.timestamp-35: ${entries.first.timestamp}');
      }

      for (var entry in entries) {
        log('Entry number: ${entry.number}, duration: ${entry.duration}, timestamp: ${entry.timestamp}');

        String normalizedEntryNumber = normalizePhoneNumber(entry.number ?? '');

        if (normalizedEntryNumber == normalizedInputNumber) {
          log('Matching call found. Duration: ${entry.duration}');
          return Duration(seconds: entry.duration ?? 0);
        }
      }

      log('No matching call found in recent logs');
      return null;
    } else {
      log('Call log permission denied');
      return null;
    }
  }

  String normalizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\D'), '');
  }
}
