# Mise — activates all mise-managed tools (node, python, fzf, zoxide, ripgrep, etc.)
eval "$(~/.local/bin/mise activate zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Zsh plugins
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
# source "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
