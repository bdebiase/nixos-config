{writeScriptBin}: {configName}:
writeScriptBin "nixos-update" ''
  sudo nixos-rebuild switch --flake ~/.config/nixos/#"${configName}"
''
