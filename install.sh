#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
REPO="git@github.com:bajustone/dotfiles.git"
OS="$(uname)"

echo "=== Dotfiles Bootstrap ==="
echo "Detected OS: $OS"

# --- Phase 1: System packages ---
echo "--- Installing system packages ---"
if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew install stow git zsh tmux zsh-syntax-highlighting lazygit
elif [[ "$OS" == "Linux" ]]; then
    sudo apt update
    sudo apt install -y stow git zsh tmux zsh-syntax-highlighting curl build-essential
    # lazygit isn't in default Ubuntu repos — install from GitHub release
    if ! command -v lazygit &>/dev/null; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        LAZYGIT_ARCH=$(dpkg --print-architecture)
        [[ "$LAZYGIT_ARCH" == "amd64" ]] && LAZYGIT_ARCH="x86_64"
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    fi
fi

# --- Phase 2: Install mise ---
echo "--- Installing mise ---"
if ! command -v mise &>/dev/null; then
    curl https://mise.jdx.dev/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"

# --- Phase 2b: Install uv ---
echo "--- Installing uv ---"
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# --- Phase 3: Clone dotfiles ---
echo "--- Setting up dotfiles ---"
if [[ ! -d "$DOTFILES/.git" ]]; then
    if [[ -d "$DOTFILES" ]]; then
        # Directory exists but isn't a git repo (first-time setup on this machine)
        rm -rf "$DOTFILES"
    fi
    git clone "$REPO" "$DOTFILES"
else
    echo "Dotfiles already cloned, pulling latest..."
    git -C "$DOTFILES" pull --ff-only
fi
cd "$DOTFILES"

# --- Phase 4: Stow mise first, then install tools ---
echo "--- Installing dev tools via mise ---"
stow -v mise
mise install

# --- Phase 4b: zoxide (mise github backend broken on Linux, install via official script) ---
if ! command -v zoxide &>/dev/null; then
    echo "--- Installing zoxide ---"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# --- Phase 5: Oh My Zsh ---
echo "--- Installing Oh My Zsh ---"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Phase 6: Powerlevel10k ---
echo "--- Installing Powerlevel10k ---"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# --- Phase 6b: Nerd Font (MesloLGS NF, recommended for Powerlevel10k) ---
echo "--- Installing Nerd Font ---"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! ls "$FONT_DIR"/MesloLGS* &>/dev/null; then
    cd "$FONT_DIR"
    curl -fLO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    curl -fLO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    curl -fLO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    curl -fLO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    fc-cache -f "$FONT_DIR"
fi

# --- Phase 7: Zsh plugins ---
echo "--- Installing zsh plugins ---"
mkdir -p "$HOME/.zsh"
[[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
[[ ! -d "$HOME/.zsh/zsh-autocomplete" ]] && \
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "$HOME/.zsh/zsh-autocomplete"

# --- Phase 8: Backup and stow ---
echo "--- Stowing dotfiles ---"
backup_if_exists() {
    if [[ -e "$1" && ! -L "$1" ]]; then
        echo "Backing up $1 to $1.bak"
        mv "$1" "$1.bak"
    fi
}

backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.p10k.zsh"
backup_if_exists "$HOME/.tmux.conf"
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/.config/tmux"

cd "$DOTFILES"
stow -R zsh
stow -R tmux
stow -R nvim
stow -R scripts
stow -R mise

# --- Phase 9: TPM ---
echo "--- Installing TPM ---"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
~/.tmux/plugins/tpm/bin/install_plugins

# --- Phase 10: Secrets reminder ---
if [[ ! -f "$HOME/.zsh/secrets.zsh" ]]; then
    echo ""
    echo "=== ACTION REQUIRED ==="
    echo "Create $HOME/.zsh/secrets.zsh with your secrets."
    echo "See $DOTFILES/zsh/.zsh/secrets.zsh.example for template."
fi

# --- Phase 11: Default shell ---
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "--- Setting zsh as default shell ---"
    chsh -s "$(which zsh)"
fi

echo ""
echo "=== Done! ==="
echo "Restart your shell or run: exec zsh"
echo "Then open tmux and press prefix + I to install tmux plugins."
echo "Nvim plugins will auto-install on first launch."
