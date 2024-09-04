{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (inputs) self;
  nixosModules = with self.nixosModules; [
    common

    adb
    docker
    gaming
    #logitech
    nvidia
    #rt-audio
    ssh
    virtualization
    #wootility
    #zram

    #desktops.cosmic
    desktops.hyprland
    #desktops.plasma6
    #desktops.wayfire
  ];
in {
  imports =
    [
      ./hardware-configuration.nix
      #inputs.nixos-hardware.nixosModules.microsoft-surface-common # enable to build on machine locally, to then be uploaded to cachix
    ]
    ++ nixosModules;

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["v4l2loopback" "snd-aloop"];
    kernelParams = ["usbcore.autosuspend=-1"];
    #rtl88x2bu
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      options nvidia-modeset hdmi_deepcolor=1
    ''; # setup virtual cam and enable hdmi_deepcolor for Nvidia

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  fileSystems."/mnt/LinuxExpansion" = {
    device = "/dev/disk/by-uuid/3441c4de-e929-48b0-ac42-06290f4824ca";
    fsType = "ext4";
  };

  fileSystems."/mnt/NVMEStorageLinux" = {
    device = "/dev/disk/by-uuid/e9c63d72-07d6-454d-86f3-a5a3e15cac00";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/635dd7c6-377f-4d4d-bb5b-4ce5eb547ecd";
    }
  ];

  home-manager.users.${username} = import ./home.nix;

  services = {
    syncthing.settings = {
      devices = {
        "surface-laptop".id = "DVGBQSI-M7XLNZJ-I34CMWR-O4MJQKT-ZH4IGWA-DZO6MXS-SGI7BOH-SZKB4AL";
        "samsung-phone".id = "ILJUQUQ-55IYYIO-LBQ66ZC-7UZDPR3-FER5YO5-KRM2SDX-VXWOH6H-VLWOMQG";
        #"hp-laptop".id = "ZOBRBCR-VIAVOBM-636NUXN-2ITUX57-YTX3SE5-VFVDA2E-2VKSCFI-MZCFNQU";
        "thinkpad-laptop".id = "MDC3QPE-N6PPPUM-6TVWPFQ-2DNR4OG-4J3C6MB-5XP3J7A-FREPFEZ-PUBOYQN";
        "mono-desktop".id = "IGL6Y24-HLWHS6L-CMNZ2YA-2OQLWPQ-W3QAQX2-ZZ5RN44-336PXTH-FV4QFQL";
      };

      folders = {
        "nixos-config" = {
          path = "~/.config/nixos/";
          #devices = ["surface-laptop" "hp-laptop" "thinkpad-laptop" "mono-desktop"];
          devices = ["surface-laptop" "thinkpad-laptop" "mono-desktop"];
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };

        "obsidian" = {
          path = "/mnt/LinuxExpansion/Places/Documents/Obsidian/";
          devices = ["surface-laptop" "samsung-phone"];
          versioning = {
            type = "simple";
            params.keep = "3";
          };
        };

        "ags" = {
          path = "/mnt/LinuxExpansion/git/aylur-dotfiles/ags/";
          devices = ["surface-laptop"];
          versioning = {
            type = "simple";
            param.keep = "3";
          };
        };

        "quickshell" = {
          path = "~/.config/quickshell/";
          devices = ["surface-laptop" "thinkpad-laptop" "mono-desktop"];
          versioning = {
            type = "simple";
            param.keep = "3";
          };
        };
      };
    };
  };

  # Open ports in the firewall.
  # 25565 - Minecraft
  # 24454 - Minecraft voice chat mod
  # 57621 - Spotify discovery
  # Syncthing - TCP: [ 8384 2000 ]
  #             UDP: [ 22000 21027 ]
  # 2222 - SSH
  # 51820 - WireGuard
  # 1714-1764 - KDE Connect
  networking = {
    hostName = "${username}-desktop-nixos";
    firewall = {
      allowedTCPPorts = [
        22
        #25565
        #14242

        # rustdesk server 21114-21119
        #21114
        #21115
        #21116
        #21117
        #21118
        #21119

        9757
      ];
      allowedUDPPorts = [
        #19132
        #25565
        #24454
        #51820
        #14242
        8080

        5353
        9757

        #21116 # rustdesk
      ];
    };
  };
}
