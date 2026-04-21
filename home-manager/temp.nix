{ pkgs, ... }:
{

  home.packages = with pkgs; [
    apacheHttpd
    nodejs_24

  ]; 

}
