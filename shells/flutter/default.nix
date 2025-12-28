{
  mkShellNoCC,
  pkgs,
  ...
}:
mkShellNoCC {
  packages = with pkgs; [
    # iOS builds: Flutter uses CocoaPods for plugin integration
    cocoapods

    # Android builds / tooling
    nix-unstable.jdk17
    nix-unstable.android-tools # adb, fastboot
  ];

  shellHook = ''
    # Prefer system toolchain over nixpkgs-provided clang/SDKs
    unset DEVELOPER_DIR SDKROOT CC CXX NIX_CC NIX_CFLAGS_COMPILE NIX_CXXSTDLIB_COMPILE

    export FLUTTER_ROOT="$HOME/flutter"
    export PUB_CACHE="$HOME/.pub-cache"
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"

    export PATH="$FLUTTER_ROOT/bin:$PUB_CACHE/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

    printf "\n    \033[1;35m🦋 Flutter DevShell\033[0m\n\n"
  '';
}
