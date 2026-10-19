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

## Updating
`flake.nix` pins an exact version and hash, so builds are reproducible and never
fail with a hash mismatch when upstream publishes a new canary.

A daily GitHub Action (`.github/workflows/update-fluxer.yml`) reads
`https://pkgs.fluxer.com/desktop/canary/linux/x64/latest`, bumps `version` and
`hash`, builds, and pushes.

To update by hand:
```bash
v=2026.1015.15314   # version from the latest metadata
nix hash convert --hash-algo sha256 --to sri \
  $(nix-prefetch-url https://pkgs.fluxer.com/desktop/canary/linux/x64/$v/appimage)
```
Put the version and resulting hash in `flake.nix`.

## License
MIT
