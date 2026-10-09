#!/usr/bin/env bash
# Prints one markdown line per fork that is behind its upstream; empty output = all synced.
set -u
git init -q repo && cd repo
while read -r fork fb up ub; do
  [ -z "$fork" ] && continue
  if git fetch -q "https://github.com/$fork" "+$fb:f" && git fetch -q "https://github.com/$up" "+$ub:u"; then
    n=$(git rev-list --count f..u)
    if [ "$n" -gt 0 ]; then echo "- [ ] [$fork](https://github.com/$fork) — $n commits behind [$up](https://github.com/$up/commits/$ub)"; fi
  else
    echo "- [ ] $fork — could not fetch $fork or $up"
  fi
done < "${1:-/dev/stdin}"
