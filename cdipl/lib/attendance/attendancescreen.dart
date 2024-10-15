import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Attendancescreen extends StatefulWidget {
  const Attendancescreen({super.key});

  @override
  State<Attendancescreen> createState() => _AttendancescreenState();
}

class _AttendancescreenState extends State<Attendancescreen> {
  final double targetLatitude = 28.7041; // Replace with your latitude
  final double targetLongitude = 77.1025; // Replace with your longitude
  String attendanceStatus = 'Attendance not marked';

  Future<void> _checkLocationAndMarkAttendance() async {
    // Check location permission
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      setState(() {
        attendanceStatus = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        setState(() {
          attendanceStatus = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      setState(() {
        attendanceStatus = 'Location permissions are permanently denied.';
      });
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Calculate distance
    double distanceInMeters = Geolocator.distanceBetween(
      targetLatitude,
      targetLongitude,
      position.latitude,
      position.longitude,
    );

    // Check if within 100 meters
    if (distanceInMeters <= 100) {
      setState(() {
        attendanceStatus = 'Attendance marked successfully!';
      });
    } else {
      setState(() {
        attendanceStatus = 'You are not within 100 meters of the location.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(attendanceStatus),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkLocationAndMarkAttendance,
              child: Text('Mark Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
