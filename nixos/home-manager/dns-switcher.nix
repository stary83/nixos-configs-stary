{ config, pkgs, lib, ... }:
let
  dns-switcher = pkgs.writeScriptBin "dns-switcher" ''
    #!${pkgs.bash}/bin/bash

    rofi_command() {
      ${pkgs.rofi}/bin/rofi -dmenu -i -config "$HOME/.config/rofi/power.rasi"
    }


    get_active_connection() {
        nmcli -t -f NAME,DEVICE,TYPE connection show --active 2>/dev/null | \
        grep -v ':lo:' | head -n1 | cut -d: -f1
    }

    conn=$(get_active_connection)
    if [[ -z "$conn" ]]; then
        echo "Error: No active network connection found."
        exit 1
    fi

    reset="revert to DHCP/default" 
    
    formatted_list="$reset\n$(cat "/etc/nixos/resources/dots/dns-switcher/dns_list.txt")"

    chosen=$(echo -e "$formatted_list" | rofi_command )


    # Apply DNS for a given connection
    set_dns() {
        local conn="$1"
        local dns_servers="$2"
        if [[ -z "$dns_servers" ]]; then
            echo "Clearing custom DNS for '$conn' (reverting to DHCP/default)"
            nmcli connection modify "$conn" ipv4.ignore-auto-dns no
            nmcli connection modify "$conn" ipv4.dns ""
        else
            echo "Setting DNS for '$conn' to: $dns_servers"
            nmcli connection modify "$conn" ipv4.ignore-auto-dns yes
            nmcli connection modify "$conn" ipv4.dns "$dns_servers"
        fi
        # Reactivate connection to apply changes
        nmcli connection up "$conn"
     }

     if [ "$chosen" == "$reset" ]; then
         set_dns "$conn" ""
     else
         set_dns "$conn" "$(echo "$chosen" | sed 's/^.*-> //')"
     fi

  '';

in {
  home.packages = with pkgs; [ dns-switcher ];
}
