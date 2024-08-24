{pkgs, ...}: {
  #home = {
  #  sessionVariables = {
  #    QT_STYLE_OVERRIDE = "kvantum";
  #  };

  #  packages = with pkgs; [
  #    catppuccin-kvantum
  #  ];
  #};

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
      General.theme = "Catppuccin-Frappe-Blue";
    };

    "Kvantum/Catppuccin-Frappe-Blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Frappe-Blue";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    #style.name = "kvantum";
  };
}
