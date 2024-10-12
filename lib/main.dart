import 'package:flutter/material.dart';
import 'package:school_desktop/common_widgets/nav_bars.dart';
import 'package:school_desktop/features/auth/screens/login_screen.dart';
// import 'package:school_desktop/features/auth/screens/login_screen.dart';

void main() {
  runApp(const SchoolAp());
}

class SchoolAp extends StatelessWidget {
  const SchoolAp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: "Ushirik System",
        // home: LoginScreen(),
        // home: NavigationDrawerApp(),
        // home: const LoginScreen(),
         routes: {
        '/': (context) => const LoginScreen(), // Login screen as the initial route
        '/home': (context) => const NavigationDrawerApp(), // Replace with your home screen
      },
      
    );
  }
}
