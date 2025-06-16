const { spawnSync } = require('child_process');

const isCI = process.env.CI;
const isTTY = process.stdout.isTTY;

if (!isCI && isTTY) {
  const result = spawnSync('npx', ['wix', 'sync-types'], { stdio: 'inherit' });
  if (result.status !== 0) {
    process.exit(result.status);
  }
} else {
  console.log('Skipping `wix sync-types` due to non-interactive environment');
}
