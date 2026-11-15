{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    wlctl = {
      url = "github:aashish-thapa/wlctl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, wlctl, ... }@inputs:
    let
      system = "x86_64-linux";

      mkHost = host: nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs wlctl;
        };

        modules = [
          ./hosts/${host}

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.niezlykoksu = import ./home;
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        nixos-desktop = mkHost "nixos-desktop";
        nixos-laptop = mkHost "nixos-laptop";
      };
    };
}
