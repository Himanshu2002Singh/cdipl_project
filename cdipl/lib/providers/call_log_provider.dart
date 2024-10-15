import 'dart:developer';

import 'package:cdipl/upcoming/models/sample_contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:call_log/call_log.dart' as SystemCallLog;

class CallLogProvider with ChangeNotifier {
  List<CustomCallLogEntry> _callLog = [];

  List<CustomCallLogEntry> get callLog => _callLog;

  Future<void> fetchCallLog() async {
    final Iterable<SystemCallLog.CallLogEntry> entries =
        await SystemCallLog.CallLog.get();
    _callLog = await Future.wait(entries.map((entry) async {
      Contact? contact;
      try {
        Iterable<Contact> contacts = await ContactsService.getContacts(
          query: entry.name ?? entry.number ?? '',
        );
        contact = contacts.isNotEmpty ? contacts.first : null;
      } catch (e) {
        log('Error fetching contact: $e');
      }

      return CustomCallLogEntry(
        contact: contact ??
            Contact(
              displayName: entry.name ?? 'Unknown',
              phones: [Item(value: entry.number)],
            ),
        duration: Duration(seconds: entry.duration ?? 0),
        timestamp: DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0),
      );
    }));
    notifyListeners();
  }

  void addCallLog(CustomCallLogEntry entry) {
    _callLog.add(entry);
    notifyListeners();
  }

  void removeCallLog(CustomCallLogEntry entry) {
    _callLog.remove(entry);
    notifyListeners();
  }

  void clearCallLogs() {
    _callLog.clear();
    notifyListeners();
  }
}
