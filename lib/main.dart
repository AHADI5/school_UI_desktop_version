import 'package:flutter/material.dart';
// import 'package:school_desktop/features/auth/screens/login_screen.dart';
import 'package:school_desktop/features/dashboard/screens/dashboard_screen.dart';

void main() {
  runApp(const SchoolAp());
}

class SchoolAp extends StatelessWidget {
  const SchoolAp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, 
        // home: LoginScreen(),
        home: DirectorDashboard(),

    );
  }
}
