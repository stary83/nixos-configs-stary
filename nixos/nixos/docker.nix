{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker = {
    enable = true;
    #rootless = {
    #  enable = true;
    #  setSocketVariable = true;
    #};
  };

  # Optional: Add your user to the "docker" group to run docker without sudo
  users.users.stary.extraGroups = [ "docker" ];
}
