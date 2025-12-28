{ config, inputs, ... }: {
  imports = [
    inputs.matugen.nixosModules.default
  ];
  programs.matugen = {
    enable = true;
  };
  home.file.".config/matugen" = {
    source = ../../resources/dots/matugen;
  };

}
