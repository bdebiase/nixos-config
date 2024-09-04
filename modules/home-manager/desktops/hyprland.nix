{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.homeManagerModules;
    [
      theme
      xdg

      programs.quickshell

      #programs.ags # shell
      #programs.anyrun # runner
    ]
    ++ [
      inputs.hyprland.homeManagerModules.default
    ];

  #xdg.desktopEntries."org.gnome.Settings" = {
  #  name = "Settings";
  #  comment = "Gnome Control Center";
  #  icon = "org.gnome.Settings";
  #  exec = "XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
  #  categories = ["X-Preferences"];
  #  terminal = false;
  #};

  home = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      #SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";

      NIXOS_OZONE_WL = "1"; # force wayland on electron apps
    };

    packages = with pkgs; [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

      loupe # image viewer
      clapper # video player
      snapshot # camera app
      nautilus # file manager
      baobab # storage visualizer
      file-roller # archive manager
      #gnome-calendar
      gnome-system-monitor
      #gnome-control-center
      #gnome-weather
      gnome-calculator
      #gnome-clocks
      #gnome-software
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      #inputs.hyprshell.packages.${pkgs.system}.hyprshell
      #inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      #inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];

    settings = let
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      pactl = "${pkgs.pulseaudio}/bin/pactl";
    in {
      exec-once = [
        # clipboard client
        #"wl-paste --type text --watch cliphist store"
        #"wl-paste --type image --watch cliphist store"

        #"AGS_SKIP_V_CHECK=true ags -b hypr"
        "quickshell"
      ];

      "plugin:hyprbars" = {
        #bar_color = "rgb(2a2a2a)";
        bar_height = 26;
        #col_text = "rgba(ffffffdd)";
        #bar_text_size = 30;
        #bar_text_font = "Roboto";

        hyprbars-button = [
          "hyprbars-button = rgb(ff4040), 18, 󰖭, hyprctl dispatch killactive"
          "rgb(eeee11), 18, , hyprctl dispatch fullscreen 1"
        ];

        bar_precedence_over_border = true;
      };

      "plugin:hyprshell" = {
        overview_gappo = 56; #gas width from screem
        overview_gappi = 24; #gas width from clients
        enable_hotarea = 0;
        enable_mouse_side_button = 0;
      };

      "plugin:hyprwinwrap" = {
        class = "alacritty-bg";
      };

      "plugin:hyprexpo" = {
        workspace_method = "first 1";
      };

      "plugin:hyprfocus" = {
        enabled = true;
        animate_floating = true;
        focus_animation = "flash";

        bezier = [
          "realsmooth, 0.28, 0.29, 0.69, 1.08"
        ];

        flash = {
          flash_opacity = 0.95;
          in_bezier = "realsmooth";
          in_speed = 0.5;
          out_bezier = "realsmooth";
          out_speed = 3;
        };

        shrink = {
          shrink_percentage = 0.95;
          in_bezier = "realsmooth";
          in_speed = 1;
          out_bezier = "realsmooth";
          out_speed = 2;
        };
      };

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;

        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
      };

      input = {
        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
          clickfinger_behavior = true;
        };

        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        #float_switch_override_focus = 2;
        float_switch_override_focus = 0;
        repeat_delay = 300;
        repeat_rate = 50;
      };

      cursor = {
        enable_hyprcursor = false;
        no_warps = true;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_direction_lock = false;
        workspace_swipe_forever = true;
        #workspace_swipe_numbered = true;
      };

      decoration = {
        drop_shadow = true;
        shadow_range = 48;
        shadow_render_power = 3;
        "col.shadow" = "0x66000000";
        "col.shadow_inactive" = "0x44000000";
        dim_inactive = false;
        dim_special = 0.5;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          ignore_opacity = true;
          popups = true;
        };
      };

      animations = {
        enabled = true;
        first_launch_animation = false;

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "easeOutSine, 0.61, 1, 0.88, 1"
          "easeOutQuad, 0.5, 1, 0.89, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeOutQuart, 0.25, 1, 0.5, 1"
          "easeOutQuint, 0.22, 1, 0.36, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
        ];

        animation = [
          "windows, 1, 3, easeOutExpo, popin 75%"
          "border, 1, 4, easeOutCubic"
          "fade, 1, 2, easeOutCubic"
          "fadeSwitch, 1, 1, easeOutCubic"
          "fadeDim, 1, 1, easeOutCubic"
          "workspaces, 1, 6, easeOutExpo"
          "specialWorkspace, 1, 4, easeOutExpo, slidevert"
          "layers,0"
        ];
      };

      windowrule = let
        float = regex: "float, ${regex}";
        opacity = value: regex: "opacity ${value} ${value}, ${regex}";
        size = value: regex: "size ${value}, ${regex}";
        workspace = value: regex: "workspace ${value}, ${regex}";
        pin = regex: "pin, ${regex}";
        center = regex: "center, ${regex}";
      in [
        (workspace "1 silent" "brave-browser")
        (workspace "2 silent" "vesktop")
        (workspace "3 silent" "spotify")
        (workspace "3 silent" "obsidian")
        (workspace "4 silent" "whatsapp")
        (workspace "5 silent" "steam")
        (workspace "6 silent" "easyeffects")

        (opacity "0.9" "brave")
        (opacity "0.9" "code")
        (opacity "0.9" "vesktop")
        (opacity "0.9" "steam")
        (opacity "0.9" "easyeffects")
        (opacity "0.9" "firefox")

        (float "org.gnome.Nautilus")
        (size "65% 60%" "org.gnome.Nautilus")
        (center "org.gnome.Nautilus")
        (opacity "0.9" "org.gnome.Nautilus")

        (float "xdg-desktop-portal-gtk")
        (size "65% 60%" "xdg-desktop-portal-gtk")
        (center "xdg-desktop-portal-gtk")
        (opacity "0.9" "xdg-desktop-portal-gtk")

        (float "org.gnome.SystemMonitor")
        (size "60% 60%" "org.gnome.SystemMonitor")
        (center "org.gnome.SystemMonitor")
        (pin "org.gnome.SystemMonitor")
        (opacity "0.9" "org.gnome.SystemMonitor")

        (pin "gnome-system-monitor")
        (opacity "0.9" "gnome-system-monitor")
      ];

      windowrulev2 = let
        immediate = class_regex: "immediate, class:${class_regex}";
      in [
        "size 40% 50%, class:(org.gnome.Nautilus),title:(Properties)"
        "float, title:(Picture in picture)"
        "keepaspectratio, initialtitle:(Picture in picture)"
        "float, title:(Discord Popout)"
        "keepaspectratio, initialtitle:(Discord Popout)"
        #(size "40% 50%" "org.gnome.Nautilus" "Properties")
        (immediate "cs2")
        (immediate "steam_app_553850") # helldivers
        (immediate "brave-browser") # helldivers
        #(immediate "steam_app_2420110")
      ];

      bind = let
        ags = "ags -b hypr";
      in [
        # management binds
        "SUPER SHIFT, L, exec, pkill 'Hyprland'" #logout
        "SUPER, Q, killactive"
        "SUPER, M, exit"
        "SUPER, V, togglefloating"
        "SUPER, R, exec, anyrun"
        "SUPER, W, pin"
        "SUPER, P, pseudo" # dwindle
        "SUPER, Y, togglesplit" # dwindle
        "SUPER, F, fullscreen, 0"
        "SUPER SHIFT, F, fullscreen, 1"
        #"SUPER ALT, F, fakefullscreen"

        # application binds
        "SUPER, RETURN, exec, [float; size 60% 60%; center] alacritty"
        "SUPER CTRL, RETURN, exec, [float; size 60% 60%; center] alacritty -e 'nvim ~/.config/nixos'"
        "SUPER SHIFT, RETURN, exec, alacritty"
        "SUPER SHIFT CTRL, RETURN, exec, alacritty -e 'nvim ~/.config/nixos'"
        "SUPER, T, exec, [float; size 60% 60%; center] alacritty"
        "SUPER SHIFT, T, exec, alacritty"
        "SUPER, E, exec, nautilus"
        "SUPER SHIFT CTRL, N, exec, neovide ~/.config/nixos"
        "SUPER SHIFT, N, exec, neovide"
        "SUPER SHIFT, B, exec, brave"
        "SUPER, grave, exec, gnome-system-monitor"

        # window binds
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"

        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, l, movewindow, r"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, j, movewindow, d"

        # workspace binds
        "SUPER ALT, left, workspace, -1"
        "SUPER ALT, right, workspace, +1"
        "SUPER SHIFT ALT, left, movetoworkspace, -1"
        "SUPER SHIFT ALT, right, movetoworkspace, +1"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        "SUPER, S, togglespecialworkspace"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
        "SUPER SHIFT, S, movetoworkspace, special"

        #"SUPER, 1, split-workspace, 1"
        #"SUPER, 2, split-workspace, 2"
        #"SUPER, 3, split-workspace, 3"
        #"SUPER, 4, split-workspace, 4"
        #"SUPER, 5, split-workspace, 5"
        #"SUPER, 6, split-workspace, 6"
        #"SUPER, 7, split-workspace, 7"
        #"SUPER, 8, split-workspace, 8"
        #"SUPER, 9, split-workspace, 9"
        #"SUPER, 0, split-workspace, 10"
        #"SUPER, S, togglespecialworkspace"

        #"SUPER SHIFT, 1, split-movetoworkspace, 1"
        #"SUPER SHIFT, 2, split-movetoworkspace, 2"
        #"SUPER SHIFT, 3, split-movetoworkspace, 3"
        #"SUPER SHIFT, 4, split-movetoworkspace, 4"
        #"SUPER SHIFT, 5, split-movetoworkspace, 5"
        #"SUPER SHIFT, 6, split-movetoworkspace, 6"
        #"SUPER SHIFT, 7, split-movetoworkspace, 7"
        #"SUPER SHIFT, 8, split-movetoworkspace, 8"
        #"SUPER SHIFT, 9, split-movetoworkspace, 9"
        #"SUPER SHIFT, 0, split-movetoworkspace, 10"
        #"SUPER SHIFT, S, movetoworkspace, special"

        # scroll through workspaces using mouse wheel
        "SUPER, mouse_down, workspace, m-1"
        "SUPER, mouse_up, workspace, m+1"

        # ags
        "CTRL SHIFT, R, exec, ${ags} quit; AGS_SKIP_V_CHECK=true ${ags}" # restart
        "CTRL ALT, R, exec, ${ags} quit;" # quit
        "SUPER, Space, exec, ${ags} -t launcher"
        "SUPER, Tab, exec, ${ags} -t overview"
        ", XF86PowerOff, exec, ${ags} -t powermenu"

        # quickshell
        "CTRL SHIFT, Q, exec, pkill quickshell; quickshell" # restart
        "CTRL ALT, R, exec, pkill quickshell;" # quit
        "ALT, SPACE, exec, echo 'togglelauncher' | socat - UNIX-CONNECT:/tmp/quickshell.sock" # toggle launcher
        "SUPER, SPACE, exec, echo 'newworkspace' | socat - UNIX-CONNECT:/tmp/quickshell.sock" # new workspace

        # screenshot & screenrecord
        ", XF86Launch4, exec, ${ags} -r 'recorder.start()'"
        ", Print, exec, ${ags} -r 'recorder.screenshot()'"
        "SHIFT, Print, exec, ${ags} -r 'recorder.screenshot(true)'"
        "CTRL, Print, exec, grimblast copy area"

        #"ALT, tab, hyprshell:toggleoverview"

        #"ALT, tab, hyprexpo:expo, toggle"
      ];

      bindm = [
        # move/resize window with mouse buttons
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindle = [
        ", XF86MonBrightnessUp, exec, ${brightnessctl} set +5%"
        ", XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"
        ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ];

      bindl = [
        ", XF86AudioPlay, exec, ${playerctl} play-pause"
        ", XF86AudioStop, exec, ${playerctl} pause"
        ", XF86AudioPause, exec, ${playerctl} pause"
        ", XF86AudioPrev, exec, ${playerctl} previous"
        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ];
    };
  };
}
