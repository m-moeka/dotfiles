#!/bin/bash
set -eu

PLIST="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

set_hotkey_enabled() {
  local id=$1
  local enabled=$2
  if /usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:${id}" "$PLIST" &>/dev/null; then
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:${id}:enabled ${enabled}" "$PLIST"
  fi
}

set_hotkey_modifier() {
  local id=$1
  local modifier=$2
  if /usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:${id}" "$PLIST" &>/dev/null; then
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:${id}:value:parameters:2 ${modifier}" "$PLIST"
  fi
}

# Cmd+Space: 次の入力ソースを選択（有効）
# 修飾キーを1048576(Command)に明示設定（デフォルトがControl+Optionになっていることがある）
set_hotkey_enabled 61 true
set_hotkey_modifier 61 1048576
# Ctrl+Space: 前の入力ソースを選択（無効）
set_hotkey_enabled 60 false
# Spotlight（無効）
set_hotkey_enabled 64 false
set_hotkey_enabled 65 false

/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
killall SystemUIServer
