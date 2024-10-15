import 'package:flutter/material.dart';

class CampaignScreen extends StatelessWidget {
  final List<Map<String, dynamic>> campaigns = [
    {'date': '26-Sep-2024', 'title': 'SYDATA-1', 'count': 145},
    {'date': '25-Sep-2024', 'title': 'SYDATA-1', 'count': 139},
    {'date': '24-Sep-2024', 'title': 'SYDATA-1', 'count': 134},
    {'date': '24-Sep-2024', 'title': 'SYDATA-1', 'count': 149},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text('Campaigns'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Campaign Name, Type, Date',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0 ||
                          campaigns[index]['date'] !=
                              campaigns[index - 1]['date'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            campaign['date'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampaignDetailPage(
                                title: campaign['title'],
                                date: campaign['date'],
                                count: campaign['count'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${campaign['title']} - ${campaign['date']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(${campaign['count']})',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final int count;

  CampaignDetailPage(
      {required this.title, required this.date, required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Details'),
      ),
      body: Center(
        child: Text(
          'Details for $title on $date with $count clicks.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
