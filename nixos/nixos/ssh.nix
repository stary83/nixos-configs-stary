# In your home.nix or user-specific flake
{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    # This ensures only the keys you specify below are used, preventing SSH from trying all keys.
    matchBlocks = {
      # This is the 'Host myvps' alias from your manual config
      "myvps" = {
        hostname = "82.22.41.207";
        user = "nimainer";
        port = 22;
        identityFile = "~/.ssh/vps_key"; # The specific key for this VPS
        identitiesOnly = true;           # Critical: only use the key above, ignore agent
      };

      "myvps-root" = {
        hostname = "82.22.41.207";
        user = "root";
        port = 22;
        identityFile = "~/.ssh/vps_key"; # The specific key for this VPS
        identitiesOnly = true;           # Critical: only use the key above, ignore agent
      };
      
      # Example for multiple GitHub accounts (as discussed)
      "github" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
    # All your other client settings
    extraConfig = ''
      ServerAliveInterval 60
      AddKeysToAgent yes
    '';
  };
}
