import 'package:contacts_service/contacts_service.dart';

class SampleContactsModel {
  static final List<CustomCallLogEntry> sampleContacts = [
    CustomCallLogEntry(
      contact: Contact(
        displayName: 'John Doe',
        phones: [Item(label: 'mobile', value: '+1 123 456 7890')],
        avatar: null,
      ),
      duration: Duration(minutes: 5),
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    CustomCallLogEntry(
      contact: Contact(
        displayName: 'Jane Smith',
        phones: [Item(label: 'work', value: '+1 981 654 3445')],
        avatar: null,
      ),
      duration: Duration(minutes: 3),
      timestamp: DateTime.now().subtract(Duration(days: 2)),
    ),
    CustomCallLogEntry(
      contact: Contact(
        displayName: 'Emily Davis',
        phones: [Item(label: 'home', value: '+44 20 1234 5678')],
        avatar: null,
      ),
      duration: Duration(minutes: 7),
      timestamp: DateTime.now().subtract(Duration(days: 3)),
    ),
    CustomCallLogEntry(
      contact: Contact(
        displayName: 'Michael Brown',
        phones: [Item(label: 'mobile', value: '+61 400 123 456')],
        avatar: null,
      ),
      duration: Duration(minutes: 10),
      timestamp: DateTime.now().subtract(Duration(days: 4)),
    ),
    CustomCallLogEntry(
      contact: Contact(
        displayName: 'Sarah Wilson',
        phones: [Item(label: 'home', value: '+91 98765 43210')],
        avatar: null,
      ),
      duration: Duration(minutes: 2),
      timestamp: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];
}

class CustomCallLogEntry {
  final Contact contact;
  final Duration duration;
  final DateTime timestamp;

  CustomCallLogEntry(
      {required this.contact, required this.duration, required this.timestamp});
}
