{ config, pkgs, ... }:

{

  home-manager.users.adisbladis = { ... }: {

    home.file = {
      ".config/fish/functions/fish_greeting.fish".source = pkgs.writeScript "fish_greeting.fish" ''
        function fish_greeting
        end
      '';
      ".config/fish/functions/fish_prompt.fish".source = pkgs.writeScript "fish_prompt.fish" ''
        function fish_prompt --description 'Display prompt'
            set last_ret $status

            set PROMPT ""

            if test "$USER" != "adisbladis"
                set PROMPT $PROMPT"👤$USER "
            end

            if test "$hostname" != "${config.networking.hostName}"
                set PROMPT $PROMPT💻(string split -m 1 "." $hostname)[1]' '
            end

            set PROMPT $PROMPT📁(prompt_pwd)" "

            set git_prompt (__fish_git_prompt '%s ')
            if test $status = 0
                set PROMPT $PROMPT🔀$git_prompt
            end

            if test -n "$IN_NIX_SHELL"
                set PROMPT $PROMPT"❄ "
            end

            if test $last_ret = 0
                set PROMPT $PROMPT'✓'
            else
                set PROMPT $PROMPT'❌'
            end
            set PROMPT $PROMPT(set_color normal)' '

            builtin echo -ns $PROMPT
        end
      '';
      ".config/fish/functions/fish_title.fish".source = pkgs.writeScript "fish_title.fish" ''
        function fish_title
            hostname
            echo ":"
            prompt_pwd
        end
      '';
    };

    programs.fish = {
      enable = true;
      shellAliases = with pkgs; {
        pcat = "${python3Packages.pygments}/bin/pygmentize";
      };
      shellInit = ''
        # Custom minimal theme
        set -U fish_color_normal normal
        set -U fish_color_command normal
        set -U fish_color_quote normal --underline
        set -U fish_color_redirection normal
        set -U fish_color_end 767676
        set -U fish_color_error b2b2b2
        set -U fish_color_param normal
        set -U fish_color_selection white --bold
        set -U fish_color_search_match bryellow --background=brwhite --underline
        set -U fish_color_history_current --bold --underline
        set -U fish_color_operator normal --bold --underline
        set -U fish_color_escape normal --underline
        set -U fish_color_cwd green
        set -U fish_color_cwd_root red
        set -U fish_color_valid_path --underline
        set -U fish_color_autosuggestion 777777
        set -U fish_color_user brgreen
        set -U fish_color_host normal
        set -U fish_color_cancel -r
        set -U fish_pager_color_completion normal
        set -U fish_pager_color_description B3A06D yellow
        set -U fish_pager_color_prefix white --bold --underline
        set -U fish_pager_color_progress brwhite --background=cyan
        set -U fish_color_match --background=brblue
        set -U fish_color_comment 4e4e4e

        set -gx LS_COLORS 'rs=0:di=01;1;01;4:ln=01;1;01;7:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;4'

        function vterm_printf;
            if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
                # tell tmux to pass the escape sequences through
                printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
            else if string match -q -- "screen*" "$TERM"
                # GNU screen (screen, screen-256color, screen-256color-bce)
                printf "\eP\e]%s\007\e\\" "$argv"
            else
                printf "\e]%s\e\\" "$argv"
            end
        end

        function vterm_prompt_end;
            vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
        end
        functions --copy fish_prompt vterm_old_fish_prompt
        function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
            # Remove the trailing newline from the original prompt. This is done
            # using the string builtin from fish, but to make sure any escape codes
            # are correctly interpreted, use %b for printf.
            printf "%b" (string join "\n" (vterm_old_fish_prompt))
            vterm_prompt_end
        end

      '';
    };


  };

}
