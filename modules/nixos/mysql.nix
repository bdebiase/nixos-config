{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    beekeeper-studio
  ];
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
