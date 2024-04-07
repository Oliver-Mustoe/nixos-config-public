{ config, pkgs, ... }:
{
  # Home manager is like an extra config - username and home directory specifies what home manager should manage
  home = {
    username = "om";
    homeDirectory = "/home/om";
    stateVersion = "23.11";
  };

  programs.rofi = {
    enable = true;
    theme = "sidebar";
  };

  home.file.".config/nvim" = {
    source = ../../configs/nvim;
    recursive = true;
    executable = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
    };
    shellIntegration.enableFishIntegration = true;
    theme = "VSCode_Dark";
  };

 gtk = {
  enable = true;
 
  cursorTheme = {
    name = "Bibata-Original-Ice";
 
    package = pkgs.bibata-cursors;
  };
 };

  dconf.settings = {
    # Get settings from "dconf dump /" - NEED TO LOGOUT AND LOG BACK IN FOR THEM TO APPLY PROPERLY!
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      toolkit-accessibility = "false";
      enable-hot-corners = false;
    };
    "org/gnome/shell" = {
      last-selected-power-profile = "performance";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/om/nixos-config/backgrounds/dunny.png";
      picture-uri-dark = "file:///home/om/nixos-config/backgrounds/dunny.png";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/om/nixos-config/backgrounds/dunny.png";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        #THE END SLASHES ARE NEEDED BTW!!!
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>w";
      command = "chromium";
      name = "Browser";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>x";
      command = "kitty";
      name = "Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>r";
      command = "rofi -show drun";
      name = "rofi";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super>l";
      command = "dm-tool switch-to-greeter";
      name = "lock";
    };
  };


  #programs.neovim = { # Not like the regular nixos package - DOES TAKE INTO ACCOUNT .config/init.lua
  # defaultEditor = true;
  # vimAlias = true;
  # viAlias=true;
  # extraConfig = ''
  #   set relativenumber
  #   syntax on
  #   set shiftwidth=2
  #   set tabstop=2
  #   set expandtab
  #   set nobackup
  #   set scrolloff=10
  #   set nowrap
  #   set incsearch
  #   set ignorecase
  #   set showcmd
  #   set showmode
  #   set showmatch
  #   set hlsearch
  #   colorscheme slate
  # '';
  #};
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

}
