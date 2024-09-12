{
  adb = import ./adb.nix;
  core = import ./core;
  common = import ./common.nix;
  docker = import ./docker.nix;
  desktops = import ./desktops;
  gaming = import ./gaming.nix;
  kdeconnect = import ./kdeconnect.nix;
  logitech = import ./logitech.nix;
  mysql = import ./mysql.nix;
  nvidia = import ./nvidia.nix;
  power-saving = import ./power-saving;
  rt-audio = import ./rt-audio.nix;
  audio = import ./audio.nix;
  sddm = import ./sddm.nix;
  ssh = import ./ssh.nix;
  syncthing = import ./syncthing.nix;
  tlp = import ./tlp.nix;
  virtualization = import ./virtualization.nix;
  ollama = import ./ollama.nix;
  wootility = import ./wootility.nix;
  zram = import ./zram.nix;
}
