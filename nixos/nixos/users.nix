{ pkgs, ... }:
{

  users.users.stary = {
      isNormalUser = true;
      initialPassword = "123456";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      description = "stary";
      shell = pkgs.bash;
      packages = with pkgs; [
      ];
  };

}
