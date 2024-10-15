import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Map<String, String>> contacts = [
    {
      'name': 'Ompal Singh Gautam',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'Poonam Rhode',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'PritS Singh',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'H S Bajaj',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'Paltu Ojha',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'Ajay Jain',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'NA',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
    {
      'name': 'Brahm Pal',
      'time': '10:22:45',
      'msg': 'Please make a call and check if the client has any requirements'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00695C),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text('Contacts'),
      ),
      // centerTitle: true,
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Client name, Phone number, Flat number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ContactCard(
                  name: contact['name']!,
                  time: contact['time']!,
                  message: contact['msg']!,
                  index: index + 1,
                  onCallPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CallPage(contactName: contact['name']!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String name;
  final String time;
  final String message;
  final int index;
  final VoidCallback onCallPressed;

  ContactCard({
    required this.name,
    required this.time,
    required this.message,
    required this.index,
    required this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat_bubble),
                    color: Color(0xFF25D366),
                    onPressed: () {
                      // Implement WhatsApp action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.phone),
                    color: Color(0xFF00796B),
                    onPressed: onCallPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallPage extends StatelessWidget {
  final String contactName;

  CallPage({required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00695C),
        title: Text('Calling $contactName'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Calling $contactName...',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
