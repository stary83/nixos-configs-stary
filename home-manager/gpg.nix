{ pkgs, lib, config, ... }: {

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      # Enable if you want to use GPG keys for SSH authentication
      enableSshSupport = true;
      # Set cache timeouts (in seconds) to avoid repeated PIN prompts
      defaultCacheTtl = 600;
      maxCacheTtl = 7200;
      # Choose a PIN entry program (options: pkgs.pinentry-curses, pkgs.pinentry-qt, pkgs.pinentry-gtk2, pkgs.pinentry-gnome3, etc.)
      # This is crucial if GPG prompts fail without a UI
      pinentry.package = pkgs.pinentry-curses;
      # Optional: Extra config lines for ~/.gnupg/gpg-agent.conf
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
}
