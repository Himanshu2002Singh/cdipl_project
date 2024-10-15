import 'package:cdipl/api/callservice.dart';
import 'package:cdipl/upcoming/upcomingscreen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Myleads extends StatefulWidget {
  const Myleads({super.key});

  @override
  State<Myleads> createState() => _MyleadsState();
}

class _MyleadsState extends State<Myleads> {
  late Future<List<Map<String, dynamic>>> myleads;

  void initState() {
    super.initState();

    myleads = CallApiService().fetchMyleadsData();
    myleads.then((data) {
      print('Data received: $data');
    }).catchError((error) {
      print('Error occurred: $error');
    });
    // Call the API when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My leads'),
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
          future: myleads,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final call = data[index];
                        return LeadsListItem(
                          name: call['name']?.toString() ?? 'No name',
                          primaryNumber:
                              call['phone']?.toString() ?? 'No number',
                          date: call['futuredate']?.toString() ?? 'No date',
                          time: call['createdAt']?.toString() ?? 'No time',
                          callId: call['id']?.toString() ?? 'No ID',
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

class LeadsListItem extends StatelessWidget {
  final String name;
  final String primaryNumber;
  final String date;
  final String time;
  final String callId;

  final Function(String, Contact, String)? makeCall;

  LeadsListItem({
    required this.name,
    required this.primaryNumber,
    required this.date,
    required this.time,
    required this.callId,
    this.makeCall,
  });

  @override
  Widget build(BuildContext context) {
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
      // trailing: IconButton(
      //     icon: Icon(Icons.phone, color: Colors.green),
      //     onPressed: () {
      //       makeCall!(primaryNumber, contact, callId);
      //     }),
    );
  }
}
