{
  pkgs,
  lib,
  username,
  inputs,
  config,
  ...
}: let
  inherit (inputs) self;
  nixosModules = with self.nixosModules; [
    common

    power-saving

    desktops.hyprland
    #desktops.plasma6
  ];
in {
  imports =
    [
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.microsoft-surface-common
    ]
    ++ nixosModules;

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages;
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkForce "ondemand";

  #microsoft-surface.ipts.enable = true; # custom surface-linux kernel required
  #microsoft-surface.surface-control.enable = true;

  home-manager.users.${username} = import ./home.nix;

  services = {
    syncthing.settings = {
      devices = {
        "main-desktop".id = "2Z6PAMN-W3IBRFR-Z7JC3S4-JFQFY6T-TF4JVR5-F6XK3M4-HLOF7YE-OZF6PA4";
        "samsung-phone".id = "ILJUQUQ-55IYYIO-LBQ66ZC-7UZDPR3-FER5YO5-KRM2SDX-VXWOH6H-VLWOMQGWOMQG";
      };

      folders = {
        "nixos-config" = {
          devices = ["main-desktop"];
          path = "~/.config/nixos/";
        };

        "obsidian" = {
          devices = ["main-desktop" "samsung-phone"];
          path = "~/Documents/Obsidian/";
        };

        "ags" = {
          devices = ["main-desktop"];
          path = "~/.config/ags/";
        };

        "quickshell" = {
          devices = ["main-desktop"];
          path = "~/.config/quickshell/";
        };
      };
    };
  };

  programs.droidcam.enable = true;

  networking = {
    hostName = "${username}-surface-laptop-nixos";
    firewall = {
      allowedTCPPorts = [7236 7250];
      allowedUDPPorts = [51820 7236 5353];
    };
  };
}
