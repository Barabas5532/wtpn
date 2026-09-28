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
}
