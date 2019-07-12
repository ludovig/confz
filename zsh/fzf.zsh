# Setup fzf
# ---------
if [[ ! "$PATH" == */home/mundoludo/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/mundoludo/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/mundoludo/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/mundoludo/.fzf/shell/key-bindings.zsh"


# Solarized Dark color scheme for fzf
export FZF_DEFAULT_OPTS="
	--color fg:240,bg:230,hl:33,fg+:241,bg+:221,hl+:33
	--color info:33,prompt:33,pointer:166,marker:166,spinner:33
"
