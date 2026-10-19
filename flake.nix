{
  description = "Fluxer canary NixOS overlay";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

      # Pinned release. Both values are bumped together by
      # .github/workflows/update-fluxer.yml - never edit one without the other.
      version = "2026.1018.223341";
      hash = "sha256-pdp+SZhgXSSFxoN7lnrQLZEuPpSYEm/rPrTlJJECdMY=";
    in {
      packages.${system}.fluxer-canary = pkgs.appimageTools.wrapType2 {
        pname = "fluxer-canary";
        inherit version;
        src = pkgs.fetchurl {
          # Versioned URL: the bytes behind it never change, so the hash stays valid.
          url = "https://pkgs.fluxer.com/desktop/canary/linux/x64/${version}/appimage";
          inherit hash;
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
