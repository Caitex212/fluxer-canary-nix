{
  description = "Fluxer canary NixOS overlay";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      packages.${system}.fluxer-canary = pkgs.appimageTools.wrapType2 {
        pname = "fluxer-canary";
        version = "2026.921.180628";
        src = pkgs.fetchurl {
          url = "https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/2026.921.180628/appimage";
          sha256 = "0h2zb412ybqjcbd86jgndvf1d6scnzwph8lamjzxrmkpdvlm2b56";
        };
        extraInstallCommands = ''
          mkdir -p $out/share/applications
          cat > $out/share/applications/fluxer-canary.desktop << EOF
          [Desktop Entry]
          Name=Fluxer Canary
          Exec=fluxer-canary %U
          Terminal=false
          Type=Application
          Icon=fluxer-canary
          StartupWMClass=fluxer-canary
          Comment=Instant messaging and VoIP application
          Categories=Network;InstantMessaging;
          MimeType=x-scheme-handler/fluxer;
          StartupNotify=true
          EOF
        '';
      };
    };
}
