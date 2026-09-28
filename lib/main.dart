import 'package:flutter/material.dart';
import 'package:wtpn/wt-client.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override void initState() {
    super.initState();

    client = WarThunderHttpClient();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }

  late WarThunderHttpClient client;
}
