#!/bin/bash

# Setup Rectangle window manager and remove legacy Hammerspoon from login items

if ! [ -d "/Applications/Rectangle.app" ]; then
  echo "Rectangle is not installed yet, skipping setup"
  exit 0
fi

echo "Setting up Rectangle..."

# Quit Rectangle first to ensure preferences aren't cached in memory
echo "Quitting Rectangle if running..."
killall Rectangle 2>/dev/null || true
sleep 2

# Copy Rectangle preferences if available
if [ -f "$HOME/.config/rectangle/com.knollsoft.Rectangle.plist" ]; then
  echo "Copying Rectangle preferences..."
  cp -f "$HOME/.config/rectangle/com.knollsoft.Rectangle.plist" "$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"

  # Refresh the preferences cache
  defaults read com.knollsoft.Rectangle > /dev/null 2>&1
fi

# Remove Hammerspoon from login items if present
echo "Removing legacy window managers from login items..."
osascript -e 'tell application "System Events" to delete login item "Hammerspoon"' 2>/dev/null || true

# Add Rectangle to login items if not already present
if ! osascript -e 'tell application "System Events" to get the name of every login item' | grep -q "Rectangle"; then
  echo "Adding Rectangle to login items..."
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Rectangle.app", hidden:false}' 2>/dev/null || true
fi

# Launch Rectangle to apply configuration
echo "Launching Rectangle with new configuration..."
sleep 1
open -a Rectangle

echo "Rectangle setup complete"
