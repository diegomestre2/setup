#!/usr/bin/env zsh

# hide "Last login" message, because why not
clear

export LANG="en_US.UTF-8"

# Want to do some profiling on zshrc speed ?
# https://kev.inburke.com/kevin/profiling-zsh-startup-time/
# https://github.com/raboof/zshprof

__FILENAME__=${ZDOTDIR-~}/.zshrc
if [[ -z "$SETUP_PATH" ]] then
  export SETUP_PATH=$HOME/setup
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# set by pretzo
unsetopt CORRECT
unsetopt SHARE_HISTORY

## LOCAL STUFF
if [[ -f ~/.zshrc.local ]]; then; source ~/.zshrc.local; fi

# load setupsh core functions
for file in $SETUP_PATH/functions/*; do; source $file; done

export DIR_SYNC=$HOME/Sync
export DIR_DEV=$HOME/Development
alias dev="cd $DIR_DEV"

# add personal bin in the path
export PATH=$DIR_DEV/.bin:$SETUP_PATH/bin:$PATH:./bin:./.bin
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export EDITOR="code"
alias e="$EDITOR ."

# export LC_CTYPE=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LANGUAGE=en_US.UTF-8
#export CC=llvm-gcc-4.2

export OS_ICONS_DIR=/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources

# disable ._ file
export COPYFILE_DISABLE=true

# Aliases

## macOS
alias macos-sleep="osascript -e 'tell application \"System Events\" to sleep'"
alias macos-hidden-show="defaults write com.apple.finder AppleShowAllFiles -bool true && macos-refresh"
alias macos-hidden-hide="defaults write com.apple.finder AppleShowAllFiles -bool false && macos-refresh"
alias macos-desktop-show="defaults write com.apple.finder CreateDesktop -bool true && macos-refresh"
alias macos-desktop-hide="defaults write com.apple.finder CreateDesktop -bool false && macos-refresh"
# http://apple.stackexchange.com/a/181404/34887
alias macos-internetsharing-on="sudo networksetup -setnetworkserviceenabled 'Ethernet sharing via Wifi' on"
alias macos-internetsharing-off="sudo networksetup -setnetworkserviceenabled 'Ethernet sharing via Wifi' off"
alias macos-flushdns="dscacheutil -flushcache"
alias macos-flushram="purge"
alias macos-dsstore-delete="find . -type f -name '*.DS_Store' -ls -delete"

alias syncthing-conflicts-show="find ~/ -name \"*.sync-conflict-*\""
alias syncthing-conflicts-trash="find ~/ -name \"*.sync-conflict-*\" -exec trash {} +"

## Node via fnm
export PATH=$HOME/.fnm:$PATH
eval "`fnm env --multi --use-on-cd`"

## NPM

alias n="npm"
alias ni="npm install"
alias nig="npm install -g"
alias nis="npm install -S"
alias nid="npm install -D"
alias ns="npm start --"
alias nt="npm test --"
alias nr="npm run"
alias np="nr release --"
alias npf="nr release -- --skip-cleanup"

### allow local self signed https server
export NODE_TLS_REJECT_UNAUTHORIZED="0"

### to avoid npm install -g
export PATH=$PATH:./node_modules/.bin

## Yarn
# export PATH="$PATH:`yarn global bin`" # slow
# export PATH="$HOME/.yarn/bin:$PATH"
alias y="yarn"
alias yg="yarn global"
alias yga="yarn global add"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yr="yarn remove"
alias ys="yarn start"
alias yt="yarn test"
alias yu="yarn upgrade"
alias yb="yarn build"
alias yyt="yarn && yarn test"

## React Native
alias rn="react-native"
alias rni="react-native run-ios"
alias rna="react-native run-android"
alias rnl="react-native link"
alias rnu="react-native unlink"

alias floww="killall flow;flow"

## Ruby / Bundler
alias b="bundler"
alias bi="bundler install"
alias bu="bundler update"
alias be="bundler exec"
export GEM_HOME=$HOME/.gem
export PATH=$PATH:$HOME/.gem/bin
eval "$(rbenv init -)"

## Git
if [[  "$(command -v hub)" != ""  ]] then
  alias git="hub"
fi
alias g="git"
# need short alias with explicit pull for PURE
# https://github.com/sindresorhus/pure/issues/162
alias gg="git pull"
alias gp="git push"

# custom aliases
alias gh="github ."
alias .e="$EDITOR $SETUP_PATH"
alias .o="open"
alias .up="git -C $SETUP_PATH pull origin master; source $SETUP_PATH/dotfiles/.zshrc; sourceFiles $SETUP_PATH/preferences/*.prefs"
alias echofliptable="echo '\n(╯°□°）╯︵ ┻━┻\n'"
alias fliptable="echo \"$USER/setup\"; echofliptable; zprezto-update; .up; brew upgrade; brew bundle check"

# Android Studio/Tools (react-native)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-12.0.1.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

####
####
#### Start of dynamic stuff
####
####

## GPG
# set up gpg-agent automatically for every shell
# https://gist.github.com/yoshuawuyts/69f25b0384d41b46a126f9b42d1f9db2
# if which gpg-agent &> /dev/null &&
# then
#   if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]
#   then
#     source ~/.gnupg/.gpg-agent-info
#     export GPG_AGENT_INFO
#   else
#     eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
#   fi
# fi

# Show notification when long running command finishes
# and your terminal is not in focus
#
# http://frantic.im/notify-on-completion
function notify_cmd_result_when_terminal_not_focused {
  LAST_EXIT_CODE=$?
  CMD=$(fc -ln -1)
  # No point in waiting for the command to complete
  notify-if-iterm-is-in-the-background "$CMD" "$LAST_EXIT_CODE" &
}
#export PS1='$(notify_cmd_result_when_terminal_not_focused)'$PS1

# eval `opam config env`
. /Users/MoOx/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
