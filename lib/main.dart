import 'package:flutter/material.dart';
import 'package:wifi_connectivity_test/webview.dart';
import 'Geofence+ui.dart';
import 'list.dart';
import 'wifiCheck.dart';
import 'CalendarScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider<ThemeChanger>(
    create: (_) => ThemeChanger(),
    child: MyApp(),
  ),
);

class ThemeChanger with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Projects',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeChanger>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage();

  // Function to navigate to WiFi test screen
  void navigateToWifiTest(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Wificheck()),
    );
  }

  // Function to navigate to Calendar screen
  void navigateToCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
  }

  // Function to navigate to Webview screen
  void navigateToWebview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WebViewExample()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    Color appBarColor = themeChanger.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar:
      AppBar(
        title: Text(
          'Flutter Projectss',
          style: TextStyle(
            color: themeChanger.isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(
              themeChanger.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.blue,
            ),
            onPressed: () {
              themeChanger.toggleMode();
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: appBarColor,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('WiFi Test'),
              onTap: () {
                navigateToWifiTest(context);
              },
            ),
            ListTile(
              title: Text('Calendar'),
              onTap: () {
                navigateToCalendar(context);
              },
            ),
            ListTile(
              title: Text('Webview'),
              onTap: () {
                navigateToWebview(context);
              },
            ),
            // Add more ListTiles for additional functions
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              child: const Text('WiFi test'),
              onPressed: () {
                navigateToWifiTest(context);
              },
            ),
            SizedBox(height: 10.0), // Add vertical spacing
            ElevatedButton(
              child: const Text('Calendar'),
              onPressed: () {
                navigateToCalendar(context);
              },
            ),
            SizedBox(height: 10.0), // Add vertical spacing
            ElevatedButton(
              child: const Text('Webview'),
              onPressed: () {
                navigateToWebview(context);
              },
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              child: const Text('List Grouping'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyItemList()),
                );
              },
            ),
            SizedBox(height: 10.0),
            // Add more buttons or content here
          ],
        ),
      ),
    );
  }
}
