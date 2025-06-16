#!/usr/bin/env bash
###############################################################################
# bootstrap.sh v3.1 — resilient install, safe Husky hooks
###############################################################################
set -euo pipefail
trap 'rm -f "$TMP_NPMRC"' EXIT INT TERM

NODE_VERSION="$(cat .nvmrc)"
WIX_CLI=@wix/cli@latest

echo -e "\e[34m🔄  Ensuring nvm + Node $NODE_VERSION\e[0m"
if ! command -v nvm &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
fi
nvm install "$NODE_VERSION" --silent
nvm use     "$NODE_VERSION" --silent
echo -e "\e[32m✔  $(node -v) / npm $(npm -v)\e[0m"

###############################################################################
# 1. temporary “defensive” npmrc (avoid duplicate proxy warnings)
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

declare -A _seen_proxy
for v in HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
  val=${!v:-}
  [[ -z "$val" ]] && continue
  case ${v,,} in
    http_proxy)  key=proxy ;;
    https_proxy) key=https-proxy ;;
    *)           key=${v,,} ;;
  esac
  if [[ -z "${_seen_proxy[$key]:-}" ]]; then
    echo "$key=$val" >>"$TMP_NPMRC"
    _seen_proxy[$key]=1
  fi
done
unset npm_config_http_proxy npm_config_https_proxy
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
# 4. Husky + lint-staged + commitlint (Git repos only)
###############################################################################
if git rev-parse --is-inside-work-tree &>/dev/null; then
  echo -e "\e[34m🔧  configuring Husky hooks\e[0m"
  npm install -D husky lint-staged @commitlint/cli @commitlint/config-conventional --silent

  # bootstrap Husky (v9+)
  npx --yes husky >/dev/null

  # hooks
  npx --yes husky add .husky/pre-commit "npx lint-staged"
  npx --yes husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'

  # run Husky after each install
  npm pkg set scripts.prepare="husky"
else
  echo -e "\e[33mℹ  not a Git repo → skipping Husky setup\e[0m"
fi

echo -e "\e[32m✅  Bootstrap complete. Run \e[1mwix preview\e[0m"
