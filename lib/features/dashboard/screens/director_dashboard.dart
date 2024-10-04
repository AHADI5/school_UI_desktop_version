import 'package:flutter/material.dart';
import 'package:school_desktop/features/dashboard/screens/widgets/events_alerts.dart';
import 'package:school_desktop/features/dashboard/screens/widgets/stat_charts.dart';
import 'package:school_desktop/features/dashboard/screens/widgets/stats_cards.dart';

class DirectorDashboard extends StatelessWidget {
  const DirectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StatsCards(),
            ChartsSection(),
            ResponsiveCommuniquesTable(),
          ],
        ),
      ),
    );
  }
}
