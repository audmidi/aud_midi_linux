// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// ignore_for_file: avoid_print

import 'package:aud_midi_core/aud_midi_core.dart';
import 'package:aud_midi_linux/aud_midi_linux.dart';
import 'package:aud_midi_standard/aud_midi_standard.dart';

// Runs on Linux with the ALSA sequencer (libasound.so.2).
Future<void> main() async {
  // List the ports of the other sequencer clients
  final engine = MidiEngine(backend: LinuxMidiBackend(clientName: 'My App'));
  await engine.open();
  for (final port in engine.ports) {
    print('${port.direction.name}: ${port.name} (${port.id})');
  }

  // Create a virtual output and schedule a note on it in 100 ms
  final out = await engine.createVirtualPort(
    MidiVirtualPortSpec(name: 'My App Out', direction: MidiDirection.output),
  );
  await engine.openOutput(out.id);
  await engine.send(
    out.id,
    const MidiNoteOn(channel: 0, note: 60, velocity: 100),
    at: engine.clock.now() + const Duration(milliseconds: 100),
  );
  await engine.close();
}
