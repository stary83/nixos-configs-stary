{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    swww.url = "github:LGFae/swww";
    nixvim = { 
        url = "github:nix-community/nixvim/nixos-25.05";
        # url = "github:nix-community/nixvim";
        # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
        inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
      host = "stary";
    in {

    homeManagerModules.${host} = ./modules/home-manager;
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/stary/configuration.nix
	./modules/nixos
	inputs.home-manager.nixosModules.default
	{
	  home-manager.backupFileExtension = "backup";
	}
	inputs.stylix.nixosModules.stylix
	inputs.nixvim.nixosModules.nixvim
      ];
    };

  };


}
