#!/bin/sh

export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$PATH"
gobrew use latest

go install github.com/justjanne/powerline-go@latest
