{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = with inputs.self.homeManagerModules; [
    home
    shell

    programs.alacritty
    programs.direnv
    programs.neovim
    programs.vesktop
    programs.vscode
    programs.tmux
    programs.quickshell

    # custom web apps
    programs.bandlab
    programs.chatgpt
    programs.reddit
    programs.messages
    programs.spotify
    programs.syncthing
    programs.youtube
  ];

  home.packages = with pkgs; [
    # custom scripts
    editconf
    rmshit # bypasses homemanager bug
    bkqs

    brave
    whatsapp-for-linux
    neovide
  ];

  home.file.".config/background".source = ../../hosts/${username}/wallpaper.jpg;
}
