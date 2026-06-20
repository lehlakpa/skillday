import 'package:flutter/material.dart';
import 'package:skillday/custom_widgets.dart/custom_appbar.dart';
import 'package:skillday/custom_widgets.dart/custom_buttom_navigation.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(), // Added the missing comma here
      body: Center(
        child: Text(
          "Main Content Area",
        ), // This is where your page content goes
      ),
      bottomNavigationBar: CustomBottomNavigation(), // Moved from body to here
    );
  }
}
