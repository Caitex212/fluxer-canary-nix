{
  description = "Fluxer canary NixOS overlay";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs, ... }: {
    nixosModules.default = { pkgs, ... }: {
      nixpkgs.overlays = [
        (final: prev: {
          fluxer-canary = prev.appimageTools.wrapType2 {
            pname = "fluxer-canary";
            version = "2026.602.31138";
            src = prev.fetchurl {
              url = "https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/2026.602.31138/appimage";
              sha256 = "0dmfzd3x652w5dr3h39bkzlxvq3vr3lmyg2sxslqrjnn19dl10bp";
            };
          };
          extraInstallCommands = ''
            mkdir -p $out/share/applications
            cat > $out/share/applications/fluxer-canary.desktop << EOF
            [Desktop Entry]
            Name=Fluxer Canary
            Exec=fluxer-canary
            Icon=fluxer-canary
            Type=Application
            Categories=Network;
            EOF
          '';
        })
      ];
    };
  };
}
