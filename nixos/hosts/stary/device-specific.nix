{ pkgs, ... }:

{
  services.xserver.videoDrivers = ["intel"]; 
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
    rocmPackages.clr
  ];
}
