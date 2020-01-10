_get_nvm () {
    command -v nvm >/dev/null 2>&1 || { echo >&2 "nvm is required, but it's not installed.  Aborting."; exit 1; }
}

autoload -U add-zsh-hook

use_node_version () {
    NODE_VERSION=`cat package.json 2> /dev/null | grep node | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]'`

	if [ "$NODE_VERSION" ]; then

        _get_nvm
	    nvm use $NODE_VERSION > /dev/null 2>&1

        NVM_RESULT=$?

        if [ $NVM_RESULT -ne 0 ]; then
            echo "Installing node version v$NODE_VERSION"
            nvm install $NODE_VERSION > /dev/null 2>&1
            INSTALLATION_RESULT=$?
        fi

        if [ $INSTALLATION_RESULT -eq 0 ]; then
            nvm use $NODE_VERSION > /dev/null 2>&1
        else
            echo "Could not install the Node version specified in package.json"
            exit(1)
        fi

        if [[ -n $ZSH_NPM_AUTOINSTALL && $ZSH_NPM_AUTOINSTALL == "true" ]]; then
            echo "Updating node package modules"
            npm install -g npm > /dev/null 2>&1
            [ ! -d ~/.nvm/versions/node/v$NODE_VERSION/lib/node_modules/npm-install-changed ] npm install -g npm-install-changed > /dev/null 2>&1
            [ ! -d node_modules ] && npm install > /dev/null 2>&1
            [ -d node_modules ] && npm-install-changed > /dev/null 2>&1
        fi

    elif [ -f "package.json" ]; then
        echo "Could not get the version of this NodeJS project"
	fi
}

add-zsh-hook chpwd use_node_version
use_node_version