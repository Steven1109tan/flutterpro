import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Add this line
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // @override
  // void dispose() {
  //   _eventController.dispose();
  //   _descriptionController.dispose(); // Add this line
  //   _selectedEvents.dispose();
  //   super.dispose();
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
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
                 // date: selectedDay,
                ));
                setState(() {
                events[selectedDay] = eventList;
                _selectedEvents.value = _getEventsForDay(selectedDay);
                });
              },
              child: const Text("Submit"),
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
      body: Center(

        child: Column(
          children: [
            const SizedBox(height: 8.0),
            TableCalendar(
              calendarStyle: const CalendarStyle(
                // Customize the background color of the selected day
                selectedDecoration: BoxDecoration(
                  color: Colors.blue, // Customize the background color of the selected day
                  shape: BoxShape.circle, // You can also customize the shape (e.g., circle)
                ),
                markersMaxCount: 5, // Specify the maximum number of event markers to display
                markersAlignment: Alignment.bottomCenter, // Customize marker alignment
                outsideTextStyle: TextStyle(color: Colors.grey), // Customize text color for days outside the month
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.blue, // Customize the chevron icon color here
                    BlendMode.srcIn,
                  ),
                  child: Icon(Icons.chevron_left),
                ),
                rightChevronIcon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.blue, // Customize the chevron icon color here
                    BlendMode.srcIn,
                  ),
                  child: Icon(Icons.chevron_right),
                ),
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              locale: "en_US",
                rowHeight: 43,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                firstDay: DateTime.utc(2010, 8, 22),
                lastDay: DateTime.utc(2030, 8, 22),
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                // builders: CalendarBuilders(
                //   todayDayBuilder: (context, date, events) => Container(
                //     margin: const EdgeInsets.all(4.0),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       color: Colors.green, // Customize the background color for today's date
                //       shape: BoxShape.circle,
                //     ),
                //     child: Text(
                //       '${date.day}',
                //       style: TextStyle(
                //         color: Colors.white, // Customize the text color for today's date
                //       ),
                //     ),
                //   ),
                // ),
            ),
            const SizedBox(height: 8.0),
            ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
                       child: ListView.builder(
                         itemCount: value.length,
                         itemBuilder: (context, index) {
                         return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue, // Set the background color to blue
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              child: Text(
                                '9:am - 9:pm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Text(
                                    value[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                  child: Text(
                                    value[index].description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           const Column(
                              //  crossAxisAlignment: CrossAxisAlignment,
                              //  crossAxisAlignment: CrossAxisAlignment,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                    child: Icon(Icons.add_business),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                    child: Text(
                                      'AL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                          ],
                        ),

                         );
                    },
                  ),
                    ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}





