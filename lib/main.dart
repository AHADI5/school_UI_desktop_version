import 'package:flutter/material.dart';
import 'package:school_desktop/common_widgets/nav_bars.dart';
// import 'package:school_desktop/features/auth/screens/login_screen.dart';

void main() {
  runApp(const SchoolAp());
}

class SchoolAp extends StatelessWidget {
  const SchoolAp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: "Ushirik System",
        // home: LoginScreen(),
        home: NavigationDrawerApp(),
      
    );
  }
}
