{ config, pkgs, ... }: {
  users.defaultUserShell = pkgs.bash;
  users.users.diego = {
    isNormalUser = true;
    extraGroups = [
      "input"
      "audio"
      "wheel"
      "video"
      "networkmanager"
      "camera"
      "adbusers"
      "i2c"
      "uucp"
      "transmission"
      "storage"
    ];
    shell = pkgs.fish;
    description = "Diego Barros";
  };
  users.users.greeter.extraGroups = [ "video" ];

  xdg.mime.enable = true;
  xdg.sounds.enable = true;
  xdg.mime.defaultApplications = {
    "inode/directory" = "${pkgs.pcmanfm}/share/applications/pcmanfm.desktop";
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "exa -al --color=always --group-directories-first --icons";
      cd = "z";
      rn = "ranger";
      nc = "ncmpcpp";
      cp = "cp -i";
      mv = "mv -i";
      moe = "mpv https://listen.moe/stream";
      up =
        "sudo nixos-rebuild switch --upgrade && notify-send  'Update completed!🐧🎉'";
      vim = "emacsclient -t -a emacs";
    };
    shellInit = ''
               set fish_greeting 
      	 fish_vi_key_bindings
               zoxide init fish | source
                 		   '';

  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$all$directory$character";
      add_newline = false;
      username = {
        show_always = false;
        style_user = "fg:#ef5fff bold";
        style_root = "fg:#9A348E";
        format = "[$user ]($style)";
      };
      character = {
        success_symbol = "[->](bold blue)";
        error_symbol = "[x](bold red)";
        vicmd_symbol = "[I](bold green)";
      };
      time = {

        disabled = true;
      };
      git_commit = {

        tag_symbol = " tag ";
      };
      git_status = {
        ahead = ">";
        behind = "<";
        diverged = "<>";
        renamed = "r";
        deleted = "x";

      };
      aws = { symbol = "aws "; };
      c = { symbol = "C "; };
      cobol = { symbol = "cobol "; };
      conda = { symbol = "conda "; };

      directory = { read_only = " ro"; };
      docker_context = {

        symbol = "docker ";
      };

      git_branch = {

        symbol = "git ";
      };

      java = {

        symbol = "java ";
      };

      lua = {

        symbol = "lua ";
      };

      memory_usage = { symbol = "memory "; };

      nix_shell = {

        symbol = "nix ";
      };
      package = {

        symbol = "pkg ";

      };

      python = { symbol = "py "; };

      rust = {

        symbol = "rs ";
      };
      ruby = {

        symbol = "rb ";
      };
      sudo = {
        symbol = "sudo ";

      };
      hostname = { ssh_only = true; };
    };

  };
}
