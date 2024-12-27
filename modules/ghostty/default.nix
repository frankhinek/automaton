{ config, ghostty, ... }:
{
  home.packages = [
    ghostty.packages.aarch64-darwin.default
  ];

  xdg.configFile."ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}