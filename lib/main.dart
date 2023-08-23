import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'wifiCheck.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Doge\'s wifi checker',
          theme: ThemeData(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.orange,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          home: const MyHomePage(title: 'Doge\'s wifi checker'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              MyApp.themeNotifier.value =
              MyApp.themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Wifi test'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Wificheck()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Calendar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
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
            Text(
              "Working Schedule",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                focusedDay: today,
                selectedDayPredicate: (day) => isSameDay(day, today),
                firstDay: DateTime.utc(2023, 8, 22),
                lastDay: DateTime.utc(2023, 8, 22),
                onDaySelected: _onDaySelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



