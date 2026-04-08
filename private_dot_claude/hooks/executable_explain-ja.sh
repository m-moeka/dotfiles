#!/bin/bash
# PreToolUse hook: Anthropic API (Haiku) で Bash コマンドの日本語説明を生成し
# permissionDecisionReason に出力する
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [[ -z "$command" ]]; then
  echo '{}'
  exit 0
fi

# API キーがなければスキップ
if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  echo '{}'
  exit 0
fi

# コマンドが長すぎる場合は先頭を切り出す
short_cmd="$command"
if [[ ${#short_cmd} -gt 200 ]]; then
  short_cmd="${short_cmd:0:197}..."
fi

# Haiku で日本語説明を生成
response=$(curl -s --max-time 5 \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  https://api.anthropic.com/v1/messages \
  -d "$(jq -n --arg cmd "$short_cmd" '{
    model: "claude-haiku-4-5-20251001",
    max_tokens: 150,
    system: "あなたはシェルコマンドの説明を日本語で行うアシスタントです。以下のフォーマットで出力してください。それ以外は出力しないでください。\n\n{コマンドの動作を1〜3文で説明（単純なコマンドは1文、複雑なコマンドは必要に応じて2〜3文）}\nリスク: {低/中/高} — {リスクの理由を簡潔に}",
    messages: [{
      role: "user",
      content: ("コマンド: " + $cmd)
    }]
  }')" 2>/dev/null) || true

# レスポンスから説明を抽出
explanation=$(echo "$response" | jq -r '.content[0].text // empty' 2>/dev/null)

if [[ -z "$explanation" ]]; then
  echo '{}'
  exit 0
fi

# JSON 出力用にエスケープ
escaped=$(echo "$explanation" | jq -Rs '.')

cat <<HOOKJSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": $escaped
  }
}
HOOKJSON
