# SPDX-FileCopyrightText: 2025 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, config, ... }:

# SPDX-SnippetBegin
# SPDX-License-Identifier: MIT
# SPDX-SnippetCopyrightText: 2021 Jan Warchoł
# Selenized light sRGB values from
# From https://github.com/jan-warchol/selenized/blob/7188d68b6bb5a8be8f83d216c3f42727f0fdacf2/the-values.md
let
  # background 	bg_0
  bg_0 = "#fbf3db";
  bg_1 = "#ece3cc";
  # selection 	bg_2
  bg_2 = "#d5cdb6";
  dim_0 = "#909995";
  # foreground 	fg_0
  fg_0 = "#53676d";
  # bold foreground 	fg_1
  # cursor color 	fg_1
  fg_1 = "#3a4d53";

  red = "#d2212d";
  green = "#489100";
  yellow = "#ad8900";
  blue = "#0072d4";
  magenta = "#ca4898";
  cyan = "#009c8f";
  orange = "#c25d1e";
  violet = "#8762c6";

  br_red = "#cc1729";
  br_green = "#428b00";
  br_yellow = "#a78300";
  br_blue = "#006dce";
  br_magenta = "#c44392";
  br_cyan = "#00978a";
  br_orange = "#bc5819";
  br_violet = "#825dc0";
  # SPDX-SnippetEnd
  # https://github.com/jan-warchol/selenized/blob/master/manual-installation.md
  # Element 	Color
  # background 	bg_0
  # foreground 	fg_0
  # bold foreground 	fg_1
  # dim foreground 	dim_0
  # cursor color 	fg_1
  # selection 	bg_2
  # selection text 	(none)
  bold = "bold";
  # Colors
  neomutt =
    let
      pairs = {
        normal = [ fg_0 bg_0 ];
        bold = [ bold fg_1 bg_0 ];
        error = [ br_red bg_0 ];
        warning = [ red bg_0 ];
        indicator = [ bg_0 yellow ];
        status = [ bg_0 fg_0 ];
      };
      concatColors = colors: lib.strings.concatStringsSep " " colors;
      toColorLine = name: colors: "color ${name} ${concatColors colors}";
      colors = lib.attrsets.mapAttrsToList toColorLine pairs;
    in
    lib.strings.concatStringsSep "\n" colors;

  tmux =
    let
      # most likely, we only need set-option and just need to pass the right flags
      # (see man page for tmux at set-option)
      so = "set-option";
      swo = "set-window-option";
      toStyleLine = arguments:
        let
          inherit (builtins) elemAt;
          type = elemAt arguments 0;
          name = elemAt arguments 1;
          fg = elemAt arguments 2;
          bg = elemAt arguments 3;
          comment = elemAt arguments 4;
        in
        ''
          # ${comment}
          ${type} -g ${name} 'fg=${fg}'' + (if bg != null then ",bg=${bg}'" else "'");
      toColorLine = arguments:
        let
          inherit (builtins) elemAt;
          type = elemAt arguments 0;
          name = elemAt arguments 1;
          color = elemAt arguments 2;
          comment = elemAt arguments 3;
        in
        ''
          # ${comment}
          ${type} -g ${name} '${color}'
        '';
      stylePairs = [
        [ so "message-style" fg_0 bg_0 "Message text" ]
        [ so "mode-style" fg_1 bg_2 "Selection" ]
        [ so "pane-active-border-style" fg_0 null "Pane border" ]
        [ so "pane-border-style" bg_2 null "Pane border" ]
        [ so "status-style" magenta bg_1 "Default statusbar colors" ]
        [ swo "window-status-bell-style" fg_0 bg_0 "Bell" ]
        [ swo "window-status-current-style" bg_0 fg_0 "Active window title colors" ]
        [ swo "window-status-style" fg_0 bg_0 "Default window title colors" ]
      ];
      colourPairs = [
        [ so "display-panes-active-colour" fg_0 "Pane number display" ]
        [ so "display-panes-colour" fg_0 "Pane number display" ]
      ];
      colors = (map toStyleLine stylePairs) ++ (map toColorLine colourPairs);
    in
    lib.strings.concatStringsSep "\n" colors;

  radare2 =
    let
      pairs = {
        comment = [ dim_0 ];
        usrcmt = [ dim_0 ];
        args = [ fg_1 ];
        fname = [ fg_1 ];
        floc = [ fg_0 ];
        fline = [ fg_0 ];
        flag = [ fg_1 ];
        label = [ fg_1 ];
        help = [ fg_0 ];
        flow = [ fg_0 ];
        flow2 = [ fg_0 ];
        prompt = [ fg_0 ];
        bgprompt = [ fg_0 ];
        offset = [ fg_0 ];
        input = [ fg_0 ];
        invalid = [ red ];
        other = [ fg_0 ];
        b0x00 = [ bg_2 ];
        b0x7f = [ bg_2 ];
        b0xff = [ bg_2 ];
        math = [ blue ];
        bin = [ fg_0 ];
        btext = [ fg_0 ];
        push = [ green ];
        pop = [ red ];
        crypto = [ fg_0 ];
        jmp = [ blue ];
        cjmp = [ blue ];
        call = [ cyan ];
        nop = [ dim_0 ];
        ret = [ green ];
        trap = [ red ];
        ucall = [ fg_0 ];
        ujmp = [ blue ];
        swi = [ fg_0 ];
        cmp = [ magenta ];
        reg = [ orange ];
        creg = [ fg_0 ];
        num = [ fg_0 ];
        mov = [ violet ];
        var = [ blue ];
        "var.name" = [ fg_0 ];
        "var.type" = [ fg_0 ];
        "var.addr" = [ fg_0 ];
        "widget.bg" = [ bg_1 ];
        "widget.sel" = [ bg_1 ];
        "ai.read" = [ fg_0 ];
        "ai.write" = [ fg_0 ];
        "ai.exec" = [ fg_0 ];
        "ai.seq" = [ fg_0 ];
        "ai.ascii" = [ fg_0 ];
        "graph.box" = [ fg_0 ];
        "graph.box2" = [ fg_0 ];
        "graph.box3" = [ fg_0 ];
        "graph.box4" = [ fg_0 ];
        "graph.true" = [ fg_0 ];
        "graph.false" = [ fg_0 ];
        "graph.trufae" = [ fg_0 ];
        "graph.current" = [ fg_0 ];
        "graph.traced" = [ fg_0 ];
        "diff.unknown" = [ fg_0 ];
        "diff.new" = [ fg_0 ];
        "diff.match" = [ fg_0 ];
        "diff.unmatch" = [ fg_0 ];
        "gui.cflow" = [ fg_0 ];
        "gui.dataoffset" = [ fg_0 ];
        "gui.background" = [ fg_0 ];
        "gui.background2" = [ fg_0 ];
        "gui.border" = [ fg_0 ];
        wordhl = [ yellow bg_0 ];
        linehl = [ violet bg_0 ];
      };
      makeRadare2Color = builtins.replaceStrings [ "#" ] [ "rgb:" ];
      concatColors = colors:
        lib.strings.concatStringsSep " " (map makeRadare2Color colors);
      # Usage ec[s?] [key][[=| ]fg] [bg]
      toColorLine = name: colors: ''
        ec ${name} ${concatColors colors}
      '';
      colors = lib.attrsets.mapAttrsToList toColorLine pairs;
    in
    lib.strings.concatStringsSep "\n" colors;
  # We are hoping on the terminal we are in to already have selenized colors
  timewarrior = ''
    theme.colors.debug = cyan
    theme.colors.exclusion = yellow on white
    theme.colors.holiday = red
    theme.colors.ids = blue
    theme.colors.label = green
    theme.colors.today = magenta
    theme.palette.color01 = black on red
    theme.palette.color02 = black on green
    theme.palette.color03 = white on yellow
    theme.palette.color04 = black on blue
    theme.palette.color05 = black on magenta
    theme.palette.color06 = black on cyan
    theme.palette.color07 = black on white
    theme.palette.color08 = black on red
    theme.palette.color09 = black on green
    theme.palette.color10 = white on yellow
    theme.palette.color11 = black on blue
    theme.palette.color12 = black on magenta
  '';
  alacritty =
    let
      color = builtins.replaceStrings [ "#" ] [ "0x" ];
    in
    {
      primary = {
        background = color bg_0;
        foreground = color fg_0;
      };
      normal = {
        black = color bg_1;
        red = color red;
        green = color green;
        yellow = color yellow;
        blue = color blue;
        magenta = color magenta;
        cyan = color cyan;
        white = color dim_0;
      };
      bright = {
        black = color bg_2;
        red = color br_red;
        green = color br_green;
        yellow = color br_yellow;
        blue = color br_blue;
        magenta = color br_magenta;
        cyan = color br_cyan;
        white = color fg_1;
      };
    };
  # fish_config theme dump
  fish =
    let
      concatValues = lib.strings.concatStringsSep " ";
      toColorLine = name: values: "${name} ${concatValues values}";
      color = builtins.replaceStrings [ "#" ] [ "" ];
      colors = {
        "fish_color_autosuggestion" = [ "93a1a1" ];
        "fish_color_cancel" = [ "-r" ];
        "fish_color_command" = [ "586e75" ];
        "fish_color_comment" = [ "93a1a1" ];
        "fish_color_cwd" = [ "green" ];
        "fish_color_cwd_root" = [ "red" ];
        "fish_color_end" = [ "268bd2" ];
        "fish_color_error" = [ "dc322f" ];
        "fish_color_escape" = [ "00a6b2" ];
        "fish_color_history_current" = [ "--bold" ];
        "fish_color_host" = [ "normal" ];
        "fish_color_host_remote" = [ "yellow" ];
        "fish_color_keyword" = [ "586e75" ];
        "fish_color_match" = [ "--background=brblue" ];
        "fish_color_normal" = [ (color fg_0) ];
        "fish_color_operator" = [ "00a6b2" ];
        "fish_color_option" = [ "657b83" ];
        "fish_color_param" = [ "657b83" ];
        "fish_color_quote" = [ "839496" ];
        "fish_color_redirection" = [ "6c71c4" ];
        "fish_color_search_match" = [ "'bryellow'" "'--background=white'" ];
        "fish_color_selection" = [ "'white'" "'--bold'" "'--background=${color bg_2}'" ];
        "fish_color_status" = [ "red" ];
        "fish_color_user" = [ "brgreen" ];
        "fish_color_valid_path" = [ "--underline" ];
        "fish_pager_color_background" = [ ];
        "fish_pager_color_completion" = [ "green" ];
        "fish_pager_color_description" = [ "B3A06D" ];
        "fish_pager_color_prefix" = [ "'cyan'" "'--underline'" ];
        "fish_pager_color_progress" = [ "'brwhite'" "'--background=cyan'" ];
        "fish_pager_color_secondary_background" = [ ];
        "fish_pager_color_secondary_completion" = [ ];
        "fish_pager_color_secondary_description" = [ ];
        "fish_pager_color_secondary_prefix" = [ ];
        "fish_pager_color_selected_background" = [ "--background=white" ];
        "fish_pager_color_selected_completion" = [ ];
        "fish_pager_color_selected_description" = [ ];
        "fish_pager_color_selected_prefix" = [ ];
      };
      toTheme = lib.attrsets.mapAttrsToList toColorLine;
      theme = toTheme colors;
    in
    ''
      # name: 'Selenized'
      ${lib.strings.concatStringsSep "\n" theme}
    '';
in
# Test with
  # nix eval --file $DOTFILES/home-manager/modules/selenized.nix --arg lib "(import <nixpks>{}).lib" --arg config "{}"
{
  # https://neomutt.org/guide/configuration
  xdg.configFile."neomutt/colors" = lib.mkIf config.programs.neomutt.enable {
    text = neomutt;
  };

  xdg.configFile."radare2/radare2rc" = lib.mkIf config.programs.radare2.enable {
    text = ''
      e cfg.fortunes = true
      e scr.color = 3
      # selenized colors
      ${radare2}
    '';
  };

  xdg.configFile."timewarrior/selenized.theme".text = timewarrior;

  programs.alacritty.settings.colors = lib.mkIf config.programs.alacritty.enable alacritty;

  programs.tmux.extraConfig = lib.mkIf config.programs.tmux.enable tmux;

  xdg.configFile."fish/themes/Selenized.theme".text =
    lib.mkIf config.programs.fish.enable fish;
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable ''
    fish_config theme choose Selenized
  '';
}
