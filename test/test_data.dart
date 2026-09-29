import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wtpn/data.dart';

void main() {
  test('Loads tail hook correctly', () {
    final uut = DataLoader();

    const noHookPlaneId = "spitfire_ix";
    const hookPlaneId = "seafire_fr47";

    expect(
      uut.load(noHookPlaneId),
      completion(
        isA<AircraftData>().having((d) => d.hasTailHook, "hasTailHook", false),
      ),
    );
    expect(
      uut.load(hookPlaneId),
      completion(
        isA<AircraftData>().having((d) => d.hasTailHook, "hasTailHook", true),
      ),
    );
  });

  test('Loads airbrake correctly', () {
    final uut = DataLoader();

    const noBrakePlaneId = "spitfire_ix";
    const brakePlaneId = "f_16a_block_10";

    expect(
      uut.load(noBrakePlaneId),
      completion(
        isA<AircraftData>().having((d) => d.hasAirbrake, "hasAirbrake", false),
      ),
    );
    expect(
      uut.load(brakePlaneId),
      completion(
        isA<AircraftData>().having((d) => d.hasAirbrake, "hasAirbrake", true),
      ),
    );
  });

  test('Loads chute correctly', () {
    final uut = DataLoader();

    const noChutePlaneId = "spitfire_ix";
    const chutePlaneId = "mig_25pd";

    expect(
      uut.load(noChutePlaneId),
      completion(
        isA<AircraftData>().having(
          (d) => d.hasDragChute,
          "hasDragChute",
          false,
        ),
      ),
    );
    expect(
      uut.load(chutePlaneId),
      completion(
        isA<AircraftData>().having((d) => d.hasDragChute, "hasDragChute", true),
      ),
    );
  });

  test('Loads all aircraft without errors', () {
    final uut = DataLoader();

    // Some planes are in development or otherwise not expected to work. These
    // are skipped by marking them with '//' in the file.
    final allPlaneIds = File("test/all_planes.txt")
        .readAsLinesSync()
        .where((i) => !i.startsWith('//'));

    for (final id in allPlaneIds) {
      expect(uut.load(id), completes);
    }
  });

  group("Loads flaps correctly", () {
    // Reference values came from the wiki
    test('when there are no flaps', () {
      final uut = DataLoader();
      final planeId = "a_129_a";

      expect(
        uut.load(planeId),
        completion(
          isA<AircraftData>().having(
            (d) => d.flapSettings,
            "flapSettings",
            isNull,
          ),
        ),
      );
    });

    test('when flaps are defined with 2 points', () {
      final uut = DataLoader();
      final planeId = "a_20g_30_ussr";

      expect(
        uut.load(planeId),
        completion(
          isA<AircraftData>().having(
            (d) => d.flapSettings,
            "flapSettings",
            equals([
              matchesFlapData(setting: FlapSetting.combat, vfe: 428),
              matchesFlapData(setting: FlapSetting.takeoff, vfe: 407),
              matchesFlapData(setting: FlapSetting.landing, vfe: 296),
            ]),
          ),
        ),
      );
    });

    test('when flaps are defined with many points', () {
      final uut = DataLoader();
      final planeId = "p-51a_tl";

      expect(
        uut.load(planeId),
        completion(
          isA<AircraftData>().having(
            (d) => d.flapSettings,
            "flapSettings",
            equals([
              matchesFlapData(setting: FlapSetting.combat, vfe: 652),
              matchesFlapData(setting: FlapSetting.takeoff, vfe: 521),
              matchesFlapData(setting: FlapSetting.landing, vfe: 279),
            ]),
          ),
        ),
      );
    });

    test('when flaps are defined only above a setting', () {
      final uut = DataLoader();
      final planeId = "a_10a_early";

      expect(
        uut.load(planeId),
        completion(
          isA<AircraftData>().having(
            (d) => d.flapSettings,
            "flapSettings",
            equals([
              matchesFlapData(setting: FlapSetting.takeoff, vfe: 740),
              matchesFlapData(setting: FlapSetting.landing, vfe: 370),
            ]),
          ),
        ),
      );
    });

    test('when flaps are defined only below a setting', () {
      final uut = DataLoader();
      final planeId = "j6k1";

      expect(
        uut.load(planeId),
        completion(
          isA<AircraftData>().having(
            (d) => d.flapSettings,
            "flapSettings",
            equals([
              matchesFlapData(setting: FlapSetting.combat, vfe: 460),
              matchesFlapData(setting: FlapSetting.takeoff, vfe: 382),
              matchesFlapData(setting: FlapSetting.landing, vfe: 280),
            ]),
          ),
        ),
      );
    });

    test(
      'when flaps are defined with a single value probably incorrectly',
      () {},
      skip: true,
    );
  });

  test('Loads auto flaps correctly', () {
    final uut = DataLoader();

    const noAutoFlapsPlaneId = "spitfire_ix";
    const autoFlapsPlaneId = "tempest_mk2";

    expect(
      uut.load(noAutoFlapsPlaneId),
      completion(
        isA<AircraftData>().having(
          (d) => d.hasAutoFlaps,
          "hasAutoFlaps",
          false,
        ),
      ),
    );
    expect(
      uut.load(autoFlapsPlaneId),
      completion(
        isA<AircraftData>().having((d) => d.hasAutoFlaps, "hasAutoFlaps", true),
      ),
    );
  });

  test('Loads reverse thrust correctly', () {
    final uut = DataLoader();

    const noReverseThrustPlaneId = "spitfire_ix";
    const reverseThrustPlaneId = "tornado_adv";

    expect(
      uut.load(noReverseThrustPlaneId),
      completion(
        isA<AircraftData>().having(
          (d) => d.hasReverseThrust,
          "hasReverseThrust",
          false,
        ),
      ),
    );
    expect(
      uut.load(reverseThrustPlaneId),
      completion(
        isA<AircraftData>().having(
          (d) => d.hasReverseThrust,
          "hasReverseThrust",
          true,
        ),
      ),
    );
  });

  test('Loads cobra button correctly', () {
    final uut = DataLoader();

    const noCobraButtonPlaneId = "spitfire_ix";
    const cobraButtonPlaneId = "mig_29_9_12g";

    expect(
      uut.load(noCobraButtonPlaneId),
      completion(
        isA<AircraftData>().having(
          (d) => d.hasCobraButton,
          "hasCobraButton",
          false,
        ),
      ),
    );
    expect(
      uut.load(cobraButtonPlaneId),
      completion(
        isA<AircraftData>().having(
          (d) => d.hasCobraButton,
          "hasCobraButton",
          true,
        ),
      ),
    );
  });
}

TypeMatcher<FlapData> matchesFlapData({
  required FlapSetting setting,
  required double vfe,
}) {
  return isA<FlapData>()
      .having((f) => f.setting, "setting", setting)
      .having((f) => f.vfe, "vfe", closeTo(vfe, 1));
}
