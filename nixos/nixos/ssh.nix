# In your home.nix or user-specific flake
{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    # This ensures only the keys you specify below are used, preventing SSH from trying all keys.
    matchBlocks = {
      # example setup for vps
      # "myvps" = {
      #   hostname = "123.123.123.123";
      #   user = "ubuntu";
      #   port = 22;
      #   identityFile = "~/.ssh/vps_key"; # The specific key for this VPS
      #   identitiesOnly = true;           # Critical: only use the key above, ignore agent
      #  };

      "github" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

    };
    # All your other client settings
    extraConfig = ''
      ServerAliveInterval 20
      AddKeysToAgent yes
    '';
  };
}
