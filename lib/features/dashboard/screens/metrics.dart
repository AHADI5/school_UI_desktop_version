import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricsDashboard extends StatelessWidget {
  const MetricsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: BadBehaviorsCard()),
            SizedBox(width: 16),
            Expanded(child: MetricCardWithPieChart(title: "Présences")),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: AlertsSection()),
          ],
        ),
      ],
    );
  }
}

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
              "Discipline",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
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

class MetricCardWithPieChart extends StatelessWidget {
  final String title;

  const MetricCardWithPieChart({super.key, required this.title});

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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: _attendanceStatsData(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                    // Handle touch events if needed
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _attendanceStatsData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 70,
        title: '70%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 30,
        title: '30%',
        radius: 45,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LegendItem(color: Colors.blue, label: 'Présences (70%)'),
        LegendItem(color: Colors.green, label: 'Absences (30%)'),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}




class AlertsSection extends StatelessWidget {
  const AlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adding elevation for a modern look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discipline Alerts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Adjust height as needed
              child: ListView.builder(
                itemCount: 5, // Replace with actual count of alerts
                itemBuilder: (context, index) {
                  return AlertItem(
                    studentName: "Student ${index + 1}", // Replace with actual student name
                    ruleBypassed: "Rule ${index + 1} Bypassed", // Replace with actual rule
                    occurrences: 70 + index * 5, // Replace with actual occurrence count
                    decision: index % 2 == 0 ? "Warning" : "Definitive Excluded", // Replace with actual decision
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Voir Plus" action
                },
                child: const Text("Voir Plus"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertItem extends StatelessWidget {
  final String studentName;
  final String ruleBypassed;
  final int occurrences; // Percentage for progress
  final String decision;

  const AlertItem({
    super.key,
    required this.studentName,
    required this.ruleBypassed,
    required this.occurrences,
    required this.decision,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5), // Space between alerts
      child: ListTile(
        leading: CircleAvatar(
          // Placeholder for student avatar, replace with actual image if needed
          backgroundColor: Colors.blueAccent,
          child: Text(
            studentName[0], // Display first letter of student's name
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rule Bypassed: $ruleBypassed"),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: occurrences / 100, // Assuming occurrences are a percentage
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
            ),
            SizedBox(height: 5),
            Text("Occurrences: $occurrences%", style: const TextStyle(color: Colors.grey)),
            Text("Decision: $decision", style: const TextStyle(color: Colors.red)), // Assuming decision is important
          ],
        ),
        isThreeLine: true, // Allows for more lines in the subtitle
      ),
    );
  }
}
