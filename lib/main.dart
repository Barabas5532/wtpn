import 'package:flutter/material.dart';
import 'package:wtpn/data.dart';
import 'package:wtpn/wt_client.dart';

void main() {
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
    final loader = DataLoader();

    client.selectedAircraftId.listen((planeId) async {
      final data = await loader.load(planeId);
      setState(() {
        selectedAircraftData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: switch (selectedAircraftData) {
          null => SizedBox.shrink(),
          final data => Column(
            children: [
              ListTile(
                title: Text('VNE'),
                trailing: Text(data.vne.toStringAsFixed(0)),
              ),
              ListTile(
                title: Text('MNE'),
                trailing: Text(data.mne.toStringAsFixed(2)),
              ),
              ListTile(
                title: Text('VLE'),
                trailing: Text(data.vle.toStringAsFixed(2)),
              ),
              if (data.hasAirbrake) const ListTile(title: Text('Airbrake')),
              if (data.hasTailHook) const ListTile(title: Text('Tailhook')),
              if (data.hasDragChute) const ListTile(title: Text('Drag Chute')),
            ],
          ),
        },
      ),
    );
  }

  late WarThunderHttpClient client;
  AircraftData? selectedAircraftData;
}
