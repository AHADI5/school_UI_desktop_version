import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;

        // For tablets, remove the third card (Latest Communique)
        bool isTablet = width < 800;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistics Overview',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildRow(isTablet: isTablet),
            ],
          ),
        );
      },
    );
  }

  // Build row with charts and cards
  Widget _buildRow({required bool isTablet}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: BadBehaviorsCard(),  // Discipline chart
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: AttendanceCard(title: "Présences"),  // Attendance chart with bar
        ),
        if (!isTablet) ...[
          const SizedBox(width: 16),
          Expanded(
            child: _buildLatestCommuniqueList(),
          ),
        ],
      ],
    );
  }

  // Redesigned Latest Communique List
  Widget _buildLatestCommuniqueList() {
    List<Communique> communiques = [
      Communique('School Closed', 'Jul 12th 2024', 'Pending'),
      Communique('Meeting Reminder', 'Jul 10th 2024', 'Completed'),
      Communique('Holiday Announcement', 'Jul 8th 2024', 'Completed'),
      Communique('New Policy', 'Jul 6th 2024', 'Pending'),
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.announcement,
                  color: Colors.blueAccent,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Latest Communique',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: communiques.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return _buildCommuniqueItem(communiques[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommuniqueItem(Communique communique) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.circle,
              color: Colors.green, // Adjust the color depending on status
              size: 24,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  communique.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  communique.date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          communique.status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: communique.status == 'Completed'
                ? Colors.green
                : Colors.orange,
          ),
        ),
      ],
    );
  }
}

class Communique {
  final String title;
  final String date;
  final String status;

  Communique(this.title, this.date, this.status);
}

// Discipline chart (BadBehaviorsCard)
class BadBehaviorsCard extends StatelessWidget {
  const BadBehaviorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discipline Evolution",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                backgroundColor: Colors.white, // Set chart background to white
                primaryXAxis: const CategoryAxis(),
                title: const ChartTitle(text: 'Discipline'),
                legend: const Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  BarSeries<BehaviorData, String>(
                    dataSource: _getBehaviorData(),
                    xValueMapper: (BehaviorData data, _) => data.behavior,
                    yValueMapper: (BehaviorData data, _) => data.percentage,
                    name: 'Behavior',
                    color: Colors.deepPurpleAccent,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BehaviorData> _getBehaviorData() {
    return [
      BehaviorData('Disruption', 45),
      BehaviorData('Absence', 30),
      BehaviorData('Lateness', 15),
      BehaviorData('Cheating', 10),
    ];
  }
}

class BehaviorData {
  final String behavior;
  final double percentage;

  BehaviorData(this.behavior, this.percentage);
}

// Attendance chart (AttendanceCard)
class AttendanceCard extends StatelessWidget {
  final String title;
  const AttendanceCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                backgroundColor: Colors.white, // Set chart background to white
                primaryXAxis: const CategoryAxis(),
                title: const ChartTitle(text: 'Attendance'),
                legend: const Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  BarSeries<AttendanceData, String>(
                    dataSource: _getAttendanceData(),
                    xValueMapper: (AttendanceData data, _) => data.status,
                    yValueMapper: (AttendanceData data, _) => data.count,
                    name: 'Attendance',
                    color: Colors.blue,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AttendanceData> _getAttendanceData() {
    return [
      AttendanceData('Présences', 70),
      AttendanceData('Absences', 30),
    ];
  }
}

class AttendanceData {
  final String status;
  final double count;

  AttendanceData(this.status, this.count);
}
