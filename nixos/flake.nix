{
  description = "Nixos config flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";


    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    swww.url = "github:LGFae/swww";
    nixvim = { 
      # url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-index-database.follows = "nix-index-database";
    };

    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";

      # Optional: Override the nixpkgs input of prismlauncher to use the same revision as the rest of your flake
      # Note that this may break the reproducibility mentioned above, and you might not be able to access the binary cache
      #
      # inputs.nixpkgs.follows = "nixpkgs";
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

  };

}
