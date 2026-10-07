import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:wtpn/data.dart';
import 'package:wtpn/wt_client.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
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
    final theme = Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        listTileTheme: theme.listTileTheme.copyWith(
          leadingAndTrailingTextStyle: TextTheme.of(context).bodyMedium,
        ),
      ),
      home: Scaffold(
        body: switch (selectedAircraftData) {
          null => SizedBox.shrink(),
          final data => Builder(
            builder: (context) {
              final limits = [
                ListTile(
                  title: Text('Max Speed Limit (IAS)'),
                  trailing: Text(data.vne.toStringAsFixed(0)),
                ),
                ListTile(
                  title: Text('Mach Number Limit'),
                  trailing: Text(data.mne.toStringAsFixed(2)),
                ),
                ListTile(
                  title: Text('Gear Speed Limit (IAS)'),
                  trailing: Text(data.vle.toStringAsFixed(0)),
                ),
              ];

              final flaps = [
                if (data.hasAutoFlaps)
                  const ListTile(title: Text('Automated Flaps Retraction')),
                ...data.flapSettings!.map(
                  (f) => ListTile(
                    title: Text('Flap Speed Limit (IAS)'),
                    subtitle: Text(switch (f.setting) {
                      FlapSetting.combat => 'Combat',
                      FlapSetting.takeoff => 'Takeoff',
                      FlapSetting.landing => 'Landing',
                    }),
                    trailing: Text(f.vfe.toStringAsFixed(0)),
                  ),
                ),
              ];

              final features = [
                if (data.hasCobraButton)
                  const ListTile(title: Text('Cobra Button')),
                if (data.hasReverseThrust)
                  const ListTile(title: Text('Reverse Thrust')),
                if (data.missingYawAndAileronTrim)
                  const ListTile(title: Text('No Roll Trim')),
                if (data.hasAirbrake) const ListTile(title: Text('Airbrake')),
                if (data.hasTailHook) const ListTile(title: Text('Tailhook')),
                if (data.hasDragChute)
                  const ListTile(title: Text('Drag Chute')),
              ];

              return ListView(
                children: [
                  SectionTitle(title: 'Limits'),
                  ...limits,
                  if (flaps.isNotEmpty) ...[
                    SectionTitle(title: 'Flaps'),
                    ...flaps,
                  ],
                  if (features.isNotEmpty) ...[
                    SectionTitle(title: 'Features'),
                    ...features,
                  ],
                ],
              );
            },
          ),
        },
      ),
    );
  }

  late WarThunderHttpClient client;
  AircraftData? selectedAircraftData;
}

class SectionTitle extends StatelessWidget {
  const new({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: Text(title, style: TextTheme.of(context).titleLarge),
    );
  }
}
