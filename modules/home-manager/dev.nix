{ pkgs, ... }:
{
    home.packages = with pkgs; [
        conda
        jetbrains.idea-community
        cargo
        python3
        neofetch
        openjdk
        nodejs
        gnumake
        jq
        cmake
        ninja
        pkg-config
        gcc
        xorg.xeyes
        socat
        ripgrep
        partition-manager
        filelight
        gh
    ];
}
