{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "1.1.1.1" "8.8.8.8" ];
      # log-driver = "journald";
      # registry-mirrors = [ "https://mirror.gcr.io" ];
      # storage-driver = "overlay2";
    };
    #rootless = {
    #  enable = true;
    #  setSocketVariable = true;
    #};
  };

  # Optional: Add your user to the "docker" group to run docker without sudo
  users.users.stary.extraGroups = [ "docker" ];
}
