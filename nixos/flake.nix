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
    #sddm-sugar-candy-nix = {
    #  url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
    #  inputs.nixpkgs.follows = "nixpkgs"; # Optional, by default this flake follows nixpkgs-unstable.
    #};
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/configuration.nix
	./modules/nixos
	inputs.home-manager.nixosModules.default
	{
	  home-manager.backupFileExtension = "backup";
	}
	inputs.stylix.nixosModules.stylix
      ];
    };
    
    homeManagerModules.default = ./modules/home-manager;



  };
}
