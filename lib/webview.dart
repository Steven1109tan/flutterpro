import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports



class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(
        Uri.parse(
            'https://www.sql.com.my/income-tax-calculator-malaysia/ya-2022/'),
        method: LoadRequestMethod.post,
        headers: {
          'Content-Type':
          'application/x-www-form-urlencoded', // Specify the content type
          'User-Agent': 'insomnia/2023.5.8', // Set the user agent
          'Cookie':
          'wordpress_google_apps_login=17fc1400c13b1f837d5b77f11ef6a2a0', // Add cookies if needed
        },
        body: Uint8List.fromList(
            utf8.encode(_getPostDataString())), // Encode and set POST data,
      );

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  String _getPostDataString() {
    Map<String, String> postData = {
      'grossIncome': '66000',
      'lossOfEmployment': '1',
      'serviceYear': '4',
      'grossIncome': '66000',
      'lossOfEmployment': '1',
      'serviceYear': '4',
      'lossOfEmployment': '1',
      'serviceYear': '4',
      'compensation': '0',
      'disabled': '1',
      'maritalStatus': '1',
      'disabledSpouse': '1',
      'workingSpouse': '1',
      'alimony': '1000',
      'child': '1',
      'childBelow18': '1',
      'childALevel': '2',
      'childHigherEdu': '3',
      'childDisabled': '4',
      'childDisabledHigherEdu': '5',
      'childEdu': '6',
      'breastfeeding': '7',
      'childcare': '8',
      'parentMedical': '9',
      'prs': '10',
      'medicalInsurance': '11',
      'eduSelf': '12',
      'supportEquip': '13',
      'medical': '14',
      'epf': '15',
      'lifeInsurance': '16',
      'lifestyle1': '17',
      'lifestyle2': '18',
      'lifestyle3': '19',
      'socso': '20',
      'travel': '21',
      'ev': '22',
      'pcb': '23',
      'zakat': '24',
      'btnCalcTax': '1',
    };

    // Convert the POST data to a query string
    return postData.entries.map((entry) {
      return "${entry.key}=${entry.value}";
    }).join('&');
  }
}