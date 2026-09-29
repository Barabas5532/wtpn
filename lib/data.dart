import 'dart:convert';
import 'dart:io';
import 'dart:ui';

enum FlapSetting { combat, takeoff, landing }

extension FlapSettingKeyEx on FlapSetting {
  String get jsonKey => switch (this) {
    FlapSetting.combat => "Combat",
    FlapSetting.takeoff => "Takeoff",
    FlapSetting.landing => "Landing",
  };
}

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

  final List<FlapData>? flapSettings;

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
    required this.flapSettings,
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

List<FlapData>? _getFlaps(Map<String, dynamic> fmFile) {
  // bf-109f-1 and some others contain a list of 2 or 3 true instead of a
  // single boolean. Can't tell what it means but we can assume they have
  // flaps.
  if (fmFile["AvailableControls"]["hasFlapsControl"] case bool hasFlapsControl
      when !hasFlapsControl) {
    return null;
  }

  final aerodynamics = fmFile["Aerodynamics"] as Map<String, dynamic>;
  // yp-38 has a list of two identical entries in FlapAxis. Use the fist
  // one and ignore the other.
  final flapsAxis = switch (aerodynamics["FlapsAxis"]) {
    List<dynamic> f => f[0],
    Map<dynamic, dynamic> f => f,
    var f => throw StateError("Unexpected type ${f.runtimeType}"),
  };

  final presentFlapSettings = FlapSetting.values
      .where((f) => flapsAxis[f.jsonKey]["Presents"] as bool)
      .map((f) => (f, flapsAxis[f.jsonKey]["Flaps"] as double))
      .toList();

  final mass = fmFile["Mass"] as Map<String, dynamic>;
  // Assume that the points present in the fm file are used to linear
  // interpolate based on the flap position marked for each flap setting.
  final vfe = <(double, double)>[];
  if ((mass["FlapsDestructionIndSpeedP"] as Object?)
          ?.ifTypeOrNull<List<dynamic>>()
          ?.cast<double>()
      case final s?) {
    assert(s.length == 4);
    vfe.add((s[0], s[1]));
    vfe.add((s[2], s[3]));
  } else {
    int i = mass.containsKey("FlapsDestructionIndSpeedP0") ? 0 : 1;
    while (true) {
      // Some planes like seafire_fr47 skip some indices. Specifically that
      // one goes from P2 to P4. That also seems to break the wiki page showing
      // 370 km/h for both landing and takeoff flaps.
      // Increment i and try up to 100 to work around.
      // TODO maybe this is a bug exclusive to that plane? Make some debug code
      // to check it.

      // bb-1 has a list of lists at P1. The wiki lists both landing and takeoff
      // limit as 340 km/h which corresponds to the first entry in the list.
      // TODO check how many other planes have this
      // TODO check values produced for seafire_fr47, bb-1, a_10a_early,
      //      i-16_chung_28, ro_44 against in game and wiki.
      switch (mass["FlapsDestructionIndSpeedP$i"]) {
        case List<dynamic> s when s.first is List:
          vfe.addAll(s.map((s) => (s[0], s[1])));
          break;
        case List<dynamic> s:
          vfe.add((s[0], s[1]));
          break;
        case null:
          break;
      }

      i++;
      if (i >= 100) break;
    }
  }

  if (presentFlapSettings.isEmpty) {
    // ro_44 claims to have flaps but doesn't define any settings.
    return null;
  }

  // i-16_chung_28 contains a single value of 700 instead of a list. wiki does
  // not show any flaps speed limits. wm_21 also has 257 with the value missing
  // from the wiki.
  //
  // These planes reach here with no vfe points defined and we return 0 for now
  // to indicate unknown limits.
  // TODO check if the value in the file is used by the game or not and update
  //  return value.
  if (vfe.isEmpty) {
    return presentFlapSettings
        .map((f) => FlapData(setting: f.$1, vfe: 0))
        .toList();
  }

  return presentFlapSettings
      .map((f) => FlapData(setting: f.$1, vfe: vfe.lerp(f.$2)))
      .toList();
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

    var fmFilePath = dataFile["fmFile"] as String? ?? "fm/$planeId";
    // Some fmFile entries do not end with the file extension. e.g.
    // f_16a_block_10_norway. Normalise all of them to remove the extension
    // then add it back later.
    if (fmFilePath.endsWith(".blk")) {
      fmFilePath = fmFilePath.substring(0, fmFilePath.length - 4);
    }
    final fmFile = jsonDecode(
      await File(
        "$dataminePath\\aces.vromfs.bin_u\\gamedata\\flightmodels\\$fmFilePath.blkx",
      ).readAsString(),
    ) as Map<String, dynamic>;

    final vneMne = _getVneMne(fmFile);

    return AircraftData(
      vne: vneMne.$1,
      mne: vneMne.$2,
      vle: fmFile["Mass"]["GearDestructionIndSpeed"] as double,
      flapSettings: _getFlaps(fmFile),
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

extension _LerpEx on List<(double, double)> {
  double lerp(double x) {
    int index = -1;
    for (int i = 0; i < this.length; i++) {
      if (this[i].$1 >= x) {
        index = i;
        break;
      }

      if (i == length - 1) {
        // Some planes like the j6k1 have the last entry in the table at a
        // lower flap position. In that case we use the last speed to match
        // the value shown in the wiki.
        return last.$2;
      }
    }

    // Some planes like a_10a_early have the first point in the destruction
    // speed table defined at a flap setting later than the first flap position.
    // In that case we match the wiki behaviour and use the speed from the first
    // point.
    if (index == 0) {
      return this[0].$2;
    }

    final t = (x - this[index - 1].$1) / (this[index].$1 - this[index - 1].$1);
    final a = this[index - 1].$2;
    final b = this[index].$2;
    return a * (1.0 - t) + b * t;
  }
}

extension _NullableObjectExtension on Object {
  /// If the target is [T], return it, otherwise `null`.
  T? ifTypeOrNull<T>() {
    var self = this;
    return self is T ? self as T : null;
  }
}
