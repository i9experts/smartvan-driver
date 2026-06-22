import 'package:flutter/material.dart';
class PassengersScreen extends StatelessWidget {
  final Map<String, dynamic> trip;
  const PassengersScreen({super.key, required this.trip});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Passengers Screen')));
}