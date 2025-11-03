# Check if OpenCode CLI is installed
if command -v opencode &> /dev/null; then
  echo "OpenCode CLI is installed"
else
  echo "ERROR: OpenCode CLI is not installed"
  exit 1
fi

# Check if user is authenticated with OpenCode (GitHub)
if opencode auth list | grep -i Github &> /dev/null; then
    echo "OpenCode is authenticated with GitHub"
else
    echo "WARNING: OpenCode may not be authenticated with GitHub"
fi

# Check if OpenCode config directory exists
if [ -d "$HOME/.config/opencode" ]; then
  echo "OpenCode config directory exists"
else
  echo "ERROR: OpenCode config directory not found"
  exit 1
fi
