#!/usr/bin/env bash
# Cloud agent build: enable PECL ext-mcrypt for ext-vs-compat PHPUnit parity tests.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

if ! php -m 2>/dev/null | grep -q '^mcrypt$'; then
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq
  if ! apt-cache show php8.4-mcrypt &>/dev/null 2>&1; then
    sudo apt-get install -y --no-install-recommends software-properties-common ca-certificates gnupg
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update -qq
  fi
  php_ver="$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')"
  sudo apt-get install -y --no-install-recommends "php${php_ver}-mcrypt"
fi

php -m | grep -q '^mcrypt$'

cd "$repo_root"
if [[ -f composer.json ]]; then
  composer install --no-interaction
fi
