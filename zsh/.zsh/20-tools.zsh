# Mise — activates all mise-managed tools (node, python, fzf, zoxide, ripgrep, etc.)
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$(~/.local/bin/mise activate zsh)"
  eval "$(~/.local/bin/mise hook-env -s zsh 2>/dev/null)"
fi

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# fzf key bindings and fuzzy completion
command -v fzf &>/dev/null && source <(fzf --zsh)

# Zsh plugins
[[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]] && \
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
# source "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
