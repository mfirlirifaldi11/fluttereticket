import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class DetailAttendanceView extends StatelessWidget {
  final Map<String, dynamic> attendance;

  DetailAttendanceView({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final double latitude = double.parse(attendance['latitude'].toString());
    final double longitude = double.parse(attendance['longitude'].toString());
    final photoUrl = attendance['photo_url'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${attendance['user_id']}'),
            Text('Date Attended: ${attendance['date_attended']}'),
            Text('Time in: ${attendance['time_in']}'),
            Text('Time out: ${attendance['time_out']}'),
            SizedBox(height: 16.0),
            // Display the image from photo_url
            photoUrl.isNotEmpty
                ? Image.network(
                    'http://195.35.8.180:3000/uploads/attendance/$photoUrl',
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 16.0),
            // Display the map based on latitude and longitude
            Container(
              height: 400,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: latlng.LatLng(latitude, longitude),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: latlng.LatLng(latitude, longitude),
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
