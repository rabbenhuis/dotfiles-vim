#!/bin/bash

# Copy vimrc file
cp -p vimrc ~/.vimrc

# Create .vim directory
if ! [[ -d ~/.vim ]] ; then
  mkdir -p ~/.vim
fi

# Create bundle directory
if ! [[ -d ~/.vim/bundle ]] ; then
  mkdir -p ~/.vim/bundle
fi

# Clone vundle
if ! [[ -d ~/.vim/bundle/Vundle.vim ]] ; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
