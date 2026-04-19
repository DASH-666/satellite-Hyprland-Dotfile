export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/dash-/.local/bin:$PATH"
export VISUAL="nvim"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
ZSH_THEME="00my"

# Alias
alias l='ls -Flah'
alias proxyflow='source proxyflow.sh'
# Plugins
plugins=(
 git
)
source $ZSH/oh-my-zsh.sh

# Extra sources
source /home/dash-/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Node Version Manager (NVM)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Welcome section
#echo '
#--------------------------------------------------------------------------------
#█ █ █ █▀▀ █   █▀▀ █▀█ █▀▄▀█ █▀▀   ▀█▀ █▀█   ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄ █ ▄▀█ █     ▀
#▀▄▀▄▀ ██▄ █▄▄ █▄▄ █▄█ █ ▀ █ ██▄    █  █▄█    █  ██▄ █▀▄ █ ▀ █ █ █ ▀█ █▀█ █▄▄   ▄
#  𝓓𝓐𝓢𝓗-666 ɪs 𝕆𝕨𝕟𝕖𝕣 ᴏғ ᴛʜɪs 𝐏𝐂. ᴘʟs 𝕕𝕠 𝕟𝕠𝕥 𝕥𝕠𝕦𝕔𝕙 ᴀɴʏᴛʜɪɴɢ. ᴛʜɪs ɪs ɴᴏᴛ ᴡɪɴᴅᴏᴡs.
# ʜᴇʟʟᴏ ᴘʟᴇᴀsᴇ ℝ𝕋𝔽𝕄  ʙᴇғᴏʀᴇ ᴅᴏɪɴɢ ᴀɴʏᴛʜɪɴɢ ᴀɴᴅ ʜᴀᴠᴇ ᴀ ɢᴏᴏᴅ ᴅᴀʏ.                                              
#██████╗░██╗░░░░░░██████╗  ██████╗░████████╗███████╗███╗░░░███╗  ╔══════════════╗
#██╔══██╗██║░░░░░██╔════╝  ██╔══██╗╚══██╔══╝██╔════╝████╗░████║  ║  𝕎𝕖𝕝𝕔𝕠𝕞𝕖     ║
#██████╔╝██║░░░░░╚█████╗░  ██████╔╝░░░██║░░░█████╗░░██╔████╔██║  ║  𝕓𝕒𝕔𝕜 sir    ║
#██╔═══╝░██║░░░░░░╚═══██╗  ██╔══██╗░░░██║░░░██╔══╝░░██║╚██╔╝██║  ║   >_         ║
#██║░░░░░███████╗██████╔╝  ██║░░██║░░░██║░░░██║░░░░░██║░╚═╝░██║  ║              ║
#╚═╝░░░░░╚══════╝╚═════╝░  ╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░╚═╝░░░░░╚═╝  ╚══════════════╝
#--------------------------------------------------------------------------------
#                                                                                         ' | lolcat -p 1 -f -t

[[ -f /home/dash-/.dart-cli-completion/zsh-config.zsh ]] && . /home/dash-/.dart-cli-completion/zsh-config.zsh || true

setopt HIST_IGNORE_DUPS
fastfetch
