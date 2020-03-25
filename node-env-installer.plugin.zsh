# This function search for the installation of nvm package.
_get_nvm () {
    # Executes a command to get the help of nvm
    # If the help does not show up, then abort the operation.
    command -v nvm >/dev/null 2>&1 || { echo >&2 "nvm is required, but it's not installed.  Aborting."; exit 1; }
}

# Set a hook for zsh to load the function each folder change.
autoload -U add-zsh-hook

# This function will get the version of node in the package.json file
# Evaluate the version into the installed version and decide if the
# plugin will only set the version or if the installation is needed.
use_node_version () {
    if [ -f "package.json" ]; then
        # Gets the version of the package.json with the next format:
        # {
        #    "engine": {
        #       "node": "10.16.3"
        #    }
        # }
        NODE_VERSION=`cat package.json 2> /dev/null | grep node | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]'`

        if [ "$NODE_VERSION" ]; then

            _get_nvm
            # Tries to set the version of node
            nvm use $NODE_VERSION > /dev/null 2>&1

            # Gets the result of the last command
            NVM_RESULT=$?

            # If nvm can't set the version it will try to install the version
            if [ $NVM_RESULT -ne 0 ]; then
                echo "Installing node version v$NODE_VERSION"
                nvm install $NODE_VERSION > /dev/null 2>&1
                INSTALLATION_RESULT=$?
            fi

            if [ $INSTALLATION_RESULT -eq 0 ]; then
                nvm use $NODE_VERSION > /dev/null 2>&1
            # If the installation is not successful the the plugin will print an error message
            else
                echo "Could not install the Node version specified in package.json"
                exit(1)
            fi

            # If the user allows the auto install of the modules in each project
            if [[ -n $ZSH_NPM_AUTOINSTALL && $ZSH_NPM_AUTOINSTALL == "true" ]]; then
                echo "Updating node package modules"
                npm install -g npm > /dev/null 2>&1
                [ ! -d ~/.nvm/versions/node/v$NODE_VERSION/lib/node_modules/npm-install-changed ] npm install -g npm-install-changed > /dev/null 2>&1
                [ ! -d node_modules ] && npm install > /dev/null 2>&1
                [ -d node_modules ] && npm-install-changed > /dev/null 2>&1
            fi

        # If not package.json file is found returns an error message.
        elif [[ -f "package.json" && -f "node_modules" ]]; then
            echo "Could not get the version of this NodeJS project"
        else
            # If the user allows the auto install of the modules in each project
            if [[ -n $ZSH_NPM_AUTOINSTALL && $ZSH_NPM_AUTOINSTALL == "true" ]]; then
                echo "Updating node package modules"
                npm install -g npm > /dev/null 2>&1
                [ ! -d ~/.nvm/versions/node/v$NODE_VERSION/lib/node_modules/npm-install-changed ] npm install -g npm-install-changed > /dev/null 2>&1
                [ ! -d node_modules ] && npm install > /dev/null 2>&1
                [ -d node_modules ] && npm-install-changed > /dev/null 2>&1
            fi
        fi
    fi
}

add-zsh-hook chpwd use_node_version
use_node_version
