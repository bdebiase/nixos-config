{pkgs, ...}: {
  home.packages = with pkgs; [
    sierra-breeze-enhanced
    roboto
  ];

  #home.file.".config/kwinrc".text = ''
  #  [$Version]
  #  update_info=kwin.upd:replace-scalein-with-scale,kwin.upd:port-minimizeanimation-effect-to-js,kwin.upd:port-scale-effect-to-js,kwin.upd:port-dimscreen-effect-to-js,kwin.upd:auto-bordersize,kwin.upd:make-translucency-effect-disabled-by-default,kwin.upd:enable-scale-effect-by-default,kwin.upd:animation-speed-cleanup,kwin.upd:replace-cascaded-zerocornered,kwin.upd:desktop-grid-click-behavior,kwin.upd:no-swap-encourage,kwin.upd:remove-flip-switch-effect,kwin.upd:remove-cover-switch-effect,kwin.upd:remove-cubeslide-effect,kwin.upd:remove-xrender-backend,kwin.upd:overview-group-plugin-id

  #  [Desktops]
  #  Id_1=b59cd792-973a-4374-829c-93a55ca6ae42
  #  Id_2=c1bced6a-8c64-42aa-9efb-8ca867b3b113
  #  Id_3=b13c67b1-030b-45ca-8824-43a52238abf2
  #  Id_4=553b074d-67f9-41fb-98a3-aa7128868f42
  #  Number=4
  #  Rows=1

  #  [Plugins]
  #  kwin4_effect_squashEnabled=false
  #  magiclampEnabled=true
  #  wobblywindowsEnabled=true

  #  [Tiling]
  #  padding=4

  #  [Tiling][1de09ab7-78e3-5242-9ced-db683b8ff194]
  #  tiles={"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}

  #  [Tiling][e139ac22-aa6f-5448-a962-9491ad51f90a]
  #  tiles={"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}

  #  [Xwayland]
  #  Scale=1.75

  #  [org.kde.kdecoration2]
  #  BorderSize=None
  #  BorderSizeAuto=false
  #  ButtonsOnLeft=MSF
  #  library=org.kde.sierrabreezeenhanced
  #  theme=Sierra Breeze Enhanced
  #'';
}
