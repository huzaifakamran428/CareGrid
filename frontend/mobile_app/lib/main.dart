import 'package:flutter/material.dart';
import 'features/beneficiary/presentation/screens/beneficiary_home_screen.dart';

void main() {
  runApp(const CareGridApp());
}

class CareGridApp extends StatelessWidget {
  const CareGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF14634B),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      home: const BeneficiaryHomeScreen(),
    );
  }
}