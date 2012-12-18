##
# Default configuations 初期設定
export LANG=ja_JP.UTF-8
#bindkey -v                #vi風キーバインドモード

# コマンド補完
autoload -U compinit
compinit

setopt auto_pushd         #移動したディレクトリの補完 "% cd -[TAB]"
setopt correct            #コマンド自動修正
setopt list_packed        #補完候補を詰める

# Prompt
PROMPT="%m:%1~ %n%# "
#RPROMPT="[%~]"
SPROMPT="correct: %R -> %r ?(y/n)"

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%b) '
zstyle ':vcs_info:*' actionformats '(%b|%a) '
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="[%1(v|%F{green}%1v%f|)%~]"

# Terminal title
case "${TERM}" in
kterm*|xterm)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
    ;;
esac

# nvm と指定されたバージョンの Node.js がインストール済みの場合だけ
# 設定を有効にする
####Macvimで利用できないためnvmを一旦使わないことにする。2011/12/28
#if [[ -f ~/.nvm/nvm.sh ]]; then
#  source ~/.nvm/nvm.sh
#  setopt no_nomatch
#
#  if which nvm >/dev/null 2>&1 ;then
#    _nodejs_use_version="v0.6.6"
#    if nvm ls | grep -F -e "${_nodejs_use_version}" >/dev/null 2>&1 ;then
#      nvm use "${_nodejs_use_version}" >/dev/null
#      alias coffee='~/.npm/coffee-script/1.2.0/package/bin/coffee'
#    fi
#    unset _nodejs_use_version
#  fi
#fi

##
# Command history コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     #コマンド履歴の重複を無視
setopt share_history        #コマンド履歴の共有

#コマンド履歴キーバインド
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-searcg-end
bindkey "^P" history-beginning-search-backword-end
bindkey "^N" history-beginning-search-forward-end

##
# Command alias ショートカットコマンド設定
alias la="ls -a"
alias ll="ls -l"

#git
alias gb="git branch"
alias gst="git status -s -b"
alias glgg="git logg"
alias glg='git logg | head'

#mysql
alias mysql=/usr/local/mysql/bin/mysql
alias mysqldump=/usr/local/mysql/bin/mysqldump
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

# play! frame work
alias p=play

# ruby on rails
alias r=rails
alias gs='bundle exec guard start'

# macvim デフォルトでgvimを起動
#alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g --remote-tab-silent "$@"'

# local固有設定
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

#PATH
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/bashfiles
