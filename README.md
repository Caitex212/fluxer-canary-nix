# Unofficial fluxer-canary-nix
NixOS package for the [Fluxer canary](https://canary.fluxer.app) desktop client.

## Usage

### Inputs:
```nix
# Fluxer
fluxer-canary.url = "github:Caitex212/fluxer-canary-nix";
fluxer-canary.inputs.nixpkgs.follows = "nixpkgs";
```

### Packages:
```nix
environment.systemPackages = [
  inputs.fluxer-canary.packages.${stdenv.hostPlatform.system}.fluxer-canary
];
```

## Updating (Note to myself)
I use this link to find out what the newest canary version is:
```
https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/latest/appimage
```
Then I use this to get the hash:
```bash
nix-prefetch-url https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/2026.602.31138/appimage
```

## License
MIT
