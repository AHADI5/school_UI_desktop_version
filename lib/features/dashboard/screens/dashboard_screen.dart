import 'package:flutter/material.dart';
import 'package:school_desktop/features/dashboard/screens/events.dart';
import 'package:school_desktop/features/dashboard/screens/last_communique.dart';
import 'package:school_desktop/features/dashboard/screens/metrics.dart';
import 'package:school_desktop/features/dashboard/screens/sidebar.dart';
import 'package:school_desktop/features/dashboard/screens/top_bar.dart';

class DirectorDashboard extends StatelessWidget {
  const DirectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return buildDashboard();
  }
}
  Widget buildDashboard() {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(), // Left-side navigation
          Expanded(
            child: Column(
              children: [
                DashboardTopBar(), // Top navigation bar (search, notifications)
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: MetricsDashboard(), // Main dashboard (daily traffic, students)
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CommuniqueCard(), // Alerts block
                              SizedBox(height: 16),
                              EventsCalendar(), // Events calendar block
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
