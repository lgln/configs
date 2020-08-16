# base16

## shell

see https://github.com/chriskempson/base16-shell

    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

## tmux

see https://github.com/mattdavis90/base16-tmux

    cp ~/configs/.tmux.conf ~/.tmux.conf
    git clone https://github.com/mattdavis90/base16-tmux
    cat base16-tmux/colors/base16-default-dark.conf >> ~/.tmux.conf


# nvim

depend tools

    # fd: https://github.com/sharkdp/fd
    cargo install fd-find
    # rg: https://github.com/BurntSushi/ripgrep
    cargo install ripgrep
    # ag: https://github.com/ggreer/the_silver_searcher
    apt-get install silversearcher-ag
    # proximity-sort: https://github.com/jonhoo/proximity-sort 
    cargo install proximity-sort

install plugs within vim

    :PlugInstall
    :CocInstall coc-rls
