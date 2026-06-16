
# =============================================================================
# Install
# =============================================================================
# Oh-My-ZSH
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-vi-mode
# git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode

# zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# bat
# sudo pacman -Syu bat

# nvm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash



# =============================================================================
# Git functions for prompt
# =============================================================================

# Get current git branch name
function git_branch() {
  git branch --show-current 2>/dev/null
}

# Build git prompt section with red bold format
function git_prompt() {
  local branch=$(git_branch)
  if [[ -n $branch ]]; then
    echo "%F{red}%B($branch)%b%f"
  fi
}

# =============================================================================
# Environment variables
# =============================================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/dash-/.local/bin:$PATH"
export VISUAL="nvim"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"

# =============================================================================
# Oh-My-Zsh configuration
# =============================================================================

ZSH_THEME="00my"

# =============================================================================
# Aliases
# =============================================================================

alias l='ls -Flah'
alias proxyflow='source proxyflow.sh'

# =============================================================================
# Oh-My-Zsh plugins
# =============================================================================

plugins=(
  git
  zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Third-party plugin sources
# =============================================================================

source /home/dash-/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# =============================================================================
# Man pages with bat
# =============================================================================

export BAT_THEME="dusklite"
export GROFF_NO_SGR=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# =============================================================================
# Node Version Manager (NVM)
# =============================================================================

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Loads nvm bash_completion

# =============================================================================
# Dart completion
# =============================================================================

[[ -f /home/dash-/.dart-cli-completion/zsh-config.zsh ]] && . /home/dash-/.dart-cli-completion/zsh-config.zsh || true

# =============================================================================
# Shell options
# =============================================================================

setopt HIST_IGNORE_DUPS
