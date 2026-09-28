import 'dart:convert';
import 'dart:io';

enum FlapSetting { Combat, Takeoff, Landing }

class FlapData {
  final FlapSetting setting;

  // Maximum speed with this flap setting
  final double vfe;

  new({required this.setting, required this.vfe});
}

class AircraftData {
  // Maximum operating speed
  //final double vne;
  // Maximum operating mach number
  //final double mne;
  // Maximum operating speed with landing gear extended
  //final double vle;
  //final List<FlapData> flapSettings;
  //final bool hasAutoFlaps;
  // final bool hasCobraButton;
  // final bool hasReverseThrust;
  // final bool missingYawAndAileronTrim;
  final bool hasAirbrake;
  final bool hasTailHook;
  final bool hasDragChute;

  new({
    required this.hasAirbrake,
    required this.hasTailHook,
    required this.hasDragChute,
  });
}

class DataLoader {
  Future<AircraftData> load(String planeId) async {
    const dataminePath = r"E:\src\warthunder pilot notes\War-Thunder-Datamine\";
    final dataFile = jsonDecode(
      await File(
        "$dataminePath\\aces.vromfs.bin_u\\gamedata\\flightmodels\\${planeId}.blkx",
      ).readAsString(),
    ) as Map<String, dynamic>;

    final fmFile = jsonDecode(
      await File(
        "$dataminePath\\aces.vromfs.bin_u\\gamedata\\flightmodels\\fm\\${planeId}.blkx",
      ).readAsString(),
    ) as Map<String, dynamic>;

    return AircraftData(
      hasAirbrake:
          (fmFile["AvailableControls"] as Map<String, dynamic>)["hasAirbrake"]
              as bool,
      hasDragChute:
          (fmFile["AvailableControls"] as Map<String, dynamic>)["hasChutes"]
              as bool? ??
          false,
      hasTailHook: dataFile.containsKey("hook"),
    );
  }
}
