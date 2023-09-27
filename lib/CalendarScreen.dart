import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  bool isMonthlyView = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  void _goToCurrentDate() {
    setState(() {
      _selectedDay = DateTime.now();
      _focusedDay = DateTime.utc(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
        0,
        0,
        0,
      );
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text("Add Event"),
          content: Column(
            children: [
              TextField(
                controller: _eventController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final selectedDay = _selectedDay ?? _focusedDay;
                final eventList = events[selectedDay] ?? [];
                eventList.add(Event(
                  name: _eventController.text,
                  description: _descriptionController.text,
                ));
                setState(() {
                  events[selectedDay] = eventList;
                  _selectedEvents.value = _getEventsForDay(selectedDay);
                });
                _eventController.clear();
                _descriptionController.clear();
              },
              child: const Text("Submit"),
            )
          ],
        );
      },
    );
  }

  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime.utc(2010, 8, 22),
      lastDate: DateTime.utc(2030, 8, 22),
    );

    if (selectedDate != null && selectedDate != _focusedDay) {
      setState(() {
        _focusedDay = selectedDate;
        _selectedDay = selectedDate;
        _selectedEvents.value = _getEventsForDay(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          // Wrap the header text with GestureDetector to make it clickable
          GestureDetector(
            onTap: () {
              _showDatePicker();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:16,horizontal: 20.0),
              child: Text(
                DateFormat('MMM yyyy').format(_focusedDay),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.today),
            onPressed: _goToCurrentDate,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TableCalendar(
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey,
                ),
                todayTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.blue),
                outsideTextStyle: TextStyle(color: Colors.grey),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left),
                rightChevronIcon: Icon(Icons.chevron_right),
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              locale: "en_US",
              rowHeight: 43,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              firstDay: DateTime.utc(2010, 8, 22),
              lastDay: DateTime.utc(2030, 8, 22),
              onFormatChanged: (format) {
                _onFormatChanged(format);
              },
              onDaySelected: (selectedDay, focusedDay) {
                _onDaySelected(selectedDay, focusedDay);
              },
              eventLoader: _getEventsForDay,
            ),
          ),
          const SizedBox(height: 28.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 3.0),
            child: Text(
              DateFormat('(EEE) MMM dd, yyyy').format(_selectedDay!),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, selectedEvents, _) {
                  return ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 2,
                                color: Colors.black87,
                                margin: EdgeInsets.only(right: 16),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '9:00 AM - 9:00 PM',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      event.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final Uri url = Uri.parse(
                                            "https://www.bing.com/maps?osid=d90b968e-4587-4731-beb6-6505c47fb7a7&cp=3.107489~101.462589&lvl=16&imgid=5627ee89-a3be-4893-9bdd-42a4d2fbe391&v=2&sV=2&form=S00027");
                                      },
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'AL',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}




