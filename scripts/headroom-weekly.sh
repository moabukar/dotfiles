#!/usr/bin/env bash
# Weekly Headroom + Claude usage summary. Run by launchd, appends to a log and notifies.
export PATH="$HOME/.local/bin:$PATH"

LOG="$HOME/.config/headroom/weekly-report.log"
mkdir -p "$(dirname "$LOG")"
ts=$(date '+%Y-%m-%d %H:%M')

# Claude Code sessions and token usage over the last 7 days, from the transcripts.
proj="$HOME/.claude/projects"
sessions=$(find "$proj" -name '*.jsonl' -mtime -7 2>/dev/null | wc -l | tr -d ' ')
tokens=$(find "$proj" -name '*.jsonl' -mtime -7 2>/dev/null -print0 \
  | xargs -0 cat 2>/dev/null \
  | jq -rs '[.[] | select(.type=="assistant") | .message.usage
            | ((.input_tokens//0)+(.output_tokens//0)+(.cache_read_input_tokens//0)+(.cache_creation_input_tokens//0))]
            | add // 0' 2>/dev/null)
[ -z "$tokens" ] && tokens=0

# Headroom proxy-side savings, whatever has been recorded.
savings=$(headroom output-savings 2>/dev/null)
[ -z "$savings" ] && savings="(headroom not available)"

{
  echo "===== Headroom weekly report  $ts ====="
  echo "Claude sessions (last 7 days): $sessions"
  echo "Tokens through Claude (last 7 days): $tokens"
  echo "--- headroom output-savings ---"
  echo "$savings"
  echo ""
} >> "$LOG"

headline="$sessions sessions, $(printf "%'d" "$tokens" 2>/dev/null || echo "$tokens") tokens this week"
osascript -e "display notification \"$headline. Full report in ~/.config/headroom/weekly-report.log\" with title \"Headroom weekly\"" 2>/dev/null || true
