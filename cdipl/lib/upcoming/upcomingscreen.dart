import 'dart:convert';
import 'dart:developer';

import 'package:cdipl/api/callservice.dart';
import 'package:cdipl/constants.dart';
import 'package:cdipl/helpers/tokenmanager.dart';
import 'package:cdipl/providers/call_log_provider.dart';
import 'package:cdipl/upcoming/models/sample_contacts_model.dart';
import 'package:cdipl/upcoming/utils/call_handler.dart';
import 'package:cdipl/upcoming/widgets/zoom_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UpcomingScreen extends StatefulWidget {
  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  // final List<Map<String, String>> callData = [
  //   {
  //     'name': 'praveen',
  //     'primary': '20328465',
  //     'date': '26 Sept, 24',
  //     'time': '10:23 am'
  //   },
  //   {
  //     'name': 'Rohan',
  //     'primary': '19858404',
  //     'date': '26 Sept, 24',
  //     'time': '10:24 am'
  //   },
  //   {
  //     'name': 'Sushvi',
  //     'primary': '20342043',
  //     'date': '26 Sept, 24',
  //     'time': '10:36 am'
  //   },
  //   {
  //     'name': 'Sudhir kr ji',
  //     'primary': '19678501',
  //     'date': '26 Sept, 24',
  //     'time': '11:06 am'
  //   },
  //   {
  //     'name': 'Pooja',
  //     'primary': '20352894',
  //     'date': '26 Sept, 24',
  //     'time': '11:22 am'
  //   },
  //   // Add more call data as needed
  // ];
  void _showCallResultPopup(String phoneNumber, String callId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String projectName = '';

        return AlertDialog(
          title: Text('Call Result'),
          content: Text('How was the call?'),
          actions: [
            ElevatedButton(
                child: Text('Interested'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the current dialog

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Project Details'),
                        content: TextField(
                          onChanged: (value) {
                            projectName = value;
                          },
                          decoration:
                              InputDecoration(hintText: "Enter project name"),
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text('Submit'),
                            onPressed: () {
                              _sendCallResult(phoneNumber, 'interested', callId,
                                  projectName);
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
            ElevatedButton(
              child: Text('Not Interested'),
              onPressed: () => _sendCallResultnotinterested(
                  phoneNumber, 'not interested', callId),
            ),
            ElevatedButton(
              child: Text('Future'),
              onPressed: () => _sendCallResult(phoneNumber, 'future', callId),
            ),
          ],
        );
      },
    );
  }

  void _sendCallResult(String phoneNumber, String result, String callId,
      [String? projectName]) async {
    final url = Uri.parse('${serverurl}/update/callstatus');
    String? token = await TokenManager.getToken();
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          'phoneNumber': phoneNumber,
          'result': result,
          'callId': callId,
          'projectName': projectName,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('saved')),
        );
        print('Call result sent successfully');
      } else {
        print('Failed to send call result');
      }
    } catch (e) {
      print('Error sending call result: $e');
    }
  }

  void _sendCallResultnotinterested(
    String phoneNumber,
    String result,
    String callId,
  ) async {
    final url = Uri.parse('${serverurl}/update/callstatus');
    String? token = await TokenManager.getToken();
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          'phoneNumber': phoneNumber,
          'result': result,
          'callId': callId, // Include callId in the request body
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('saved')),
        );

        print('Call result sent successfully');
      } else {
        print('Failed to send call result');
      }
    } catch (e) {
      print('Error sending call result: $e');
    }
    Navigator.of(context).pop(); // Close the dialog
  }

  late Future<List<Map<String, dynamic>>> callData;
  List<Contact>? _deviceContacts;
  bool _showSampleContacts = true;

  CallLogHandler _callLogHandler = CallLogHandler();

  void initState() {
    super.initState();
    _fetchDeviceContacts();

    callData = CallApiService().fetchColdData();
    callData.then((data) {
      print('Data received: $data');
    }).catchError((error) {
      print('Error occurred: $error');
    });
    // Call the API when the widget is initialized
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

  void _makeCall(String phoneNumber, Contact contact, String callId) async {
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
      _showCallResultPopup(phoneNumber, callId); // Pass callId to the popup
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make the call')),
      );
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Upcoming'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00D1D1), Color(0xFF00616D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: callData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Text('No calls available');
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final call = data[index];
                        return CallListItem(
                          name: call['name']?.toString() ?? 'No name',
                          primaryNumber:
                              call['phone']?.toString() ?? 'No number',
                          date: call['futuredate']?.toString() ?? 'No date',
                          time: call['createdAt']?.toString() ?? 'No time',
                          callId: call['id']?.toString() ?? 'No ID',
                          makeCall: _makeCall,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Consumer<CallLogProvider>(
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
                                                child:
                                                    Text(contact.initials()))),
                                    title:
                                        Text(contact.displayName ?? 'No Name'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(contact.phones!.isNotEmpty
                                            ? contact.phones!.first.value ??
                                                'No Phone'
                                            : 'No Phone'),
                                        Text(
                                            'Duration: ${_formatDuration(entry.duration)}'),
                                        Text(
                                            'Time: ${entry.timestamp.toString()}'),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.blueAccent),
                                          onPressed: () {
                                            callLogProvider
                                                .removeCallLog(entry);
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
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ));
  }
}

class CallListItem extends StatelessWidget {
  final String name;
  final String primaryNumber;
  final String date;
  final String time;
  final String callId;

  final Function(String, Contact, String)? makeCall;

  CallListItem({
    required this.name,
    required this.primaryNumber,
    required this.date,
    required this.time,
    required this.callId,
    this.makeCall,
  });

  @override
  @override
  Widget build(BuildContext context) {
    Contact contact = Contact(
      displayName: name,
      phones: [Item(label: 'mobile', value: primaryNumber)],
    );

    return ListTile(
      leading: Icon(Icons.group, color: Colors.blueAccent),
      title: Row(
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('CALLS', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      subtitle: Text('Primary: $primaryNumber • $date $time'),
      trailing: IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: () {
            makeCall!(primaryNumber, contact, callId);
          }),
    );
  }
}
