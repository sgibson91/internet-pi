#!/usr/bin/env bash
set -euo pipefail

# relies on yq being installed; upgrade path: inline python/grep fallback
config_file="config.yml"
[[ -f "$config_file" ]] || config_file="example.config.yml"

config_dir=$(yq -r '.config_dir' "$config_file")
config_dir="${config_dir/#\~/$HOME}"

for dir in "$config_dir"/*/; do
  [[ -d "$dir" ]] || continue
  echo "Updating: $dir"
  (cd "$dir" && docker compose pull && docker compose up -d --no-deps)
done

docker system prune --all -f
