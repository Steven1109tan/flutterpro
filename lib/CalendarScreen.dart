import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Working Schedule",
              style: TextStyle(fontSize: 20),
            ),
            TableCalendar(
              locale: "en_US",
              rowHeight: 43,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              focusedDay: today,
              selectedDayPredicate: (day) => isSameDay(day, today),
              firstDay: DateTime.utc(2023, 8, 22),
              lastDay: DateTime.utc(2023, 8, 22),
              onDaySelected: _onDaySelected,
            ),
          ],
        ),
      ),
    );
  }
}



