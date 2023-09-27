import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'main.dart';

class Wificheck extends StatefulWidget {
  const Wificheck({super.key});

  @override
  State<Wificheck> createState() => WificheckState();
}

class WificheckState extends State<Wificheck> {
  String _networkStatus1 = 'No internet';
  String _imagePath = 'assets/images/internet.png';
  Connectivity connectivity = Connectivity();
  ConnectivityResult connectivityResult =ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500),(timer) async {
      if(!mounted) {
        timer.cancel();
      }else{
        ConnectivityResult result = await connectivity.checkConnectivity();
        setState(() {
          connectivityResult = result;
          checkConnectivityAndInternet();
        });
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SWifi Check'),
        // actions: [
        //   IconButton(
        //     icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
        //         ? Icons.light_mode
        //         : Icons.dark_mode),
        //     onPressed: () {
        //       MyApp.themeNotifier.value =
        //       MyApp.themeNotifier.value == ThemeMode.light
        //           ? ThemeMode.dark
        //           : ThemeMode.light;
        //     },
        //   ),
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _networkStatus1,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              _imagePath,
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkConnectivityAndInternet() async {
    var conn = getConnectionValue(connectivityResult);
 //String statusMessage = 'Check Connection: $conn';
    String statusMessage = '';
    String imagePath = conn == 'None'
        ? 'assets/images/no_internet.png'
        : 'assets/images/internet.png';

    String internetAvailability = await _checkInternetAvailability();
    if (internetAvailability == 'Has Internet') {
      try {
        final response = await http.get(Uri.parse('https://www.google.com/'));
        if (response.statusCode == 200) {
          final startTime = DateTime.now();
          await http.get(Uri.parse('https://www.google.com/'));
          final endTime = DateTime.now();
          final duration = endTime.difference(startTime);
          final milliseconds = duration.inMilliseconds;

          if (milliseconds > 500) {
            statusMessage = '$conn : Poor Internet $milliseconds';
            imagePath = 'assets/images/poor_wifi.png';
          }else {
            statusMessage = '$conn - Good Internet $milliseconds';
            imagePath = 'assets/images/internet.png';
          }
        }
      } catch (e) {
        debugPrint('$e');
      }
    } else {
      statusMessage = '$conn : No Internet';
      imagePath = 'assets/images/no_internet.png';
    }

    setState(() {
      _networkStatus1 = statusMessage;
      _imagePath = imagePath;
    });
  }

  Future<String> _checkInternetAvailability() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com/'));
      if (response.statusCode == 200) {
        return 'Has Internet';
      } else {
        return 'No Internet';
      }
    } catch (e) {
      return 'No Internet';
    }
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }
}
