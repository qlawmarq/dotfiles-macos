#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# Link settings.json to vscode
SCRIPT_DIR=$(cd $(dirname $0) && pwd)
VSCODE_SETTING_DIR=${HOME}/Library/Application\ Support/Code/User

if [ ! -f "${VSCODE_SETTING_PATH}" ]; then
  echo "Linking settings.json to vscode..."
  ln -s "$SCRIPT_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
else
  echo "VSCode already found"
  rm "$VSCODE_SETTING_DIR/settings.json"
  ln -s "$SCRIPT_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
  # rm "$VSCODE_SETTING_DIR/keybindings.json"
  # ln -s "$SCRIPT_DIR/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"
fi

# Install extensions to vscode
if [ "$(which "code")" != "" ]; then
  echo "Installing extensions to vscode..."
  cat < "${SCRIPT_DIR}/extensions" | while read -r line
  do
    code --install-extension "$line"
  done
else
  echo "Code command not found."
fi