{ inputs, pkgs, ... }:
{
    environment.systemPackages =  with pkgs; [
        piper # mouse dpi settings
    ];

    services = {
        ratbagd.enable = true; # required by piper
    };

    programs = {
        gamescope = {
            enable = true;
            capSysNice = true;
        };
        gamemode.enable = true;
        steam.enable = true;
    };
}