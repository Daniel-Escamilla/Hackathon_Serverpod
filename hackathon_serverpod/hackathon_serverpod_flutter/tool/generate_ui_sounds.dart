// Synthesises the app's UI sounds into assets/sounds/. Run from the Flutter
// package:
//
//   dart run tool/generate_ui_sounds.dart
//
// Every sound is generated here from plain sine waves, so there is nothing to
// license and nothing third-party in the demo video (the hackathon rules ask
// for a video free of third-party music). To change how something sounds, edit
// its recipe below and run the script again; the app picks up the new file.
//
// The character is Playful UI (docs/DESIGN.md): short, round and cheerful —
// pops, chimes and a coin "bling" — never beeps. Nothing here is longer than
// half a second, because a UI sound that outlasts the tap feels like lag.

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const _sampleRate = 44100;

void main() {
  final out = Directory('assets/sounds')..createSync(recursive: true);

  final sounds = <String, List<double>>{
    // A bubbly pop for pressing a button: a short upward pitch sweep.
    'tap': _sweep(from: 520, to: 980, ms: 70, volume: .55),
    // Something went right: a quick rising major arpeggio, C6 E6 G6.
    'success': _mix([
      _note(1046.5, ms: 110, start: 0, volume: .5),
      _note(1318.5, ms: 110, start: 75, volume: .5),
      _note(1568.0, ms: 220, start: 150, volume: .55),
    ]),
    // Coins in: the two-note "bling" every game uses, B5 then E6, with a
    // touch of odd harmonics for the retro coin edge.
    'coin': _mix([
      _note(987.8, ms: 80, start: 0, volume: .45, bright: true),
      _note(1318.5, ms: 280, start: 70, volume: .5, bright: true),
    ]),
    // Coins out as a fine: a small descending "womp", sad but not alarming.
    'fine': _mix([
      _note(392.0, ms: 170, start: 0, volume: .5, droop: .04),
      _note(311.1, ms: 260, start: 150, volume: .5, droop: .08),
    ]),
    // Something went wrong: a soft "bonk", low and short.
    'error': _sweep(from: 240, to: 150, ms: 160, volume: .6),
  };

  for (final MapEntry(key: name, value: samples) in sounds.entries) {
    final file = File('${out.path}/$name.wav')
      ..writeAsBytesSync(_wav(_normalise(samples)));
    stdout.writeln(
      '${file.path}  ${(samples.length / _sampleRate * 1000).round()} ms',
    );
  }
}

/// A sine whose pitch glides from [from] to [to] Hz — the shape of a "pop" when
/// it rises, of a "bonk" when it falls.
List<double> _sweep({
  required double from,
  required double to,
  required int ms,
  required double volume,
}) {
  final n = _samples(ms);
  var phase = 0.0;
  return List.generate(n, (i) {
    final t = i / n;
    final hz = from + (to - from) * sqrt(t);
    phase += 2 * pi * hz / _sampleRate;
    return sin(phase) * _envelope(i, n, attackMs: 3) * volume;
  });
}

/// A bell-like note: the fundamental plus a quieter octave, decaying. [bright]
/// adds odd harmonics for a squarer, more game-like tone; [droop] bends the
/// pitch down by that fraction over the note, for the "womp".
List<double> _note(
  double hz, {
  required int ms,
  required int start,
  required double volume,
  bool bright = false,
  double droop = 0,
}) {
  final n = _samples(ms);
  final offset = _samples(start);
  var phase = 0.0;
  final note = List.generate(n, (i) {
    final bend = 1 - droop * (i / n);
    phase += 2 * pi * hz * bend / _sampleRate;
    var s = sin(phase) + .3 * sin(2 * phase);
    if (bright) s += .25 * sin(3 * phase) + .12 * sin(5 * phase);
    return s * _envelope(i, n, attackMs: 4) * volume;
  });
  return [...List.filled(offset, 0.0), ...note];
}

/// A quick attack and an exponential tail, with a short fade at the very end
/// so no sound ends on a click.
double _envelope(int i, int n, {required int attackMs}) {
  final attack = _samples(attackMs);
  final rise = i < attack ? i / attack : 1.0;
  final decay = exp(-4.0 * i / n);
  final tail = n - i < 64 ? (n - i) / 64 : 1.0;
  return rise * decay * tail;
}

List<double> _mix(List<List<double>> parts) {
  final length = parts.map((p) => p.length).reduce(max);
  return List.generate(
    length,
    (i) => parts.fold(0.0, (sum, p) => sum + (i < p.length ? p[i] : 0.0)),
  );
}

/// Scales the loudest sample to 80% of full range, so every sound sits at the
/// same level and none of them clips.
List<double> _normalise(List<double> samples) {
  final peak = samples.map((s) => s.abs()).reduce(max);
  return samples.map((s) => s / peak * .8).toList();
}

int _samples(int ms) => (_sampleRate * ms / 1000).round();

/// 16-bit mono PCM in a WAV container.
Uint8List _wav(List<double> samples) {
  final data = ByteData(44 + samples.length * 2);
  void ascii(int at, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(at + i, s.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  data.setUint32(4, 36 + samples.length * 2, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little); // PCM
  data.setUint16(22, 1, Endian.little); // mono
  data.setUint32(24, _sampleRate, Endian.little);
  data.setUint32(28, _sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  ascii(36, 'data');
  data.setUint32(40, samples.length * 2, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    final v = (samples[i].clamp(-1.0, 1.0) * 32767).round();
    data.setInt16(44 + i * 2, v, Endian.little);
  }
  return data.buffer.asUint8List();
}
