#!/usr/bin/env bash
set -eu

cd /var/www/build
git config --global --add safe.directory /var/www/build
marker=.devpanel/init-container.sh
timestamp=$(date -u +%Y%m%dT%H%M%SZ)
nonce=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
stash_name="pre-image-sync-$timestamp-$nonce"
git stash push -m "$stash_name" -- "$marker"
stash_entries=$(git stash list --format='%H %gs')
stash_id=
while IFS= read -r stash_entry; do
  case "$stash_entry" in
    *": $stash_name") stash_id=${stash_entry%% *}; break ;;
  esac
done <<< "$stash_entries"

restore_marker() {
  status=$?
  trap - EXIT
  if [ -n "$stash_id" ]; then
    if ! git restore --source="$stash_id^2" --staged -- "$marker" ||
       ! git restore --source="$stash_id" --worktree -- "$marker"; then
      echo "Failed to restore $marker changes; stash $stash_id was retained." >&2
      exit 1
    fi
    if [ "$(git stash list -1 --format=%H)" = "$stash_id" ]; then
      git stash drop 'stash@{0}'
    else
      echo "Stash list changed; stash $stash_id was retained." >&2
    fi
  elif ! git restore --source=HEAD --staged --worktree -- "$marker"; then
    echo "Failed to restore $marker from HEAD." >&2
    exit 1
  fi
  exit "$status"
}
trap restore_marker EXIT
rm "$marker"
"$APP_ROOT"/.devpanel/init-container.sh
