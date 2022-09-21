import 'package:customer_support_app/screens/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CustomerSupportApp());
}

class CustomerSupportApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: LandingPage(),
    );
  }
}


