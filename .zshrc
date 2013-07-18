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

# ls_abbrev
# ファイル数が多い場合は省略して表示する
# http://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059
chpwd() {
    ls_abbrev
}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

# 空Enterで`ls`と`git status`を打つ
# http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
# function do_enter() {
#     if [ -n "$BUFFER" ]; then
#         zle accept-line
#         return 0
#     fi
#     echo
#     ls_abbrev
#     if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
#         echo
#         echo -e "\e[0;33m--- git status ---\e[0m"
#         git status -sb
#     fi
#     zle reset-prompt
#     return 0
# }
# zle -N do_enter
# bindkey '^m' do_enter

# 空Enterで`git branch`を打つ
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        git branch
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter


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

# invoke prefered editor alias
alias e="subl"

# macvim デフォルトでgvimを起動
#alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g --remote-tab-silent "$@"'

# local固有設定
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

#PATH
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/dotfiles/bin
