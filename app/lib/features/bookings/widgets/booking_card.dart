import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.venueName, required this.date, required this.startTime, required this.status});
  final String venueName;
  final String date;
  final String startTime;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(venueName), subtitle: Text('$date · $startTime')));
  }
}
