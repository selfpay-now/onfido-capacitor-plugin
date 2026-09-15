/**
 * Builds the plugin, packs it exactly as npm would publish it, and drops the result
 * straight into a Capacitor app's node_modules.
 *
 * Usage: node scripts/install-local.mjs <path-to-capacitor-app>
 *        npm run install:local -- C:\Work\solution\src\mythril
 *
 * package.json / package-lock.json of the target app are left untouched, so nothing
 * local-only can leak into a commit. Re-run after every plugin change; a plain
 * `npm install` in the app restores the published version.
 */
import { execFileSync } from 'node:child_process';
import { copyFileSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const pluginDir = resolve(fileURLToPath(new URL('..', import.meta.url)));
const { name } = JSON.parse(readFileSync(join(pluginDir, 'package.json'), 'utf8'));

const appDir = resolve(process.argv[2] ?? '');
if (!process.argv[2] || !existsSync(join(appDir, 'node_modules'))) {
  console.error('Usage: node scripts/install-local.mjs <path-to-capacitor-app>');
  process.exit(1);
}

const run = (cmd, args, cwd) => execFileSync(cmd, args, { cwd, stdio: 'inherit', shell: process.platform === 'win32' });

console.log(`\n> building ${name}`);
run('npm', ['run', 'build'], pluginDir);

const staging = mkdtempSync(join(tmpdir(), 'selfpay-plugin-'));
console.log(`\n> packing ${name}`);
const tarball = execFileSync('npm', ['pack', '--silent', '--pack-destination', staging], {
  cwd: pluginDir,
  encoding: 'utf8',
  shell: process.platform === 'win32'
})
  .trim()
  .split('\n')
  .pop();

const target = join(appDir, 'node_modules', ...name.split('/'));
console.log(`\n> installing into ${target}`);
rmSync(target, { recursive: true, force: true });
mkdirSync(target, { recursive: true });
// The tarball is copied next to the extraction point and referenced by bare filename:
// GNU tar (the one Git Bash puts on PATH) reads the drive letter in "C:\..." as a remote
// host and fails, while a relative path works with both GNU tar and Windows' bsdtar.
copyFileSync(join(staging, tarball), join(target, tarball));
run('tar', ['-xzf', tarball, '--strip-components=1'], target);
rmSync(join(target, tarball), { force: true });
rmSync(staging, { recursive: true, force: true });

console.log(`\nDone. Now run "npx cap sync android" (or ios) inside ${appDir}.`);
