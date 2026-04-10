{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = [
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
