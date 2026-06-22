import 'package:flutter/material.dart';
class TripScreen extends StatelessWidget {
  final Map<String, dynamic> trip;
  const TripScreen({super.key, required this.trip});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Trip Screen')));
}