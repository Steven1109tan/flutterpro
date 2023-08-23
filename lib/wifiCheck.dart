import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'main.dart';

class Wificheck extends StatefulWidget {
  const Wificheck({super.key});

  @override
  State<Wificheck> createState() => WificheckState();
  }

class WificheckState extends State<Wificheck>{
  String _networkStatus1 = '';
  String _imagePath = '';
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    checkConnectivity1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('SWifi Check'),
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
              _networkStatus1,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Image.asset(
             _imagePath,
              width: 400,
              height: 400,
            ),
            ElevatedButton(onPressed: checkConnectivity1, child: const Text('Check Connection')),
          ],
        ),

      ),
    );
  }

  void checkConnectivity1() async {
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    String statusMessage = 'Check Connection: $conn';
    String imagePath = conn == 'None'
        ? 'assets/images/no_internet.png'
        : 'assets/images/internet.png';

    setState(() {
      _networkStatus1 = statusMessage;
      _imagePath = imagePath;
    });
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