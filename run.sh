#!/bin/sh

is_wsl() {
    case "$(uname -r)" in
    *microsoft* ) true ;; # WSL 2
    *Microsoft* ) true ;; # WSL 1
    * ) false;;
    esac
}

if ! is_wsl; then
    # The steps below are obtained from https://get.docker.com

    curl -fsSL https://get.docker.com -o install-docker.sh
    sudo sh install-docker.sh

    rm install-docker.sh

    # The steps below are obtained from https://docs.docker.com/engine/install/linux-postinstall

    # To use the docker command without sudo, create a Unix group called docker.
    sudo groupadd docker # you may get a response from the terminal saying that group 'docker' already exists

    # Add your user to the docker group.
    sudo usermod -aG docker $USER

    # Log out and log back in so that your group membership is re-evaluated.
    # You can also run the following command to activate the changes to groups:
    newgrp docker
fi

# Verify that you can run docker commands without sudo.

{ # try
    docker run hello-world
} || { # catch
    # this catch should only be triggered when the 'docker' command is run in a WSL distro that isn't enabled in Docker Desktop
    # even if the WSL distro is not enabled in Docker Desktop, you can still run docker commands by using the 'docker.exe' command but there are various disadvantages to this
    if is_wsl; then
        echo
        echo "The 'docker' command is not yet supported in this WSL distro."
        echo "Ensure that:"
        echo "- Docker Desktop for Windows is installed and running."
        echo "- This WSL distro is enabled in Docker Desktop by going to Settings > Resources > WSL Integration."
        echo "Then re-run this script and the 'docker' command should work."
    fi
}