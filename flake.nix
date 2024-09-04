{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {url = "github:musnix/musnix";};
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    aylur-dotfiles.url = "github:bdebiase/aylur-dotfiles";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed-editor = {
      url = "github:zed-industries/zed";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    system = "x86_64-linux";

    createSystem = username: hostname: configPath:
      nixosSystem {
        inherit system;
        modules = [
          configPath
          ({pkgs, ...}: {
            environment.systemPackages = with pkgs; [
              (nixos-update {
                configName = hostname;
              })
            ];
          })
        ];
        specialArgs = {
          inherit inputs;
          inherit username;
        };
      };

    hostsDir = ././hosts;
    hosts = let
      dirs = builtins.attrNames (builtins.readDir hostsDir);
      hostSystems = builtins.map (userDir: let
        userPath = hostsDir + "/${userDir}";
        deviceDirs = builtins.attrNames (builtins.readDir userPath);
        systems =
          builtins.map (deviceDir: let
            devicePath = userPath + "/${deviceDir}";
            configPath = devicePath + "/configuration.nix";
            hostname = "${userDir}/${deviceDir}";
          in {
            "${hostname}" = createSystem userDir hostname configPath;
          })
          deviceDirs;
      in
        builtins.foldl' (a: b: a // b) {} systems)
      dirs;
    in
      builtins.foldl' (a: b: a // b) {} hostSystems;
  in {
    nixosConfigurations = hosts;

    overlays = import ./overlays;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
  };
}
