import 'package:flutter/material.dart';

class Event {
  int eventID; // Event ID as an integer
  String title; // Title of the event
  String description; // Description of the event
  String place; // Place of the event
  DateTime startingDate; // Starting date and time of the event
  DateTime endingDate; // Ending date and time of the event
  String color; // Color associated with the event

  Event({
    required this.eventID,
    required this.title,
    required this.description,
    required this.place,
    required this.startingDate,
    required this.endingDate,
    required this.color,
  });

  // Factory constructor to create an Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventID: json['eventID'], // Cast to int
      title: json['title'] as String,
      description: json['description'] as String,
      place: json['place'] as String,
      startingDate: DateTime.parse(json['startingDate']),
      endingDate: DateTime.parse(json['endingDate']),
      color: json['color'],
    );
  }

  // Method to convert an Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'eventID': eventID,
      'title': title,
      'description': description,
      'place': place,
      'startingDate': startingDate.toIso8601String(),
      'endingDate': endingDate.toIso8601String(),
      'color': color,
    };
  }

  // Factory constructor to create a copy of an Event with modified properties
  factory Event.copyWith(Event event, {
    int? eventID,
    String? title,
    String? description,
    String? place,
    DateTime? startingDate,
    DateTime? endingDate,
    String? color,
  }) {
    return Event(
      eventID: eventID ?? event.eventID, // Use the existing eventID if not provided
      title: title ?? event.title,
      description: description ?? event.description,
      place: place ?? event.place,
      startingDate: startingDate ?? event.startingDate,
      endingDate: endingDate ?? event.endingDate,
      color: color ?? event.color,
    );

  }

    // Override toString method for logging
  @override
  String toString() {
    return 'Event{eventID: $eventID, title: "$title", description: "$description", place: "$place", startingDate: $startingDate, endingDate: $endingDate, color: "$color"}';
  }
}
