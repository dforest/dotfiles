##
# Default configuations 初期設定
export LANG=ja_JP.UTF-8

# コマンド補完
autoload -U compinit
compinit

setopt auto_pushd         #移動したディレクトリの補完 "% cd -[TAB]"
setopt correct            #コマンド自動修正
setopt list_packed        #補完候補を詰める

# Prompt
PROMPT="%m:%1~ %n%# "
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
alias lla="ls -la"
alias cdd="clear; cd ~/Development; ll"

#git
alias gb="git branch"
alias gst="git status -s -b"
alias glgg="git logg"
alias glg='git logg | head'

# ruby on rails
alias r=rails

#python
alias vact=". venv/bin/activate"
alias vdeact="deactivate"

# invoke prefered editor alias
alias e="code"

alias ez="e ~/.zshrc"
alias sz="source ~/.zshrc"

##
# PATH
PATH=$PATH:$HOME/dotfiles/bin

PATH=$PATH:$HOME/Development/bin
PATH=$PATH:$HOME/Development/bin/sdk/platform-tools

export CC=/usr/bin/gcc
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
# export JAVA8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
# launchctl setenv JAVA8_HOME $JAVA8_HOME

#mysql
PATH=$PATH:/usr/local/mysql/bin

#homebrew-cask-versions
export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
PATH=${JAVA_HOME}/bin:${PATH}

if [ -x "`which go`" ]; then
  export GOROOT=`go env GOROOT`
  export GOPATH=$HOME/code/go-local
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

#Android
export ANDROID_HOME=/Users/keita/Library/Android/sdk
PATH=$PATH:$ANDROID_HOME/platform-tools

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

NVMRC_PATH=".nvmrc"
if [[ -a "$NVMRC_FILE" ]]; then
	nvm use
fi

#node module
PATH=$PATH:$HOME/node_modules/.bin

#Amazon Elastic Beanstalk CLI
PATH=$PATH:$HOME/.eb/AWS-ElasticBeanstalk-CLI-2.3/eb/linux/python2.7/

#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/keita/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/keita/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/keita/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/keita/google-cloud-sdk/completion.zsh.inc'; fi

# direnv
eval "$(direnv hook zsh)"
