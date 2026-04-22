import 'package:flutter/material.dart';
class ResultsScreen extends StatelessWidget {
  final String analysisId;
  const ResultsScreen({super.key, required this.analysisId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Results')));
}
