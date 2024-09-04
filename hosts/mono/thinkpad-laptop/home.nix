{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = with inputs.self.homeManagerModules; [
    common
  ];

  home = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    packages = with pkgs; [
      floorp
      firefox
      obsidian
      gimp-with-plugins
      fprintd
      libreoffice

      intellijpatch

      #Cyber Sec
      nmap
      #burpsuite
      wireshark
      john
      hashcat
      ffuf
      protonvpn-gui
    ];
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      #"wlr-randr --output HDMI-A-1 --off && sleep 1 && wlr-randr --output HDMI-A-1 --on --pos 1921,0"
      "xrandr --output DP-2 --primary"

      "hyprctl dispatch exec 'firefox'"
      "hyprctl dispatch exec 'obsidian'"
    ];

    # https://wiki.hyprland.org/Configuring/Monitors/
    monitor = [
      "eDP-1, 2560x1600@165.00,0x0, 1.333, bitdepth,10"
      ", preferred, auto, 1.333, bitdepth, 10"
    ];

    misc = {
      vrr = 1;
    };

    input = {
      sensitivity = lib.mkForce 0.65;
      accel_profile = "adaptive";
    };
  };
}
