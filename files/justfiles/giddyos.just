[private]
default:
    @just --list

# Post-install setup
[group('Install')]
giddyos-post-install: giddyos-install-flatpaks giddyos-setup-user-dirs giddyos-configure-firefox giddyos-setup-git giddyos-mount-drives giddyos-install-horizon-client

# Install flatpaks
[group('Install')]
giddyos-install-flatpaks:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing flatpaks..."

    flatpak install -y -u org.mozilla.firefox \
                          org.mozilla.Thunderbird \
                          com.mattjakeman.ExtensionManager \
                          com.valvesoftware.Steam \
                          com.visualstudio.code \
                          ca.desrt.dconf-editor \
                          com.github.tchx84.Flatseal \
                          com.ranfdev.DistroShelf \
                          com.usebottles.bottles \
                          io.github.flattool.Ignition \
                          io.github.pwr_solaar.solaar \
                          it.mijorus.gearlever \
                          net.codelogistics.webapps \
                          org.gnome.Boxes \
                          org.gnome.FileRoller \
                          page.codeberg.libre_menu_editor.LibreMenuEditor \
                          com.discordapp.Discord \
                          com.heroicgameslauncher.hgl \
                          com.spotify.Client \
                          io.github.Faugus.faugus-launcher \
                          io.github.kolunmi.Bazaar \
                          net.lutris.Lutris \
                          org.gnome.SimpleScan \
                          org.gnome.TextEditor \
                          org.libreoffice.LibreOffice \
                          org.videolan.VLC \
                          org.fedoraproject.MediaWriter
    echo "Installation complete."

# Configure Firefox
[group('Setup')]
giddyos-configure-firefox:
    #!/usr/bin/env bash
    set -euo pipefail

    # get user to login to FF first
    echo 'If you have not already done so, Open Firefox, login and close before continuing.'
    echo "Press any key to continue..."
    read -s -n 1

    # find firefox profile and copy user.js to it
    echo "Configuring Firefox..."
    PROFPATH=$(grep 'Path=' $HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/profiles.ini | sed s/^Path=// | grep release)
    cat > $HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/$PROFPATH/user.js<< EOF
      user_pref("browser.toolbars.bookmarks.visibility", "never");
      user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"transmitter_unrelenting_technology-browser-action\",\"jid1-zadieub7xozojw_jetpack-browser-action\",\"_4f391a9e-8717-4ba6-a5b1-488a34931fcb_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"home-button\",\"urlbar-container\",\"screenshot-button\",\"zoom-controls\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"transmitter_unrelenting_technology-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"jid1-zadieub7xozojw_jetpack-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_4f391a9e-8717-4ba6-a5b1-488a34931fcb_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":4}");
      user_pref("sidebar.visibility", "hide-sidebar");
      user_pref("browser.uidensity", 2);
    EOF

# Setup Git
[group('Setup')]
giddyos-setup-git:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Setting up Git config..."

    # Ask for Git username and email
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email

    # Configure Git
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global pull.rebase true

    echo "Git setup complete"

# Mount drives
[group('Setup')]
giddyos-mount-drives:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Mounting drives..."

    sudo mkdir -p /run/media/$USER/games
    sudo chown $USER:$USER /run/media/$USER/games
    sudo su -c "echo '/dev/disk/by-label/games /run/media/$USER/games auto nosuid,nodev,nofail,x-gvfs-show 0 0' >> /etc/fstab"
    sudo systemctl daemon-reload
    sudo mount -a

# Install Horizon Client
[group('Install')]
giddyos-install-horizon-client:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Downloading Horizon Client..."
    wget -O /tmp/horizon-client.rpm https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
    echo "Horizon Client download complete."
    echo "Installing Horizon Client..."
    sudo rpm-ostree install /tmp/horizon-client.rpm

# Setup User Directories
[group('Setup')]
giddyos-setup-user-dirs:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Setting up user directories..."
    sed -i.bak 's/$HOME\/Desktop\//$SHOME\//' $HOME/.config/user-dirs.dirs 
    sed -i 's/$HOME\/Music\//$SHOME\//' $HOME/.config/user-dirs.dirs 
    sed -i 's/$HOME\/Pictures\//$SHOME\//' $HOME/.config/user-dirs.dirs 
    sed -i 's/$HOME\/Public\//$SHOME\//' $HOME/.config/user-dirs.dirs 
    sed -i 's/$HOME\/Templates\//$SHOME\//' $HOME/.config/user-dirs.dirs 
    sed -i 's/$HOME\/Videos\//$SHOME\//' $HOME/.config/user-dirs.dirs 
    sed -i 's/$HOME\/Documents\//$SHOME\/Nextcloud\/Documents\//' $HOME/.config/user-dirs.dirs 

    echo "Removing old user directories"
    rm -rf $HOME/Desktop
    rm -rf $HOME/Music
    rm -rf $HOME/Pictures
    rm -rf $HOME/Public
    rm -rf $HOME/Templates
    rm -rf $HOME/Videos
    rm -rf $HOME/Documents
