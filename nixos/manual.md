# everything not decalaritve

- ### Distrobox :

#### ai
---
i use distrobox for running ai since it needs a standard filesystem and managing that with nix would be too compelex and simply using docker wouldn't cover all my needs.

#### vpn
---
same with vpns, v2rayn, windscribe etc they all are ran inside containers since setting up tun mode and compiling them manually is more work.

everything is managed with .ini container files and the actions needed for each container are written in the .ini files themselves

- ### File backups : 
#### for many programs there is no easy way to backup the files or configure them decalaretively so here is everything that needs manuall backup and then deployment if changing machines:
- odysseus
- opencode
- freebuff
- v2rayn
- prismlauncher instances
- freetube
- ssh keys
- thunderbird

google chrome and vscode will also need backups if i don't want to login to them everytime

---

note: maybe i'll write a script to do all the file backups automatically



