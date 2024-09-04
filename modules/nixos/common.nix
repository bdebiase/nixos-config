{
  username,
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) self;
  nixosModules = with self.nixosModules; [
    core
    audio
    #kdeconnect
    syncthing
  ];
in {
  imports = nixosModules;

  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    bluetooth.enable = true;

    graphics.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  networking = {
    networkmanager = {
      enable = true;
      #wifi.powersave = false;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  documentation.enable = false;

  security.pki.certificates = [
    "/etc/ssl/certs/localhost+1.crt"
  ];

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups = ["networkmanager" "wheel" "audio"];
    shell = pkgs.fish;
  };

  systemd.coredump.enable = false;

  services = {
    flatpak.enable = true;
    printing.enable = true;

    #mullvad-vpn = {
    #  enable = true;
    #  enableExcludeWrapper = false;
    #};

    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };

    logind.extraConfig = ''
      HandlePowerKey=ignore
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=ignore
    '';
  };

  programs = {
    #nix-ld.enable = true; # enables running binaries
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    bindfs
    git
    git-lfs
    gh
    htop
    ncdu
  ];

  # set user icon for accountsservice
  system.activationScripts.script.text = ''
    cp /home/${username}/.config/nixos/hosts/${username}/user-avatar.jpg /var/lib/AccountsService/icons/${username}
  '';
}
