{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    swww.url = "github:LGFae/swww";
    nixvim = { 
        url = "github:nix-community/nixvim/nixos-25.11";
        # url = "github:nix-community/nixvim";
        # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
        inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      host = "stary";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {

    nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [

        home-manager.nixosModules.home-manager
        {
	  home-manager.backupFileExtension = "bkp";
          home-manager.users.${host} = import ./hosts/${host}/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
	    inherit pkgs;
	  };
        }
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        }
	inputs.stylix.nixosModules.stylix
	inputs.nixvim.nixosModules.nixvim
        ./hosts/${host}/configuration.nix
      ];
    };
    # homeConfigurations."${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    #   inherit pkgs;
    #   modules = [
    #     ./hosts/${host}/home.nix
    #   ];
    # };

  };


}
