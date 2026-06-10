import 'package:flutter/material.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({super.key, required this.name, required this.sport, required this.address, required this.onTap});
  final String name;
  final String sport;
  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(name), subtitle: Text(sport), onTap: onTap));
  }
}
