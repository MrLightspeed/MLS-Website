#!/usr/bin/env bash
###############################################################################
# bootstrap.sh v3 — resilient install + safe Husky hooks
###############################################################################
set -euo pipefail
trap 'rm -f "$TMP_NPMRC"' EXIT INT TERM

NODE_VERSION=22
WIX_CLI=@wix/cli@latest

echo -e "\e[34m🔄  Ensuring nvm + Node $NODE_VERSION\e[0m"
if ! command -v nvm &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
fi
nvm install "$NODE_VERSION" --silent
nvm use     "$NODE_VERSION" --silent
echo -e "\e[32m✔  $(node -v) / npm $(npm -v)\e[0m"

###############################################################################
# 1. temporary “defensive” npmrc (no duplicate proxy env warnings)
###############################################################################
TMP_NPMRC="$(mktemp)"
cat >"$TMP_NPMRC" <<'EOF'
strict-ssl=false
registry=http://registry.npmjs.org/
fetch-retries=5
fetch-retry-factor=2
fetch-retry-maxtimeout=60000
prefer-offline=true
EOF
# copy proxy vars **only once** (npm 11 hates duplicates)
for v in HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
  [[ -n "${!v:-}" ]] && echo "${v,,}=${!v}" >>"$TMP_NPMRC"   # lower-case key
done
export npm_config_userconfig="$TMP_NPMRC"

###############################################################################
# 2. resilient npm ci
###############################################################################
echo -e "\e[34m📦  npm ci (1st try)…\e[0m"
if ! npm ci --silent 2>&1 | tee /tmp/npm.log; then
  echo -e "\e[33m↻  retry with IPv4 + legacy-openssl...\e[0m"
  export NODE_OPTIONS="--openssl-legacy-provider"
  npm ci --silent --network-timeout=600000 --registry=http://registry.npmjs.org/
fi
echo -e "\e[32m✔  deps installed\e[0m"

###############################################################################
# 3. Wix CLI
###############################################################################
echo -e "\e[34m🌐  npm i -g $WIX_CLI\e[0m"
npm install -g "$WIX_CLI" --silent

###############################################################################
# 4. Husky + lint-staged + commitlint  (only if this is a Git repo)
###############################################################################
if git rev-parse --is-inside-work-tree &>/dev/null; then
  echo -e "\e[34m🔧  configuring Husky hooks\e[0m"
  # install husky dev-dep once
  npm install -D husky lint-staged @commitlint/{cli,config-conventional} --silent
  npx --yes husky init >/dev/null          # sets up .husky + pre-commit template
  npx husky set .husky/pre-commit "npx lint-staged"
  npx husky set .husky/commit-msg 'npx --no -- commitlint --edit "$1"'
  npm pkg set scripts.prepare="husky install"
else
  echo -e "\e[33mℹ  not a Git repo → skipping Husky setup\e[0m"
fi

echo -e "\e[32m✅  Bootstrap complete — run \e[1mwix preview\e[0m!"
