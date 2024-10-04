import 'package:flutter/material.dart';

class ResponsiveCommuniquesTable extends StatelessWidget {
  const ResponsiveCommuniquesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        double tableWidth = _getTableWidth(width, constraints);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: tableWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DataTable(
              headingRowHeight: 56,
              dataRowHeight: 56,
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.shade100),
              columns: _buildColumns(width),
              rows: _createRows(),
              dividerThickness: 0.5,
              showBottomBorder: true,
            ),
          ),
        );
      },
    );
  }

  // Adjust the table width based on screen size and breakpoints
  double _getTableWidth(double width, BoxConstraints constraints) {
    if (width < 600) {
      return constraints.maxWidth - 20; // Compact
    } else if (width < 840) {
      return 800; // Medium
    } else {
      return 1200; // Expanded
    }
  }

  // Build columns based on the window class (responsive)
  List<DataColumn> _buildColumns(double width) {
    if (width < 600) {
      // Compact (minimal columns)
      return const [
        DataColumn(
          label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ];
    } else if (width < 840) {
      // Medium (more detailed)
      return const [
        DataColumn(
          label: Text('Source', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Date Created', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ];
    } else {
      // Expanded (full detailed columns)
      return const [
        DataColumn(
          label: Text('Source', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Channel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Recipient', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Date Created', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        DataColumn(
          label: Text('Time Created', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ];
    }
  }

  // Example data for the table
  List<DataRow> _createRows() {
    List<Communique> communiques = [
      Communique('School', 'Parent Meeting', 'Email', 'All Parents', 'Sent', '2024-10-01', '10:30 AM'),
      Communique('Principal', 'School Play', 'Notification', 'Students', 'Pending', '2024-10-01', '11:00 AM'),
      Communique('Teacher', 'Homework Assignment', 'SMS', 'John Doe', 'Delivered', '2024-10-01', '12:15 PM'),
      Communique('Admin', 'Sports Day', 'Email', 'All Students', 'Sent', '2024-10-01', '1:45 PM'),
      Communique('Counselor', 'Mental Health Workshop', 'In-Person', 'Emma Smith', 'Upcoming', '2024-10-02', '9:00 AM'),
    ];

    return communiques.map((communique) {
      return DataRow(
        cells: [
          DataCell(Row(
            children: [
              const Icon(Icons.account_balance, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(communique.source),
            ],
          )),
          DataCell(Text(communique.title)),
          DataCell(Row(
            children: [
              _getChannelIcon(communique.channel),
              const SizedBox(width: 8),
              Text(communique.channel),
            ],
          )),
          DataCell(Text(communique.recipient)),
          DataCell(Text(
            communique.status,
            style: TextStyle(
              color: _getStatusColor(communique.status),
              fontWeight: FontWeight.bold,
            ),
          )),
          DataCell(Text(communique.dateCreated)),
          DataCell(Text(communique.timeCreated)),
        ],
      );
    }).toList();
  }

  // Get icon for different communication channels
  Icon _getChannelIcon(String channel) {
    switch (channel) {
      case 'Email':
        return const Icon(Icons.email, color: Colors.blue);
      case 'Notification':
        return const Icon(Icons.notifications, color: Colors.orange);
      case 'SMS':
        return const Icon(Icons.sms, color: Colors.green);
      case 'In-Person':
        return const Icon(Icons.person, color: Colors.purple);
      default:
        return const Icon(Icons.device_unknown, color: Colors.grey);
    }
  }

  // Function to determine the color based on the status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Sent':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Delivered':
        return Colors.blue;
      case 'Upcoming':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}

// Data class for a communiqué
class Communique {
  final String source;
  final String title;
  final String channel;
  final String recipient;
  final String status;
  final String dateCreated; // New property for date
  final String timeCreated; // New property for time

  Communique(this.source, this.title, this.channel, this.recipient, this.status, this.dateCreated, this.timeCreated);
}
