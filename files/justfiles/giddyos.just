[private]
default:
    @just --list

# Post-install setup
[group('Install')]
giddyos-post-install: giddyos-configure-firefox giddyos-download-horizon-client giddyos-configure-desktop giddyos-configure-extensions giddyos-mount-drives && giddyos-install-horizon-client

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

# Download Horizon Client
[group('Install')]
giddyos-download-horizon-client:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Downloading Horizon Client..."
  wget -O /tmp/horizon-client.rpm https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
  echo "Horizon Client download complete."

# Install Horizon Client
[group('Install')]
giddyos-install-horizon-client:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Horizon Client..."
  sudo rpm-ostree install /tmp/horizon-client.rpm
  echo "Horizon Client installation complete. You will need to reboot to see it."

# Configure Desktop
[group('Setup')]
giddyos-configure-desktop:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Configuring desktop..."
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
  gsettings set org.gnome.desktop.interface cursor-size 48

  # configure gnome display settings
  gdctl set \
    --logical-monitor --primary --monitor DP-2 --scale 1.66 \
    --logical-monitor --monitor HDMI-1 --right-of DP-2 --scale 1.66

# Configure Extensions
[group('Setup')]
giddyos-configure-extensions:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Configuring extensions..."

  # Dash to Panel
  dconf write /org/gnome/shell/extensions/dash-to-panel/multi-monitors false
  dconf write /org/gnome/shell/extensions/dash-to-panel/panel-positions \''{"PHL-0x00000648":"LEFT","PHL-0x0000092a":"LEFT"}'\'
  dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes \''{"PHL-0x00000648":56,"PHL-0x0000092a":56}'\'
  dconf write /org/gnome/shell/extensions/dash-to-panel/dot-position \''LEFT'\'
  dconf write /org/gnome/shell/extensions/dash-to-panel/panel-element-positions \''{"PHL-0x00000648":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}],"PHL-0x0000092a":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'\'

  # Forge
  dconf write /org/gnome/shell/extensions/forge/dnd-center-layout 'swap'
  dconf write /org/gnome/shell/extensions/forge/stacked-tiling-mode-enabled false
  dconf write /org/gnome/shell/extensions/forge/tabbed-tiling-mode-enabled false

# Mount drives
[group('Setup')]
giddyos-mount-drives:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Mounting drives..."

  sudo mkdir /mnt/games
  sudo su -c "echo '/dev/disk/by-label/games /mnt/games auto nosuid,nodev,nofail,x-gvfs-show 0 0' >> /etc/fstab"
  sudo systemctl daemon-reload
  sudo mount -a

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

  echo "Git setup complete"
