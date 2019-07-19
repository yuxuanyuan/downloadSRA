#!/bin/bash

DEBUG=1

if [ "_$1" = "_-q" ]; then
    DEBUG=0
fi

INSTALL_DIR=$1

if [ $(id -u) = 0 ]; then
    echo "This script cannot be run as root, IBM Aspera Connect must be installed per user."
    exit 1
else
    echo "Deploying IBM Aspera Connect ($INSTALL_DIR) for the current user only."
    # Kill all asperaconnect instances
    if [ -n "$(pgrep -u `whoami` asperaconnect)" ]; then
        echo "IBM Aspera Connect is running, Attempting to close it."
        pkill -u `whoami` asperaconnect
        if [ -n "$(pgrep -u `whoami` asperaconnect)" ]; then
            echo "Failed to close IBM Aspera Connect, Attempting to kill it."
            pkill -9 -u `whoami` asperaconnect
            if [ -n "$(pgrep -u `whoami` asperaconnect)" ]; then
                echo "Failed to close IBM Aspera Connect, please do it manually and rerun the installer."
                exit 1
            fi
        fi
    fi
    # Create asperaconnect.path file
    mkdir -p ~/.aspera/connect/etc 2>/dev/null || echo "Unable to create .aspera directory in $HOME. IBM Aspera Connect will not work"
    echo $INSTALL_DIR/bin > $INSTALL_DIR/etc/asperaconnect.path

    # Place .desktop file
    mkdir -p ~/.local/share/applications
    rm -rf ~/.local/share/applications/aspera-connect.desktop 2>/dev/null
    cp $INSTALL_DIR/res/aspera-connect.desktop ~/.local/share/applications/

    # Expand variables in xdg desktop file
    # First part is single quoted to avoid variable expansion. Rest is double quoted for var expansion.
    # Using '#' as a separator to sed to avoid conflicts with '/' in paths
    sed -i -e 's#$HOME#'"${HOME}#" ~/.local/share/applications/aspera-connect.desktop

    # Register protocol handler
    xdg-mime default aspera-connect.desktop x-scheme-handler/fasp 2>/dev/null || echo "Unable to register protocol handler, IBM Aspera Connect won't be able to auto-launch"
    `which update-desktop-database` ~/.local/share/applications 2>/dev/null || echo "Unable to update desktop database, IBM Aspera Connect may not be able to auto-launch"

    # Register native host manifest for web extensions
    ~/.aspera/connect/bin/asperaconnect-nmh --register

    echo
    echo "Install complete."
fi
