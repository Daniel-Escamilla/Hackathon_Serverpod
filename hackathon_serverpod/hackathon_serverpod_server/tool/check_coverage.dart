// Runs the test suite with coverage, regenerates a line-by-line HTML report
// (which lines a test actually hit, which it didn't — like Codecov's file
// view, but local and self-styled) and fails if hand-written code
// (lib/src/**, excluding the generated/ subtree) drops below _minPercent.
// Re-run this any time after changing code or tests to refresh both.
//
//   dart run tool/check_coverage.dart
//
// Needs `coverage` activated globally once: `dart pub global activate coverage`.
import 'dart:convert';
import 'dart:io';

const _minPercent = 75.0;

class _FileCoverage {
  _FileCoverage(this.path);

  final String path;
  final Map<int, int> hitsByLine = {}; // 1-based line -> times hit

  int get found => hitsByLine.length;
  int get hit => hitsByLine.values.where((h) => h > 0).length;
  double get pct => found == 0 ? 0 : 100 * hit / found;
}

void main() {
  _run('dart', ['test', '--coverage=coverage']);
  _run('dart', [
    'pub',
    'global',
    'run',
    'coverage:format_coverage',
    '--lcov',
    '--in=coverage',
    '--out=coverage/lcov.info',
    '--package=.',
    '--report-on=lib/src',
  ]);

  final files = _parseLcov('coverage/lcov.info');
  final sorted = files.values.toList()..sort((a, b) => a.pct.compareTo(b.pct));

  final totalHit = sorted.fold(0, (s, f) => s + f.hit);
  final totalFound = sorted.fold(0, (s, f) => s + f.found);
  final totalPct = totalFound > 0 ? 100 * totalHit / totalFound : 0.0;

  for (final f in sorted) {
    final relative = f.path.replaceFirst('${Directory.current.path}/', '');
    final pctLabel = '${f.pct.toStringAsFixed(1)}%'.padLeft(6);
    final linesLabel = '${f.hit}/${f.found}'.padRight(9);
    stdout.writeln('$pctLabel  $linesLabel $relative');
  }
  stdout.writeln(
    '\nTOTAL: ${totalPct.toStringAsFixed(1)}% ($totalHit/$totalFound líneas)',
  );

  _writeHtmlReport(sorted, totalHit: totalHit, totalFound: totalFound);
  final indexPath = File('coverage/html/index.html').absolute.path;
  stdout.writeln('📄 Reporte línea a línea: file://$indexPath');

  if (totalPct < _minPercent) {
    stderr.writeln(
      '\n❌ Cobertura ${totalPct.toStringAsFixed(1)}% por debajo del '
      'mínimo de $_minPercent%.',
    );
    exit(1);
  }
  stdout.writeln('\n✅ Por encima del mínimo de $_minPercent%.');
}

void _run(String executable, List<String> args) {
  final result = Process.runSync(executable, args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) exit(result.exitCode);
}

Map<String, _FileCoverage> _parseLcov(String lcovPath) {
  final files = <String, _FileCoverage>{};
  _FileCoverage? current;

  for (final line in File(lcovPath).readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3);
      if (path.contains('/generated/')) {
        current = null;
        continue;
      }
      current = files.putIfAbsent(path, () => _FileCoverage(path));
    } else if (line.startsWith('DA:') && current != null) {
      final parts = line.substring(3).split(',');
      current.hitsByLine[int.parse(parts[0])] = int.parse(parts[1]);
    } else if (line == 'end_of_record') {
      current = null;
    }
  }
  return files;
}

// ---------------------------------------------------------------------------
// HTML report
// ---------------------------------------------------------------------------

const _css = '''
:root{
  --ink:#14181c; --ink-soft:#5b6470; --paper:#f6f5f1; --surface:#ffffff;
  --line:#e2ddd2; --accent:#2f6f6b; --accent-soft:#dbe9e6;
  --good:#2f8f5b; --good-soft:#e3f3e9; --good-line:#bfe4cd;
  --bad:#c1483c; --bad-soft:#fbeae7; --bad-line:#f3c9c1;
  --shadow:0 1px 2px rgba(20,24,28,.06),0 8px 24px -12px rgba(20,24,28,.18);
  --tok-keyword:#0000ff; --tok-control:#af00db; --tok-type:#267f99;
  --tok-string:#a31515; --tok-number:#098658; --tok-comment:#008000;
  --tok-call:#795e26;
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --ink:#eceeee; --ink-soft:#9aa4ac; --paper:#10151a; --surface:#171e24;
  --line:#29333b; --accent:#7ad4cb; --accent-soft:#1c3532;
  --good:#62cf8f; --good-soft:#152920; --good-line:#264a35;
  --bad:#f08272; --bad-soft:#2e1c19; --bad-line:#4a2b26;
  --shadow:0 1px 2px rgba(0,0,0,.3),0 12px 30px -14px rgba(0,0,0,.6);
  --tok-keyword:#569cd6; --tok-control:#c586c0; --tok-type:#4ec9b0;
  --tok-string:#ce9178; --tok-number:#b5cea8; --tok-comment:#6a9955;
  --tok-call:#dcdcaa;
}}
:root[data-theme="dark"]{
  --ink:#eceeee; --ink-soft:#9aa4ac; --paper:#10151a; --surface:#171e24;
  --line:#29333b; --accent:#7ad4cb; --accent-soft:#1c3532;
  --good:#62cf8f; --good-soft:#152920; --good-line:#264a35;
  --bad:#f08272; --bad-soft:#2e1c19; --bad-line:#4a2b26;
  --shadow:0 1px 2px rgba(0,0,0,.3),0 12px 30px -14px rgba(0,0,0,.6);
  --tok-keyword:#569cd6; --tok-control:#c586c0; --tok-type:#4ec9b0;
  --tok-string:#ce9178; --tok-number:#b5cea8; --tok-comment:#6a9955;
  --tok-call:#dcdcaa;
}
*{box-sizing:border-box}
body{margin:0;background:var(--paper);color:var(--ink);
  font-family:"Sora",ui-sans-serif,system-ui,-apple-system,sans-serif}
.mono{font-family:"JetBrains Mono",ui-monospace,"SFMono-Regular",Menlo,Consolas,monospace;
  font-variant-numeric:tabular-nums}
a{color:var(--accent);text-decoration:none}
a:hover{text-decoration:underline}
.wrap{max-width:720px;margin-inline:auto;padding:32px 20px 48px}
.eyebrow{font-family:"JetBrains Mono",monospace;font-size:11px;letter-spacing:.14em;
  text-transform:uppercase;color:var(--accent);font-weight:600}
h1{margin:6px 0 4px;font-size:clamp(28px,5vw,38px);font-weight:700;letter-spacing:-.02em}
.sub{color:var(--ink-soft);font-size:14.5px;max-width:52ch;margin-bottom:20px}
.sub code{font-family:"JetBrains Mono",monospace;font-size:13px;
  background:var(--accent-soft);color:var(--accent);padding:1px 6px;border-radius:5px}
.card{background:var(--surface);border:1px solid var(--line);border-radius:16px;
  box-shadow:var(--shadow);overflow:hidden}
.row{display:flex;align-items:center;gap:14px;padding:12px 16px;
  border-bottom:1px solid var(--line);text-decoration:none;color:inherit}
.row:last-child{border-bottom:none}
.row:hover{background:var(--accent-soft)}
.row-path{flex:0 0 168px;font-size:12.5px;color:var(--ink-soft);overflow-wrap:anywhere}
.row-path b{color:var(--ink);font-weight:600;display:block}
.bar-track{flex:1 1 auto;min-width:60px;height:8px;border-radius:5px;
  background:var(--line);overflow:hidden}
.bar-fill{display:block;height:100%;width:0;border-radius:5px;
  transition:width .9s cubic-bezier(.22,.9,.3,1)}
.row-pct{flex:0 0 52px;text-align:right;font-size:13px;font-weight:600}
.row-pill{flex:0 0 auto;font-size:10.5px;font-weight:600;padding:3px 8px;
  border-radius:999px;white-space:nowrap}
.row-pill.bad{background:var(--bad-soft);color:var(--bad)}
.row-pill.ok{background:var(--accent-soft);color:var(--accent)}
.row-pill.good{background:var(--good-soft);color:var(--good)}
.badge{display:inline-flex;align-items:center;gap:6px;font-size:12.5px;
  color:var(--ink-soft);margin-bottom:18px}
.dot{width:9px;height:9px;border-radius:3px;display:inline-block}
.gauge-card{background:var(--surface);border:1px solid var(--line);border-radius:20px;
  box-shadow:var(--shadow);padding:28px;display:flex;align-items:center;gap:28px;
  flex-wrap:wrap;margin-bottom:20px}
.gauge-wrap{position:relative;width:150px;height:150px;flex:0 0 auto}
.gauge-wrap svg{width:100%;height:100%;overflow:visible}
.gauge-track{fill:none;stroke:var(--line);stroke-width:13}
.gauge-fill{fill:none;stroke:var(--accent);stroke-width:13;stroke-linecap:round;
  transform-origin:50% 50%;transform:rotate(-90deg);
  stroke-dasharray:100 100;stroke-dashoffset:100;
  transition:stroke-dashoffset 1s cubic-bezier(.22,.9,.3,1),stroke .4s ease}
.gauge-threshold{position:absolute;top:50%;left:50%;width:2px;height:20px;
  background:var(--ink-soft);opacity:.55;border-radius:1px;
  transform-origin:50% -55px;transform:translate(-50%,-75px) rotate(270deg)}
.gauge-center{position:absolute;inset:0;display:flex;flex-direction:column;
  align-items:center;justify-content:center;text-align:center}
.gauge-pct{font-size:28px;font-weight:700;letter-spacing:-.01em}
.gauge-frac{font-size:12px;color:var(--ink-soft);margin-top:2px}
.gauge-legend{display:flex;flex-direction:column;gap:9px;min-width:170px;flex:1 1 200px}
.gauge-legend .headline{font-size:14.5px;font-weight:600}
.legend-row{display:flex;align-items:center;gap:8px;font-size:12.5px;color:var(--ink-soft)}
.legend-swatch{width:10px;height:10px;border-radius:3px;flex:0 0 auto;display:inline-block}
.list-head{display:flex;justify-content:space-between;align-items:baseline;
  padding:14px 16px 10px;border-bottom:1px solid var(--line);font-size:14px;font-weight:600}
.list-head span{font-size:12px;color:var(--ink-soft);font-weight:400}
@media (prefers-reduced-motion:reduce){.gauge-fill,.bar-fill{transition:none!important}}
.file-head{display:flex;align-items:baseline;justify-content:space-between;
  flex-wrap:wrap;gap:10px;margin-bottom:14px}
.file-head .pct{font-size:26px;font-weight:700}
.back{font-size:13px}
.legend{display:flex;gap:16px;font-size:12.5px;color:var(--ink-soft);margin-bottom:12px}
.legend span{display:inline-flex;align-items:center;gap:6px}
.source{font-size:12.5px;line-height:1.6;overflow-x:auto}
.l{display:flex;min-height:1.6em}
.l .num{flex:0 0 44px;text-align:right;padding-right:10px;color:var(--ink-soft);
  user-select:none;border-right:1px solid var(--line)}
.l .code{flex:1 1 auto;white-space:pre;padding-left:10px;border-left:3px solid transparent}
.l.cov{background:var(--good-soft)}
.l.cov .code{border-left-color:var(--good)}
.l.nocov{background:var(--bad-soft)}
.l.nocov .code{border-left-color:var(--bad)}
.tok-keyword{color:var(--tok-keyword)}
.tok-control{color:var(--tok-control)}
.tok-type{color:var(--tok-type)}
.tok-string{color:var(--tok-string)}
.tok-number{color:var(--tok-number)}
.tok-comment{color:var(--tok-comment);font-style:italic}
.tok-call,.tok-annotation{color:var(--tok-call)}
@media (max-width:460px){.row{flex-wrap:wrap}.row-path{flex-basis:100%}}
''';

String _escape(String s) => const HtmlEscape(HtmlEscapeMode.element).convert(s);

// A deliberately simple, line-by-line Dart tokenizer — good enough to color
// keywords/strings/types/comments like an editor, not a real parser. Misses
// multi-line block comments and raw/multi-line strings; this codebase uses
// neither.
const _controlKeywords = {
  'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break',
  'continue', 'return', 'throw', 'try', 'catch', 'finally', 'in', 'is', 'as',
  'yield', //
};
const _storageKeywords = {
  'class', 'extends', 'implements', 'with', 'mixin', 'enum', 'abstract',
  'final', 'const', 'var', 'void', 'dynamic', 'late', 'required', 'factory',
  'get', 'set', 'async', 'await', 'import', 'export', 'library', 'part',
  'typedef', 'new', 'this', 'super', 'true', 'false', 'null', 'covariant',
  'external', 'operator', 'on', 'show', 'hide', 'deferred', 'static', //
};

bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
bool _isWordStart(String c) => RegExp(r'[A-Za-z_$]').hasMatch(c);
bool _isWordChar(String c) => RegExp(r'[A-Za-z0-9_$]').hasMatch(c);

String? _classify(String word, {required bool isCall}) {
  if (_controlKeywords.contains(word)) return 'control';
  if (_storageKeywords.contains(word)) return 'keyword';
  if (isCall) return 'call';
  final first = word[0];
  if (first == first.toUpperCase() && first != first.toLowerCase()) {
    return 'type';
  }
  return null;
}

String _highlightLine(String line) {
  final out = StringBuffer();
  final n = line.length;
  var i = 0;
  while (i < n) {
    final c = line[i];

    if (c == '/' && i + 1 < n && line[i + 1] == '/') {
      out.write(
        '<span class="tok-comment">${_escape(line.substring(i))}</span>',
      );
      break;
    }

    if (c == "'" || c == '"') {
      var j = i + 1;
      while (j < n) {
        if (line[j] == r'\' && j + 1 < n) {
          j += 2;
          continue;
        }
        if (line[j] == c) {
          j++;
          break;
        }
        j++;
      }
      out.write(
        '<span class="tok-string">${_escape(line.substring(i, j))}</span>',
      );
      i = j;
      continue;
    }

    if (c == '@' && i + 1 < n && _isWordStart(line[i + 1])) {
      var j = i + 1;
      while (j < n && _isWordChar(line[j])) {
        j++;
      }
      out.write(
        '<span class="tok-annotation">${_escape(line.substring(i, j))}</span>',
      );
      i = j;
      continue;
    }

    if (_isDigit(c)) {
      var j = i;
      while (j < n && (_isDigit(line[j]) || line[j] == '.')) {
        j++;
      }
      out.write(
        '<span class="tok-number">${_escape(line.substring(i, j))}</span>',
      );
      i = j;
      continue;
    }

    if (_isWordStart(c)) {
      var j = i;
      while (j < n && _isWordChar(line[j])) {
        j++;
      }
      final word = line.substring(i, j);
      var k = j;
      while (k < n && line[k] == ' ') {
        k++;
      }
      final isCall = k < n && line[k] == '(';
      final cls = _classify(word, isCall: isCall);
      out.write(
        cls == null
            ? _escape(word)
            : '<span class="tok-$cls">${_escape(word)}</span>',
      );
      i = j;
      continue;
    }

    out.write(_escape(c));
    i++;
  }
  return out.toString();
}

String _tierColor(double pct) {
  if (pct < _minPercent) return 'var(--bad)';
  if (pct >= 90) return 'var(--good)';
  return 'var(--accent)';
}

String _tierClass(double pct) {
  if (pct < _minPercent) return 'bad';
  if (pct >= 90) return 'good';
  return 'ok';
}

String _tierLabel(double pct) {
  if (pct < _minPercent) return 'bajo mínimo';
  if (pct >= 90) return 'sólido';
  return 'por encima del mínimo';
}

const _fontsLink =
    '<link rel="preconnect" href="https://fonts.googleapis.com">'
    '<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700'
    '&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">';

void _writeHtmlReport(
  List<_FileCoverage> files, {
  required int totalHit,
  required int totalFound,
}) {
  final outDir = Directory('coverage/html')..createSync(recursive: true);
  final totalPct = totalFound > 0 ? 100 * totalHit / totalFound : 0.0;
  final root = Directory.current.path;

  final rows = files
      .map((f) {
        final relative = f.path.replaceFirst('$root/', '');
        final slug = relative.replaceAll('/', '_');
        final slash = relative.lastIndexOf('/');
        final dir = slash < 0 ? '' : relative.substring(0, slash + 1);
        final filename = slash < 0 ? relative : relative.substring(slash + 1);
        return '''
<a class="row" href="$slug.html">
  <span class="row-path mono"><b>$filename</b>$dir</span>
  <span class="bar-track"><span class="bar-fill" data-target="${f.pct.toStringAsFixed(1)}" style="background:${_tierColor(f.pct)}"></span></span>
  <span class="row-pct mono">${f.pct.toStringAsFixed(1)}%</span>
  <span class="row-pill ${_tierClass(f.pct)}">${_tierLabel(f.pct)}</span>
</a>''';
      })
      .join('\n');

  File('${outDir.path}/index.html').writeAsStringSync('''
<!doctype html><html><head><meta charset="utf-8">
<title>Mapa de cobertura</title><style>$_css</style>$_fontsLink</head><body><div class="wrap">
<div class="eyebrow">Cobertura local · hackathon_serverpod_server</div>
<h1>Mapa de cobertura</h1>
<div class="sub">Instantánea de <code>lib/src/**</code> (sin <code>generated/</code>), generada con
<code>dart run tool/check_coverage.dart</code>. Umbral mínimo: ${_minPercent.toStringAsFixed(0)}%.</div>

<div class="gauge-card">
  <div class="gauge-wrap">
    <svg viewBox="0 0 100 100">
      <circle class="gauge-track" cx="50" cy="50" r="42" pathLength="100" />
      <circle class="gauge-fill" id="gaugeFill" cx="50" cy="50" r="42" pathLength="100" />
    </svg>
    <div class="gauge-threshold" title="Mínimo ${_minPercent.toStringAsFixed(0)}%"></div>
    <div class="gauge-center">
      <div class="gauge-pct mono" id="gaugePct">0%</div>
      <div class="gauge-frac mono">$totalHit / $totalFound</div>
    </div>
  </div>
  <div class="gauge-legend">
    <div class="headline">${files.length} archivos</div>
    <div class="legend-row"><span class="legend-swatch" style="background:var(--good)"></span> ≥ 90% · sólido</div>
    <div class="legend-row"><span class="legend-swatch" style="background:var(--accent)"></span> ≥ ${_minPercent.toStringAsFixed(0)}%</div>
    <div class="legend-row"><span class="legend-swatch" style="background:var(--bad)"></span> &lt; ${_minPercent.toStringAsFixed(0)}%</div>
    <div class="legend-row"><span class="legend-swatch" style="background:var(--ink-soft);opacity:.55"></span> marca gris · mínimo</div>
  </div>
</div>

<div class="card">
  <div class="list-head">Por archivo, de menor a mayor<span>$totalHit / $totalFound líneas</span></div>
  $rows
</div>
</div>
<script>
(function(){
  var totalPct = $totalPct;
  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var gaugeFill = document.getElementById('gaugeFill');
  var pctEl = document.getElementById('gaugePct');
  gaugeFill.style.stroke = '${_tierColor(totalPct)}';

  function playIn(){
    if (reduceMotion) {
      gaugeFill.style.strokeDashoffset = String(100 - totalPct);
      pctEl.textContent = totalPct.toFixed(1) + '%';
      document.querySelectorAll('.bar-fill').forEach(function(el){
        el.style.width = el.getAttribute('data-target') + '%';
      });
      return;
    }
    setTimeout(function(){ gaugeFill.style.strokeDashoffset = String(100 - totalPct); }, 0);
    var startTime = Date.now(), duration = 1000;
    function tick(){
      var p = Math.min(1, (Date.now() - startTime) / duration);
      var eased = 1 - Math.pow(1 - p, 3);
      pctEl.textContent = (eased * totalPct).toFixed(1) + '%';
      if (p < 1) setTimeout(tick, 16);
    }
    tick();
    document.querySelectorAll('.bar-fill').forEach(function(el, i){
      setTimeout(function(){ el.style.width = el.getAttribute('data-target') + '%'; }, 120 + i * 70);
    });
  }
  if (document.readyState === 'complete') { setTimeout(playIn, 30); }
  else { window.addEventListener('load', function(){ setTimeout(playIn, 30); }); }
})();
</script>
</body></html>''');

  for (final f in files) {
    _writeFilePage(f, outDir.path, root);
  }
}

/// lcov only marks the line where a statement *starts*. A call or signature
/// that spans several lines (arguments, named params) would otherwise show
/// only its first line colored and the rest blank. This carries the status
/// of that first line down through the still-open `(`/`[` it started, so the
/// whole statement reads as one block — stopping as soon as those balance
/// back out, so it never bleeds into a following `{` body.
Map<int, String> _effectiveStatusByLine(_FileCoverage f, List<String> lines) {
  final effective = <int, String>{};
  var currentStatus = '';
  var runningDepth = 0;

  for (var i = 0; i < lines.length; i++) {
    final lineNo = i + 1;
    final hits = f.hitsByLine[lineNo];
    if (hits != null) {
      currentStatus = hits > 0 ? 'cov' : 'nocov';
      effective[lineNo] = currentStatus;
    } else if (runningDepth > 0 && currentStatus.isNotEmpty) {
      effective[lineNo] = currentStatus;
    }
    runningDepth += _bracketDelta(lines[i]);
    if (runningDepth < 0) runningDepth = 0;
  }
  return effective;
}

/// Net count of `(`/`[` minus `)`/`]` outside strings and `//` comments.
int _bracketDelta(String line) {
  var delta = 0;
  final n = line.length;
  var i = 0;
  while (i < n) {
    final c = line[i];
    if (c == '/' && i + 1 < n && line[i + 1] == '/') break;
    if (c == "'" || c == '"') {
      var j = i + 1;
      while (j < n) {
        if (line[j] == r'\' && j + 1 < n) {
          j += 2;
          continue;
        }
        if (line[j] == c) {
          j++;
          break;
        }
        j++;
      }
      i = j;
      continue;
    }
    if (c == '(' || c == '[') delta++;
    if (c == ')' || c == ']') delta--;
    i++;
  }
  return delta;
}

void _writeFilePage(_FileCoverage f, String outDirPath, String root) {
  final relative = f.path.replaceFirst('$root/', '');
  final slug = relative.replaceAll('/', '_');
  final sourceLines = File(f.path).readAsLinesSync();
  final effective = _effectiveStatusByLine(f, sourceLines);

  final buf = StringBuffer();
  for (var i = 0; i < sourceLines.length; i++) {
    final lineNo = i + 1;
    final cls = effective[lineNo] ?? '';
    buf.writeln(
      '<div class="l $cls"><span class="num">$lineNo</span>'
      '<span class="code mono">${_highlightLine(sourceLines[i])}</span></div>',
    );
  }

  File('$outDirPath/$slug.html').writeAsStringSync('''
<!doctype html><html><head><meta charset="utf-8">
<title>$relative</title><style>$_css</style>$_fontsLink</head><body><div class="wrap">
<a class="back" href="index.html">← todos los archivos</a>
<div class="file-head">
  <div>
    <div class="eyebrow mono">$relative</div>
    <h1 class="pct" style="color:${_tierColor(f.pct)}">${f.pct.toStringAsFixed(1)}%</h1>
  </div>
  <div class="sub mono">${f.hit} / ${f.found} líneas ejecutables</div>
</div>
<div class="legend">
  <span><span class="dot" style="background:var(--good)"></span> cubierta</span>
  <span><span class="dot" style="background:var(--bad)"></span> sin cubrir</span>
</div>
<div class="card"><div class="source">$buf</div></div>
</div></body></html>''');
}
