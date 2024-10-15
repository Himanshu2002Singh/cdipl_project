import 'package:cdipl/attendance/attendancescreen.dart';
import 'package:cdipl/campaigns/campaignscreen.dart';
import 'package:cdipl/contacts/contactscreen.dart';
import 'package:cdipl/leads/myleads.dart';
import 'package:cdipl/upcoming/upcomingscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Function to navigate to a new page when an icon is clicked
  void navigateTo(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPage(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CDIPL'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {}, // Add your notification logic here
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(color: Colors.green),
            ),
            ListTile(
              title: Text('Option 1'),
              onTap: () {}, // Add navigation logic
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {}, // Add navigation logic
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Used Points Section
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.purpleAccent
                    ], // Gradient effect
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(20), // More rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(0, 5), // Subtle shadow effect
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Used Points: 0',
                          style: TextStyle(
                            color: Colors.white, // White text for contrast
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5), // Space between texts
                        Text(
                          'Available Credits: 100',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Add claim lead logic
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Claim Leads Now',
                        style: TextStyle(
                          color: Colors.blueAccent, // Match the gradient
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Interactions Section
              SectionTitle(title: 'Interactions'),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  InteractionIcon(
                      icon: Icons.event_available,
                      label: 'Upcoming',
                      badgeCount: 27,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpcomingScreen(),
                          ),
                        );
                      }),
                  // InteractionIcon(
                  //     icon: Icons.phone_missed,
                  //     label: 'Missed',
                  //     badgeCount: 14,
                  //     onPressed: () => navigateTo(context, 'Missed')),
                  InteractionIcon(
                      icon: Icons.calendar_today,
                      label: 'Overall',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsPage(),
                          ),
                        );
                      }),
                  InteractionIcon(
                      icon: Icons.note_alt,
                      label: 'Notes',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampaignScreen(),
                          ),
                        );
                      }),
                  InteractionIcon(
                      icon: Icons.access_time,
                      label: 'Pending Followups',
                      onPressed: () =>
                          navigateTo(context, 'Pending Followups')),
                  InteractionIcon(
                      icon: Icons.people,
                      label: 'Weak Followups',
                      onPressed: () => navigateTo(context, 'Weak Followups')),
                  InteractionIcon(
                      icon: Icons.pin_drop,
                      label: 'Prime Site Visits',
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Attendancescreen(),
                            ),
                          )),
                  InteractionIcon(
                      icon: Icons.favorite,
                      label: 'Favourite Leads',
                      onPressed: () => navigateTo(context, 'Favourite Leads')),
                ],
              ),
              SizedBox(height: 20),
              // Leads Section
              SectionTitle(
                title: 'Leads',
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  InteractionIcon(
                      icon: Icons.leaderboard,
                      label: 'My Leads',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Myleads(),
                          ),
                        );
                      }),
                  InteractionIcon(
                      icon: Icons.groups,
                      label: 'Cross Segments',
                      onPressed: () => navigateTo(context, 'Cross Segments')),
                  InteractionIcon(
                      icon: Icons.event_available,
                      label: 'My RSVP\'s',
                      onPressed: () => navigateTo(context, 'My RSVP\'s')),
                  InteractionIcon(
                      icon: Icons.call,
                      label: 'Lead Call Logs',
                      onPressed: () => navigateTo(context, 'Lead Call Logs')),
                ],
              ),
              SizedBox(height: 20),
              // Calling Section
              SectionTitle(title: 'Calling'),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  InteractionIcon(
                      icon: Icons.phone,
                      label: 'Cold Call',
                      onPressed: () => navigateTo(context, 'Cold Call')),
                  InteractionIcon(
                      icon: Icons.groups,
                      label: 'Cold Meeting',
                      onPressed: () => navigateTo(context, 'Cold Meeting')),
                  InteractionIcon(
                      icon: Icons.call,
                      label: 'Call Data',
                      onPressed: () => navigateTo(context, 'Call Data')),
                  InteractionIcon(
                      icon: Icons.phone,
                      label: 'Call Logs',
                      onPressed: () => navigateTo(context, 'Call Logs')),
                  InteractionIcon(
                      icon: Icons.data_usage,
                      label: 'Data Allocation',
                      onPressed: () => navigateTo(context, 'Data Allocation')),
                ],
              ),
              SizedBox(height: 20),
              // Activities Section
              SectionTitle(title: 'Activities'),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  InteractionIcon(
                      icon: Icons.groups,
                      label: 'My Team',
                      onPressed: () => navigateTo(context, 'My Team')),
                  InteractionIcon(
                      icon: Icons.people,
                      label: 'My Team Interactions',
                      onPressed: () =>
                          navigateTo(context, 'My Team Interactions')),
                  InteractionIcon(
                      icon: Icons.place,
                      label: 'My Visits',
                      onPressed: () => navigateTo(context, 'My Visits')),
                  InteractionIcon(
                    icon: Icons.update,
                    label: 'Hot Updates',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CampaignsPage(),
                      //   ),
                      // );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;
  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }
}

// Interaction Icon Widget
class InteractionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? badgeCount;
  final VoidCallback onPressed;

  InteractionIcon(
      {required this.icon,
      required this.label,
      this.badgeCount,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Stack(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              if (badgeCount != null)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      badgeCount.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// New Page when an icon is clicked
class NewPage extends StatelessWidget {
  final String title;
  NewPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is the $title page'),
      ),
    );
  }
}
