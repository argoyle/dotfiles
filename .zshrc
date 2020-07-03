# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)

for file in ~/.{functions,exports,paths,prompt,aliases,extra,auths,historyopts}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done

function powerline_precmd() {
    ZLE_RPROMPT_INDENT=-1
    eval "$($GOPATH/bin/powerline-go -error $? -shell zsh -eval -cwd-max-depth 4 -modules ssh,cwd,exit -modules-right git,hg,aws,kube)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*' ignored-patterns 'kubectl.docker'

# Faster! (?)
zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

if [ -d "$HOME/.kube/config.d" ];then
  for file in $HOME/.kube/config.d/*.yaml; do
    KUBECFG="$KUBECFG$file:"
  done
  export KUBECONFIG="$HOME/.kube/config:$KUBECFG"
fi

eval "$(direnv hook zsh)"

autoload -Uz compinit && compinit -i

direnv reload

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
source <(stern --completion zsh)
source <(kubectl completion zsh)
source <(kops completion zsh)
source <(kind completion zsh)

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
