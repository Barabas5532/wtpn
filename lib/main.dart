import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wtpn/wt-client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setFullScreen(true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setResizable(false);
    await windowManager.setClosable(false);
    await windowManager.setMinimizable(false);
    await windowManager.show();
  });

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    client = WarThunderHttpClient();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text('Hello World!')),
      ),
    );
  }

  late WarThunderHttpClient client;
}
