#!/bin/bash
# My package manager. Just can't bring myself to use anything fancier

function get {
  echo
  dir="git-$2"
  if [ -d $dir ]; then
    echo "Updating $1 $2"
    git -C $dir pull
  else
    echo "Cloning $1 $2"
    git clone git@github.com:$1/$2.git $dir
  fi
}

cd bundle

get bronson         vim-trailing-whitespace  # 6bfea00
get godlygeek       csapprox
get ervandew        screen                   # 7eb3800
get flazz           vim-colorschemes         # c51066b
get kovisoft        paredit                  # kovisoft-paredit-bb51749d3779
get mileszs         ack.vim                  # 9895285
get millermedeiros  vim-statline             # c39ee7c
get scrooloose      nerdtree
get scrooloose      syntastic
get kien            rainbow_parentheses.vim  # 20130102
get tpope           vim-surround             # 489a1e8
get tpope           vim-unimpaired           # e801372
get tpope           vim-fugitive             # 34e2d25
get tpope           vim-projectionist        # 97fde2dbe91e86b4b3fb3b9714dce6fe23a0cc25
get gregsexton      gitv                     # gitv-be6d7db
get eagletmt        ghcmod-vim
get raichoo         haskell-vim
get bitc            vim-hdevtools
get tpope           vim-dispatch             # 2d202d5de2dda74fd6d8d340201d0460dfea6f14
get guns            vim-clojure-highlight    # aac76b431b1ed726a7f3e2608bdfc02cce76ec8e
get guns            vim-clojure-static       # d978de518c1f4eae68f976f9b016d0767880dc27
get tpope           vim-leiningen            # c165108680d83adcd53f7ee1dbf8ef14f7111255
get daveray         vim-fireplace
get derekwyatt      vim-scala
get Shougo          vimproc.vim              &&  make -C git-vimproc.vim  #  3e055023dfab4f5a4dfa05a834f9d0cb7294a82e
