# Node Env Installer

This plugin enables the installation of new NodeJS versions for your current project.

## Plugin Requirements

For the use of this plugin it's required the installation of:

* nvm

## Installation

For the installation you only need to clone this project into `~/.oh-my-zsh/custom/plugins`.

## Configuration

After the installation you need to add `node-env-installer` in the `plugins = (...)` variable of your `.zshrc` file.

If you want the plugin to install all dependencies in your projects you can use the next command `echo "export ZSH_NPM_AUTOINSTALL='true'"`