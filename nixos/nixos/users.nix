{ pkgs, ... }:
{

  users.users.stary = {
      isNormalUser = true;
      initialPassword = "123456";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "windscribe" ];
      description = "stary";
      shell = pkgs.bash;
      packages = with pkgs; [
      ];
  };

  users.groups.windscribe = {};

}
