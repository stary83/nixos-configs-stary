{ pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 80 443 54112 ];
  services = {

    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "telegram_reposts" ];
      ensureUsers = [{
        name = "webuser";
        ensurePermissions = { "telegram_reposts.*" = "ALL PRIVILEGES"; };
      }];
      settings = {
        mysqld = {
          innodb_buffer_pool_size = "128M";
          innodb_log_file_size = "64M";
        };
      };
    };


    httpd = {
      enable = true;

      enablePHP = true;
      phpPackage = pkgs.php84.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [ curl gd mbstring opcache pdo zip ]));
        extraConfig = ''
          upload_max_filesize = 64M
          post_max_size = 64M
          memory_limit = 256M
        '';
      };

      virtualHosts = {
        localhost = {
          documentRoot = "/srv/htdocs";   # ← put your PHP files here
          extraConfig = ''
            <Directory "/srv/htdocs">
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
            </Directory>

           DirectoryIndex index.php index.html
          '';
        };
      };
    };
  }; 
}
