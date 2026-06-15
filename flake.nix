outputs = { self, nixpkgs, ... }: {
  nixosConfigurations.charles = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      {
        nixpkgs.overlays = [
          (final: prev: {
            fluxer = prev.appimageTools.wrapType2 {
              pname = "fluxer-canary";
              version = "2026.602.31138";
              src = prev.fetchurl {
                url = "https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/2026.602.31138/appimage";
                sha256 = "0dmfzd3x652w5dr3h39bkzlxvq3vr3lmyg2sxslqrjnn19dl10bp";
              };
            };
          })
        ];
      }
    ];
  };
};
