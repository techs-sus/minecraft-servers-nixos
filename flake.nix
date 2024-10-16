{
  description = "NixOS config for minecraft gamer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-24.05";
    flux.url = "github:IogaMaster/flux";
    flux.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, flux, ... }:
    {
      nixpkgs.overlays = [ flux.overlays.default ];

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        minecraft = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/configuration.nix

            {
              flux = {
                enable = true;
                servers = {
                  hardcore-minecraft = {
                    package = nixpkgs.mkMinecraftServer {
                      name = "hardcore";
                      src = ./servers/hardcore; # Path to a mcman config
                      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                    };
                    proxy.enable = true;
                    proxy.backend = "playit";

                  };
                };
              };
            }
            flux.nixosModules.default
          ];
        };
      };
    };
}
