# Node Env Installer

This plugin lets nvm install new versions and modules for the current project.

Here is a preview of the plugin

![Preview Image](/preview.png)

## Functionality

The plugin is looking for a package.json file to get a NodeJS version and then set it as the current using version.

After getting a node version, if the version is not currently installed in the machine this plugin will install it for you.

You also can configure the implicit installation/update of your package by environment variables, this will use the [npm-install-changed](https://www.npmjs.com/package/npm-install-changed) for the update of the modules.

## Plugin Requirements

For the use of this plugin it's required the installation of:

* nvm

## Installation

For the installation you need to

* Clone this project into `~/.oh-my-zsh/custom/plugins`.
* Let your user to execute nvm, usually achieved with `chmod 755 $NVM_DIR/nvm.sh`

## Configuration

After the installation you need to add `node-env-installer` in the `plugins = (...)` variable of your `.zshrc` file.

If you want the plugin to install all dependencies in your projects you can use the next command `echo "export ZSH_NPM_AUTOINSTALL='true' >> ~/.zshrc".`

This last command will set an environment variable that let know the plugin to install and update everytime there is a change in the `package.json` file.