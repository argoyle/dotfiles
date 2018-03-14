# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

fpath=(/usr/local/share/zsh-completions $fpath)

for file in ~/.{paths,prompt,exports,aliases,functions,extra,auths,historyopts}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done

source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
fi

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# Faster! (?)
zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

