#!/bin/sh

goenv install latest
goenv global $(goenv versions --bare | sort -r | head -1)
eval "$(goenv init -)"

go install github.com/justjanne/powerline-go@latest
