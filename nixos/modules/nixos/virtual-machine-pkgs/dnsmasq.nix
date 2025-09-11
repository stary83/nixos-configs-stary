{ pkgs, lib, config, ... }: {

  options = {
    dnsmasq.enable =
      lib.mkEnableOption "enables dnsmasq";
  };

  config = lib.mkIf config.dnsmasq.enable {
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];
  };
}
