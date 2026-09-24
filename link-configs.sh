#!/usr/bin/env bash
# Make this repository the single source of truth for its managed XDG configs.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./link-configs.sh [--apply]

Without --apply, print the plan only. With --apply, for every managed path
that is present in ~/.config, this script:
  1. Backs up the repository and live copies.
  2. Mirrors the live copy into dots/.config (the live copy is authoritative).
  3. Replaces the live copy with a symlink to the repository.

Backups are stored under:
  ~/.local/state/dots-hyprland-link-backups/<timestamp>/

The script never commits or pushes Git changes.
EOF
}

apply=false
case "${1:-}" in
  "") ;;
  --apply) apply=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_config="$repo_root/dots/.config"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dots-hyprland-link-backups/$(date +%Y%m%d-%H%M%S)"
# Keep this small: only these paths become repository-backed symlinks.
managed_paths=(
  fish
  hypr
  illogical-impulse
  kitty
  nvim
  quickshell
  dolphinrc
  starship.toml
)

[[ -d "$repo_config" ]] || { printf 'Missing %s\n' "$repo_config" >&2; exit 1; }

run() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
  "$apply" || return 0
  "$@"
}

backup_and_link() {
  local repo_path="$1"
  local name live_path linked_target repo_backup live_backup

  name="$(basename -- "$repo_path")"
  live_path="$config_home/$name"
  repo_path="$(realpath -m -- "$repo_path")"

  if [[ -L "$live_path" ]]; then
    linked_target="$(realpath -m -- "$live_path")"
    if [[ "$linked_target" == "$repo_path" ]]; then
      printf 'already linked: %s\n' "$live_path"
      return
    fi
    printf 'Refusing existing unrelated symlink: %s -> %s\n' "$live_path" "$linked_target" >&2
    return 1
  fi

  if [[ -e "$live_path" ]]; then
    if [[ -d "$repo_path" && ! -d "$live_path" ]] || [[ -f "$repo_path" && ! -f "$live_path" ]]; then
      printf 'Type mismatch: %s and %s\n' "$repo_path" "$live_path" >&2
      return 1
    fi

    repo_backup="$backup_root/repo-before-sync/.config/$name"
    live_backup="$backup_root/live-before-link/.config/$name"
    run mkdir -p -- "$(dirname -- "$repo_backup")" "$(dirname -- "$live_backup")"
    run cp -a -- "$repo_path" "$repo_backup"

    # Mirror exactly: ~/.config is deliberately the newest configuration.
    if [[ -d "$live_path" ]]; then
      run rsync -a --delete -- "$live_path/" "$repo_path/"
    else
      run cp -a -- "$live_path" "$repo_path"
    fi

    run mv -- "$live_path" "$live_backup"
  else
    printf 'missing locally, retain repository copy: %s\n' "$live_path"
    run mkdir -p -- "$config_home"
  fi

  run ln -s -- "$repo_path" "$live_path"
}

printf 'Repository: %s\n' "$repo_root"
printf 'Live config: %s\n' "$config_home"
printf 'Backup root: %s\n' "$backup_root"
printf 'Mode: %s\n\n' "$($apply && printf apply || printf dry-run)"

for name in "${managed_paths[@]}"; do
  repo_path="$repo_config/$name"
  [[ -e "$repo_path" ]] || { printf 'Missing managed path: %s\n' "$repo_path" >&2; exit 1; }
  backup_and_link "$repo_path"
done

if "$apply"; then
  printf '\nDone. Review with: git -C %q status\n' "$repo_root"
else
  printf '\nDry run only. Re-run with --apply after reviewing the plan.\n'
fi
