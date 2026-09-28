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
  final double vne;

  // Maximum operating mach number
  final double mne;

  // Maximum operating speed with landing gear extended
  final double vle;

  //final List<FlapData> flapSettings;
  //final bool hasAutoFlaps;
  // final bool hasCobraButton;
  // final bool hasReverseThrust;
  // final bool missingYawAndAileronTrim;
  final bool hasAirbrake;
  final bool hasTailHook;
  final bool hasDragChute;

  new({
    required this.vne,
    required this.mne,
    required this.vle,
    required this.hasAirbrake,
    required this.hasTailHook,
    required this.hasDragChute,
  });
}

(double, double) _getVneMne(Map<String, dynamic> fmFile) {
  double? vne;
  double? mne;

  vne = fmFile["Vne"] as double?;
  mne = fmFile["VneMach"] as double?;

  if (vne != null && mne != null) {
    return (vne, mne);
  }

  final aerodynamics = fmFile["Aerodynamics"] as Map<String, dynamic>;
  final wingStrength =
      aerodynamics["WingPlane"]?["Strength"] as Map<String, dynamic>?;
  vne = wingStrength?["VNE"] as double?;
  mne = wingStrength?["MNE"] as double?;

  if (vne != null && mne != null) {
    return (vne, mne);
  }

  // For swept wing, assume automatic control is enabled. As the plane gets
  // faster, the wing is swept back increasing the maximum allowed speed.
  final res = <(double, double)>[];
  int i = 0;
  while (true) {
    final k = "WingPlaneSweep$i";

    if (!aerodynamics.containsKey(k)) {
      assert(i != 0, "There must be at least one entry");
      break;
    }

    var strength = aerodynamics[k]["Strength"];
    res.add((strength["VNE"] as double, strength["MNE"] as double));

    i++;
  }

  assert(
    res.length >= 2,
    "Swept wing aircraft should have at least 2 sweep angles defined.",
  );

  assert(
    res[res.length - 1].$1 > res[res.length - 2].$1,
    "Last entry in wing sweep table should be the highest speed.",
  );
  assert(
    res[res.length - 1].$2 > res[res.length - 2].$2,
    "Last entry in wing sweep table should be the highest speed.",
  );

  return res.last;
}

class DataLoader {
  Future<AircraftData> load(String planeId) async {
    const dataminePath = r"E:\src\warthunder pilot notes\War-Thunder-Datamine\";
    final dataFile = jsonDecode(
      await File(
        "$dataminePath\\aces.vromfs.bin_u\\gamedata\\flightmodels\\${planeId}.blkx",
      ).readAsString(),
    ) as Map<String, dynamic>;

    // Some filenames in the fm folder do not match the top level data file
    // name. e.g. a6m5hei.blkx points to fm/a6m5_Hei.blk. We must read the fm
    // file name from the top level file.

    final fmFilePath = dataFile["fmFile"] as String? ?? "$planeId.blk";
    final fmFile = jsonDecode(
      await File(
        "$dataminePath\\aces.vromfs.bin_u\\gamedata\\flightmodels\\${fmFilePath}x",
      ).readAsString(),
    ) as Map<String, dynamic>;

    final vneMne = _getVneMne(fmFile);

    return AircraftData(
      vne: vneMne.$1,
      mne: vneMne.$2,
      vle: fmFile["Mass"]["GearDestructionIndSpeed"] as double,
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
