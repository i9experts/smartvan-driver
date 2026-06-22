import 'package:flutter/material.dart';
class AlertDetailScreen extends StatelessWidget {
  final Map<String, dynamic> alert;
  const AlertDetailScreen({super.key, required this.alert});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Alert Detail Screen')));
}