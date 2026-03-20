# Powerlevel10k instant prompt. Must stay at the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Source modular configs (alphabetical order via numbered prefixes)
for conf in "$HOME/.zsh/"[0-9]*.zsh; do
  [[ -f "$conf" ]] && source "$conf"
done

# Source local secrets (not in git)
[[ -f "$HOME/.zsh/secrets.zsh" ]] && source "$HOME/.zsh/secrets.zsh"

# Fix virgl/Parallels GPU compatibility (GL_EXT_shader_texture_lod unsupported)
# export LIBGL_ALWAYS_SOFTWARE=1
