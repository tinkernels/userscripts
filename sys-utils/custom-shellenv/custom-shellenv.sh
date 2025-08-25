#!/usr/bin/env bash

# tmux conf
curl -sSfLo "$HOME/.tmux.conf" "https://raw.githubusercontent.com/tinkernels/userscripts/gh-pages/sys-utils/custom-shellenv/custom-tmux.conf"

# screen conf
if [ ! -r "$HOME/.screenrc" ];then
    echo "escape ^Bb" > "$HOME/.screenrc"
    echo "termcapinfo xterm* ti@:te@" >> "$HOME/.screenrc"
    echo "defscrollback 100000" >> "$HOME/.screenrc"
else
    grep -Eq '^[[:blank:]]*escape[[:blank:]]+\^Bb' "$HOME/.screenrc" || echo "escape ^Bb" >> "$HOME/.screenrc"
    grep -Eq '^[[:blank:]]*termcapinfo[[:blank:]]+xterm\*[[:blank:]]+ti@:te@' "$HOME/.screenrc" || echo "termcapinfo xterm* ti@:te@" >> "$HOME/.screenrc"
    grep -Eq '^[[:blank:]]*defscrollback[[:blank:]]+[0-9]+' "$HOME/.screenrc" || echo "defscrollback 100000" >> "$HOME/.screenrc"
fi

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    curl -sSfL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | bash -s -
fi

# .profile
curl -sSfLo "$HOME/.profile" "https://raw.githubusercontent.com/tinkernels/userscripts/gh-pages/sys-utils/custom-shellenv/custom-shellprofile"
(cd "$HOME" && ln -sf .profile .zprofile && ln -sf .profile .bash_profile)

# .shellrc
curl -sSfLo "$HOME/.shellrc" "https://raw.githubusercontent.com/tinkernels/userscripts/gh-pages/sys-utils/custom-shellenv/custom-shellrc"
for F in "$HOME/.zshrc" "$HOME/.bashrc"; do
    grep -q "source \$HOME/.shellrc" "$F" || echo "source \$HOME/.shellrc" >>"$F"
done

# .zshrc
grep -qE '^[[:blank:]]*ZSH_THEME="ys"' "$HOME/.zshrc" || sed -i -r 's:^[[:blank:]]*ZSH_THEME=.*$:ZSH_THEME="ys":g' "$HOME/.zshrc"
