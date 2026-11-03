{
  description = "Fluxer canary NixOS package (always runs the latest release)";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

      base = "https://pkgs.fluxer.com/desktop/canary/linux/x64";

      launcher = pkgs.writeShellApplication {
        name = "fluxer-canary";
        runtimeInputs = with pkgs; [ curl jq coreutils findutils appimage-run ];
        text = ''
          base="${base}"
          cache="''${XDG_CACHE_HOME:-$HOME/.cache}/fluxer-canary"
          mkdir -p "$cache"

          # Ask the provider what the latest version is (short timeout so an
          # offline start-up is not delayed).
          version=""
          if meta=$(curl -fsSL --max-time 5 -H 'Accept: application/json' "$base/latest" 2>/dev/null); then
            version=$(printf '%s' "$meta" | jq -r '.version // .latest.version // empty' 2>/dev/null || true)
          fi

          appimage=""
          if [[ "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
            appimage="$cache/$version.AppImage"
            if [ ! -x "$appimage" ]; then
              tmp=$(mktemp "$cache/download.XXXXXX")
              if curl -fSL --retry 3 -o "$tmp" "$base/$version/appimage"; then
                chmod +x "$tmp"
                mv "$tmp" "$appimage"
                # Drop older cached releases.
                find "$cache" -maxdepth 1 -name '*.AppImage' ! -name "$version.AppImage" -delete
              else
                rm -f "$tmp"
                appimage=""
              fi
            fi
          fi

          # Offline or provider hiccup: fall back to the newest cached copy.
          if [ -z "$appimage" ] || [ ! -x "$appimage" ]; then
            appimage=$(find "$cache" -maxdepth 1 -name '*.AppImage' | sort -V | tail -n1)
          fi

          if [ -z "$appimage" ]; then
            echo "fluxer-canary: could not download the latest release and no cached copy exists." >&2
            exit 1
          fi

          exec appimage-run "$appimage" "$@"
        '';
      };

      desktopItem = pkgs.makeDesktopItem {
        name = "fluxer-canary";
        desktopName = "Fluxer Canary";
        exec = "fluxer-canary %U";
        terminal = false;
        comment = "Instant messaging and VoIP application";
        categories = [ "Network" "InstantMessaging" ];
        mimeTypes = [ "x-scheme-handler/fluxer" ];
        startupWMClass = "fluxer-canary";
        startupNotify = true;
      };

      fluxer-canary = pkgs.symlinkJoin {
        name = "fluxer-canary";
        paths = [ launcher desktopItem ];
        meta.mainProgram = "fluxer-canary";
      };
    in {
      packages.${system} = {
        inherit fluxer-canary;
        default = fluxer-canary;
      };
    };
}
