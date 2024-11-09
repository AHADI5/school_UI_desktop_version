import 'package:flutter/material.dart';
import 'package:school_desktop/features/students/models/student_discipline.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final List<AttendanceResponse> attendanceResponses;

  const AttendanceHistoryPage({
    Key? key,
    required this.attendanceResponses,
  }) : super(key: key);

  @override
  _AttendanceHistoryPageState createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> attendanceData = {};

  @override
  void initState() {
    super.initState();
    _populateAttendanceData();
  }

  // Populate attendanceData based on AttendanceResponse list
  void _populateAttendanceData() {
    for (var response in widget.attendanceResponses) {
      DateTime date = DateTime.parse(response.attendanceDate);
      attendanceData[date] = response.attendanceStatus;
    }
  }

  // Method to get the color based on attendance status string
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PRESENT':
        return Colors.green;
      case 'LATE':
        return Colors.orange;
      case 'ABSENT':
        return Colors.red;
      case 'JUSTIFIED':
        return Colors.blueAccent;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _buildAttendanceCalendar(),
            ),
            if (_selectedDay != null) _buildEventDetails(),
          ],
        ),
      ),
    );
  }

  // Build the interactive calendar with color-coded dates
  Widget _buildAttendanceCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayMarker(day);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayMarker(day, isToday: true);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayMarker(day, isSelected: true);
        },
      ),
    );
  }

  // Method to build each day marker with attendance color
  Widget _buildDayMarker(DateTime day, {bool isToday = false, bool isSelected = false}) {
    final String? status = attendanceData[day];
    final Color statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? Colors.blue
            : isToday
                ? Colors.blueAccent
                : Colors.transparent,
        border: Border.all(color: statusColor, width: 3.0),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Display selected day's details
  Widget _buildEventDetails() {
    final String? status = attendanceData[_selectedDay!] ?? "No records";
    final Color statusColor = _getStatusColor(status);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 3,
        color: statusColor.withOpacity(0.1),
        child: ListTile(
          title: const Text(
            'Attendance Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Date: ${_selectedDay!.toLocal()}'
                '\nStatus: ${status ?? "No Data"}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
