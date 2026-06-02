{ ... }:
{
  nix = {
    # i add nix-command and flakes, in my main flake files
    # extraOptions = "experimental-features = nix-command flakes";

    gc = {
      # Perform garbage collection weekly to maintain low disk usage
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      # Optimize storage
      # You can also manually optimize the store via:
      #    nix-store --optimise
      # Refer to the following link for more details:
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;

      # Allow DevEnv to merge binary caches with the system Nix store
      extra-substituters = [
        # "https://devenv.cachix.org"
      ];
      extra-trusted-public-keys = [
        # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };
}
