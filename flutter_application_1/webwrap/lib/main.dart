import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Select correct WebView platform
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  } else if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebApp(),
    );
  }
}

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    String url;

    if (Platform.isAndroid) {
      // ✅ Android Emulator uses this
      url = 'http://10.0.2.2:8000/admin/';
    } else if (Platform.isIOS) {
      // ✅ iOS Simulator can use localhost
      url = 'http://127.0.0.1:8000/admin/';
    } else {
      // ✅ Physical devices (Android/iPhone) — use your LAN IP
      // Replace this with your actual IP (e.g., 192.168.1.8)
      url = 'http://192.168.1.8:8000/admin/';
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Django Site"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
