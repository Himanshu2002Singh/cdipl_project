import 'dart:developer' show log;

import 'package:cdipl/providers/call_log_provider.dart';
import 'package:cdipl/upcoming/models/sample_contacts_model.dart';
import 'package:cdipl/upcoming/utils/call_handler.dart';
import 'package:cdipl/upcoming/widgets/zoom_button.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact>? _deviceContacts;
  bool _showSampleContacts = true;

  CallLogHandler _callLogHandler = CallLogHandler();

  @override
  void initState() {
    super.initState();
    _fetchDeviceContacts();
  }

  Future<void> _fetchDeviceContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _deviceContacts = contacts.toList();
      });
    } else {
      _showPermissionDeniedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please enable contacts access in settings.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Contact> getDisplayedContacts() {
    return _showSampleContacts
        ? SampleContactsModel.sampleContacts
            .map((entry) => entry.contact)
            .toList()
        : (_deviceContacts ?? []);
  }

  /*
  void _storeCall(Contact contact) {
    final callLogProvider =
        Provider.of<CallLogProvider>(context, listen: false);
    final duration = Duration(minutes: 1 + (DateTime.now().second % 10));
    callLogProvider.addCallLog(CustomCallLogEntry(
      contact: contact,
      duration: duration,
      timestamp: DateTime.now(),
    ));
  }

  void _makeCall(String phoneNumber, Contact contact) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res != null && res) {
      _storeCall(contact);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make the call')),
      );
    }
  }
  */

  Future<Duration?> _waitForCallLogUpdate(String phoneNumber) async {
    // await Future.delayed(Duration(seconds: 3));

    int attempts = 0;
    while (attempts < 5) {
      Duration? duration =
          await _callLogHandler.getLastCallDuration(phoneNumber);
      if (duration != null) {
        return duration;
      }
      await Future.delayed(Duration(seconds: 2));
      attempts++;
    }
    return null;
  }

  void _makeCall(String phoneNumber, Contact contact) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res != null && res) {
      await _waitForCallLogUpdate(phoneNumber);

      Duration? callDuration =
          await _callLogHandler.getLastCallDuration(phoneNumber);

      if (callDuration != null) {
        _storeCall(contact, callDuration);
      } else {
        log('Could not retrieve call duration');
        _storeCall(contact, Duration.zero);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make the call')),
      );
    }
  }

  void _storeCall(Contact contact, Duration duration) {
    final callLogProvider =
        Provider.of<CallLogProvider>(context, listen: false);
    callLogProvider.addCallLog(CustomCallLogEntry(
      contact: contact,
      duration: duration,
      timestamp: DateTime.now(),
    ));
  }

  void _clearCallHistory() {
    final callLogProvider =
        Provider.of<CallLogProvider>(context, listen: false);
    callLogProvider.clearCallLogs();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Call history cleared')),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    List<String> parts = [];

    if (hours > 0) {
      parts.add('$hours hr');
    }
    if (minutes > 0) {
      parts.add('$minutes min');
    }
    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds sec');
    }

    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contacts List'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Contacts'),
              Tab(text: 'Call History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sample'),
                      Switch(
                        value: !_showSampleContacts,
                        onChanged: (value) {
                          setState(() {
                            _showSampleContacts = !value;
                          });
                          _fetchDeviceContacts();
                        },
                      ),
                      Text('Device'),
                    ],
                  ),
                ),
                Expanded(
                  child: _deviceContacts == null && !_showSampleContacts
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: getDisplayedContacts().length,
                          itemBuilder: (context, index) {
                            Contact contact = getDisplayedContacts()[index];
                            log('contact.initials-201: ${contact.initials()}');

                            return ListTile(
                              leading: (contact.avatar != null &&
                                      contact.avatar!.isNotEmpty)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.avatar!),
                                    )
                                  : CircleAvatar(
                                      child: Center(
                                          child: Text(contact.initials())),
                                    ),
                              title: Text(contact.displayName ?? 'No Name'),
                              subtitle: Text(contact.phones!.isNotEmpty
                                  ? contact.phones!.first.value ?? 'No Phone'
                                  : 'No Phone'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.save),
                                    onPressed: () {
                                      _storeCall(contact, Duration.zero);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Call stored')),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.call),
                                    onPressed: () {
                                      if (contact.phones!.isNotEmpty) {
                                        _makeCall(
                                            contact.phones!.first.value ?? '',
                                            contact);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            Consumer<CallLogProvider>(
              builder: (context, callLogProvider, child) {
                final callLog = callLogProvider.callLog;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _clearCallHistory,
                        child: Text('Clear Entire Call History'),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: callLog.length,
                        itemBuilder: (context, index) {
                          CustomCallLogEntry entry = callLog[index];
                          log('entry.duration: ${entry.duration}');
                          Contact contact = entry.contact;
                          log('contact.initials-268: ${contact.initials()}');

                          return ListTile(
                            leading: (contact.avatar != null &&
                                    contact.avatar!.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!))
                                : CircleAvatar(
                                    child: Center(
                                        child: Text(contact.initials()))),
                            title: Text(contact.displayName ?? 'No Name'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.phones!.isNotEmpty
                                    ? contact.phones!.first.value ?? 'No Phone'
                                    : 'No Phone'),
                                Text(
                                    'Duration: ${_formatDuration(entry.duration)}'),
                                Text('Time: ${entry.timestamp.toString()}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.blueAccent),
                                  onPressed: () {
                                    callLogProvider.removeCallLog(entry);
                                  },
                                ),
                                ZoomButton(
                                  icon: Icons.thumb_up,
                                  color: Colors.green,
                                  tooltipMessage: 'Yes',
                                  onPressed: () {
                                    log('Yes (Thumbs Up) button pressed for ${contact.displayName}');
                                  },
                                ),
                                const SizedBox(width: 15),
                                ZoomButton(
                                  icon: Icons.thumb_down,
                                  color: Colors.red,
                                  tooltipMessage: 'No',
                                  onPressed: () {
                                    log('No (Thumbs Down) button pressed for ${contact.displayName}');
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
