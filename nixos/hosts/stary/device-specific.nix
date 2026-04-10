{ pkgs, ... }:
{
  

  services.xserver.videoDrivers = ["intel"]; 

  hardware = {
    graphics = {
      enable = true;
      ### for intel check nixos wiki for davinci resolve if problem occurs ###
      extraPackages = with pkgs; [
        intel-compute-runtime
	rocmPackages.clr
      ];
      ########################################################################
    };
  };

  boot = {
    loader = {
      grub = {
        enable = true;
	device = "/dev/sda";
	useOSProber = true;
      }; 
    };
  };

}
