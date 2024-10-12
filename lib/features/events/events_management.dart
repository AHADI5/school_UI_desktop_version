import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_desktop/features/auth/services/auth_service.dart';
import 'package:school_desktop/features/events/service/event_service.dart';
import 'package:school_desktop/utils/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:school_desktop/features/events/models/event_model.dart';
import 'package:logger/logger.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EventsManagementScreen extends StatefulWidget {
  const EventsManagementScreen({super.key});

  @override
  _EventsManagementScreenState createState() => _EventsManagementScreenState();
}

class _EventsManagementScreenState extends State<EventsManagementScreen> {
  final EventService _eventService = EventService();
  final AuthService _authService = AuthService();
  final Logger logger = Logger();
  List<Event> events = [];
  DateTime selectedDate = DateTime.now();
  int? schoolID; // Store the schoolID

  @override
  void initState() {
    super.initState();
    _fetchSchoolID().then((_) {
      _fetchEvents(); // Fetch events after school ID is available
    });
  }

  Future<void> _fetchSchoolID() async {
    String? schoolIDStr = await _authService.retrieveSchoolID();
    setState(() {
      schoolID = schoolIDStr != null ? int.tryParse(schoolIDStr) : null;
    });
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      if (schoolID == null) {
        logger.e("School ID is null. Cannot fetch events.");
        return;
      }
      // Construct the URL using the available school ID
      String url = '$eventsUrl/$schoolID/events';
      logger.i("Fetching events from URL: $url");

      List<Event>? fetchedEvents = await _eventService.fetchAppointments(url);
      if (fetchedEvents != null) {
        setState(() {
          events = fetchedEvents;
          logger.i('Fetched events: ${events.toString()}');
        });
      } else {
        logger.w("No events fetched.");
      }
    } catch (error) {
      logger.e("Error fetching events: $error");
    }
  }

  void _showEventsForDate(DateTime date) {
    List<Event> dateEvents = events
        .where((event) =>
            event.startingDate.day == date.day &&
            event.startingDate.month == date.month &&
            event.startingDate.year == date.year)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Events on ${DateFormat.yMMMd().format(date)}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (Event event in dateEvents)
                ListTile(
                  title: Text(event.title),
                  subtitle: Text(
                      "${DateFormat.jm().format(event.startingDate)} - ${DateFormat.jm().format(event.endingDate)}"),
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEventPopup(date, event: event),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEvent(event),
                  ),
                ),
              const Divider(),
              ElevatedButton.icon(
                onPressed: () => _showEventPopup(date),
                icon: const Icon(Icons.add),
                label: const Text('Add Event'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) async {
    String deleteUrl = 'your-api-url-to-delete-events/${event.eventID}';
    bool deleted = await _eventService.deleteAppointment(deleteUrl);
    if (deleted) {
      setState(() {
        events.remove(event);
        logger.i('Deleted event: $event');
      });
    }
  }

// Show event popup for creating or editing events
  void _showEventPopup(DateTime date, {Event? event}) {
    String eventTitle = event?.title ?? '';
    String eventDescription = event?.description ?? '';
    String eventPlace = event?.place ?? '';
    DateTime eventStart = event?.startingDate ?? date;
    DateTime eventEnd = event?.endingDate ?? date.add(const Duration(hours: 1));
    Color eventColor = event != null
        ? Color(int.parse(event.color.substring(1, 7), radix: 16) + 0xFF000000)
        : Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(event == null ? 'Create Event' : 'Edit Event'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: TextEditingController(text: eventTitle),
                      onChanged: (value) {
                        eventTitle = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Event Title',
                        icon: Icon(Icons.event),
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: eventDescription),
                      onChanged: (value) {
                        eventDescription = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Event Description',
                        icon: Icon(Icons.description),
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: eventPlace),
                      onChanged: (value) {
                        eventPlace = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Event Place',
                        icon: Icon(Icons.place),
                      ),
                    ),
                    // Start date picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "From: ${DateFormat.yMd().add_jm().format(eventStart)}"),
                        IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: eventStart,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(eventStart),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  eventStart = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "To: ${DateFormat.yMd().add_jm().format(eventEnd)}"),
                        IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: eventEnd,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(eventEnd),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  eventEnd = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    // Color picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Color:'),
                        Container(
                          width: 30,
                          height: 30,
                          color: eventColor,
                        ),
                        IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Pick a color'),
                                  content: BlockPicker(
                                    pickerColor: eventColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        eventColor = color;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    if (eventTitle.isNotEmpty) {
                      Event newEvent = Event(
                        eventID: event?.eventID ?? 0,
                        title: eventTitle,
                        description: eventDescription,
                        place: eventPlace,
                        startingDate: eventStart,
                        endingDate: eventEnd,
                        color:
                            '#${eventColor.value.toRadixString(16).substring(2).toUpperCase()}', // Save color as hex string
                      );

                      if (event == null) {
                        // Create new event
                        String createUrl = '$eventsUrl/$schoolID/newEvent';
                        logger.i(createUrl);
                        Event? createdEvent = await _eventService
                            .createAppointment(createUrl, newEvent);
                        if (createdEvent != null) {
                          setState(() {
                            _fetchEvents();
                            events.add(createdEvent);
                          });
                        }
                      } else {
                        // Update existing event
                        String updateUrl =
                            '$eventsUrl/$schoolID/newEvent/${event.eventID}';
                        Event? updatedEvent = await _eventService
                            .updateAppointment(updateUrl, newEvent);
                        if (updatedEvent != null) {
                          setState(() {
                            _fetchEvents();
                            int index = events.indexOf(event);
                            events[index] = updatedEvent;
                          });
                        }
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEventPopup(selectedDate),
          ),
        ],
      ),
      body: SfCalendar(
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule,
        ],
        initialDisplayDate: selectedDate,
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            selectedDate = details.date!;
            _showEventsForDate(selectedDate);
          } else if (details.targetElement == CalendarElement.appointment) {
            Event event = details.appointments?.first;
            _showEventPopup(selectedDate, event: event);
          }
        },
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        
        dataSource: EventDataSource(events),
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startingDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endingDate;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return Color(
        int.parse(appointments![index].color.substring(1, 7), radix: 16) +
            0xFF000000);
  }
}
