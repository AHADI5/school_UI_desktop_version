import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends StatelessWidget {
  const EventsCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Events Calendar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: SingleChildScrollView(
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
