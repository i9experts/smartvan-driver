import 'package:flutter/material.dart';
class KidProfileScreen extends StatelessWidget {
  final Map<String, dynamic> kid;
  const KidProfileScreen({super.key, required this.kid});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Kid Profile Screen')));
}