# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hm, unstable, ... }:

{
  # Will need to get your own hardware
  imports =
    [
      # Include the results of the hardware scan. Assuming its in the default location!
      ./hardware-configuration.nix
    ];
  # Flakes time baby
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    device = "nodev";
    efiSupport = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop01"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Pantheon Desktop Environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "/home/om/nixos-config/backgrounds/windowsfunny.jpg";
  };
  services.xserver.desktopManager.gnome = {
    enable = true;
  };
  #services.xserver.desktopManager.pantheon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.om = {
    isNormalUser = true;
    description = "om";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      pkgs.discord
      pkgs.chromium
      pkgs.firefox
      pkgs.libreoffice
      pkgs.steam
      pkgs.gcc
      pkgs.cargo
      pkgs.neovim
      pkgs.unzip
      pkgs.wget
      pkgs.btop
      pkgs.spotify
      pkgs.tree
      unstable.obsidian
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
  ];
  environment.variables.EDITOR = "neovim";

  # Program setup
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        ll = "ls -la";
        vi = "nvim";
        vim = "nvim";
      };
    };
    # neovim = {
    # 	enable = true;
    # 	defaultEditor = true;
    # 	vimAlias = true;
    # 	viAlias=true;
    # 	configure = {
    #      customRC = ''
    #        set relativenumber
    #        syntax on
    #        set shiftwidth=2
    #        set tabstop=2
    #        set expandtab
    #        set nobackup
    #        set scrolloff=10
    #        set nowrap
    #        set incsearch
    #        set ignorecase
    #        set showcmd
    #        set showmode
    #        set showmatch
    #        set hlsearch
    #        colorscheme slate
    #      '';
    # 	};
    # };
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
    #dconf = {
    #  # Taken from https://gitlab.com/engmark/root/-/blob/master/configuration.nix
    #  enable = true;
    #  profiles.user.databases = [
    #    {
    #      settings = {
    #        # Get settings from "dconf dump /" - NEED TO LOGOUT AND LOG BACK IN FOR THEM TO APPLY PROPERLY!
    #        "org/gnome/desktop/interface" = {
    #          color-scheme = "prefer-dark";
    #          toolkit-accessibility = "false";
    #        };
    #        "org/gnome/shell" = {
    #          last-selected-power-profile = "performance";
    #        };
    #        "org/gnome/settings-daemon/plugins/media-keys" = {
    #          custom-keybindings = [
    #            #THE END SLASHES ARE NEEDED BTW!!!
    #            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    #            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    #            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
    #            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
    #          ];
    #        };
    #        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    #          binding = "<Super>w";
    #          command = "chromium";
    #          name = "Browser";
    #        };
    #        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
    #          binding = "<Super>x";
    #          command = "kitty";
    #          name = "Terminal";
    #        };
    #        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
    #          binding = "<Super>r";
    #          command = "rofi -show drun";
    #          name = "rofi";
    #        };
    #        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
    #          binding = "<Super>l";
    #          command = "dm-tool switch-to-greeter";
    #          name = "lock";
    #        };
    #      };
    #    }
    #  ];
    #};
  };


  # Nividia tomfoolery - look here https://nixos.wiki/wiki/Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Setup prime
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = PCI:00:02:0;
      nvidiaBusId = PCI:01:00:0;
    };
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
