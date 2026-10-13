// Renders the brand sources in this folder into the app, like render.sh,
// but with Chrome alone: no Python, so it runs on Windows too.
//
//   logo.svg -> web/favicon.png, web/icons/Icon-{192,512}.png, web/logo.svg,
//               assets/brand/logo.svg (the welcome screen),
//               android/app/src/main/res/mipmap-*/ic_launcher.png
//            -> web/icons/Icon-maskable-{192,512}.png (full bleed, safe zone)
//   og.html  -> web/og.png, the 1200x630 link preview
//
// Each size is drawn by Chrome at that size, not scaled down from a big one.
// Usage: node tool/brand/render.mjs [path to chrome]
import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const app = path.resolve(here, '../..');
const web = path.join(app, 'web');
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'brand-'));

const chrome = process.argv[2] ?? [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  '/usr/bin/google-chrome',
  '/usr/bin/chromium',
].find((p) => fs.existsSync(p));
if (!chrome) throw new Error('Chrome not found: pass its path as the first argument.');

function shot(url, width, height, out) {
  execFileSync(chrome, [
    '--headless=new', '--disable-gpu', '--hide-scrollbars',
    '--default-background-color=00000000', '--force-device-scale-factor=1',
    `--window-size=${width},${height}`, `--screenshot=${out}`, url,
  ], { stdio: 'ignore' });
}

// The logo, drawn by Chrome at exactly `size` px.
function logoAt(svgFile, size, out) {
  const page = path.join(tmp, `logo-${size}.html`);
  fs.writeFileSync(page,
    `<!doctype html><html><body style="margin:0;background:transparent">` +
    `<img src="${pathToFileURL(svgFile)}" width="${size}" height="${size}" style="display:block"></body></html>`);
  shot(pathToFileURL(page).href, size, size, out);
}

const logo = path.join(here, 'logo.svg');
// The maskable icon: square tile, mark shrunk into the 80% safe circle.
const maskable = path.join(tmp, 'maskable.svg');
fs.writeFileSync(maskable, fs.readFileSync(logo, 'utf8')
  .replaceAll('rx="116"', 'rx="0"')
  .replace('<g id="mark">', '<g id="mark" transform="translate(256 256) scale(0.78) translate(-256 -256)">'));

for (const size of [192, 512]) {
  logoAt(logo, size, path.join(web, 'icons', `Icon-${size}.png`));
  logoAt(maskable, size, path.join(web, 'icons', `Icon-maskable-${size}.png`));
}
logoAt(logo, 48, path.join(web, 'favicon.png'));

const mipmaps = { mdpi: 48, hdpi: 72, xhdpi: 96, xxhdpi: 144, xxxhdpi: 192 };
for (const [density, size] of Object.entries(mipmaps)) {
  logoAt(logo, size, path.join(app, 'android/app/src/main/res', `mipmap-${density}`, 'ic_launcher.png'));
}

shot(pathToFileURL(path.join(here, 'og.html')).href, 1200, 630, path.join(web, 'og.png'));
fs.copyFileSync(logo, path.join(web, 'logo.svg'));
fs.copyFileSync(logo, path.join(app, 'assets/brand/logo.svg'));
fs.rmSync(tmp, { recursive: true, force: true });

// WhatsApp skips previews much over 300 KB.
const ogKb = Math.round(fs.statSync(path.join(web, 'og.png')).size / 1024);
console.log(`Rendered. og.png is ${ogKb} KB${ogKb > 300 ? ': over 300 KB, WhatsApp may skip it' : ''}.`);
