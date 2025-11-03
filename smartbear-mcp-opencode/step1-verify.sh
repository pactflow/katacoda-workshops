command -v opencode &>/dev/null && opencode auth list | grep -i Github &>/dev/null && [ -d "$HOME/.config/opencode" ] && echo "All OpenCode checks passed" || echo "OpenCode checks failed"
