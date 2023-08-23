import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Wificheck extends StatelessWidget {
  final String networkStatus;
  final String imagePath;

  const Wificheck({
    Key? key,
    required this.networkStatus,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check SWifi'),
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
            Text(
              networkStatus,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              imagePath,
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}

class WificheckState extends State<Wificheck>{
  String _networkStatus1 = '';
  String _imagePath = '';
  Connectivity connectivity = Connectivity();


}