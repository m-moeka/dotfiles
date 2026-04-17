#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
in_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
out_tokens=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // empty')
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

effort=""
for f in \
  "$cwd/.claude/settings.local.json" \
  "$cwd/.claude/settings.json" \
  "$HOME/.claude/settings.local.json" \
  "$HOME/.claude/settings.json"; do
  if [ -z "$effort" ] && [ -f "$f" ]; then
    val=$(jq -r '.effortLevel // empty' "$f" 2>/dev/null)
    [ -n "$val" ] && effort="$val"
  fi
done

sep='\033[90m │ \033[0m'

# Git branch
branch=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- Group 1: Location (white) ---
short_cwd=$(echo "$cwd" | awk -F/ '{print $(NF-1)"/"$NF}')
printf '\033[97m%s\033[0m' "$short_cwd"
if [ -n "$branch" ]; then
  printf ' \033[37m(%s)\033[0m' "$branch"
fi

# --- Group 2: Model & Rate (yellow) ---
has_group2=""
if [ -n "$model" ] || [ -n "$five_h" ]; then
  has_group2="1"
  printf "$sep"
fi
if [ -n "$model" ]; then
  printf '\033[93m%s\033[0m' "$model"
  if [ -n "$effort" ]; then
    printf '\033[33m[%s]\033[0m' "$effort"
  fi
fi
if [ -n "$five_h" ]; then
  # Color override for high usage
  pct=$(printf '%.0f' "$five_h")
  if [ "$pct" -ge 80 ]; then
    color="31" # red
  elif [ "$pct" -ge 50 ]; then
    color="33" # dark yellow
  else
    color="33" # dark yellow (normal)
  fi
  printf ' \033[%sm5h:%.0f%%\033[0m' "$color" "$five_h"
fi

# --- Group 3: Context (cyan) ---
if [ -n "$used_pct" ]; then
  printf "$sep"
  printf '\033[96mctx:%.0f%%\033[0m' "$used_pct"
  if [ -n "$in_tokens" ] && [ -n "$out_tokens" ]; then
    in_k=$(awk "BEGIN{printf \"%.1fk\", $in_tokens/1000}")
    out_k=$(awk "BEGIN{printf \"%.1fk\", $out_tokens/1000}")
    printf ' \033[36min:%s out:%s\033[0m' "$in_k" "$out_k"
  fi
fi
