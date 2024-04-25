# Selenized light sRGB values from
# From https://github.com/jan-warchol/selenized/blob/7188d68b6bb5a8be8f83d216c3f42727f0fdacf2/the-values.md
# Selenized
# Copyright (c) 2021 Jan Warchoł
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
let
  bg_0 = "#fbf3db";
  bg_1 = "#ece3cc";
  bg_2 = "#d5cdb6";
  dim_0 = "#909995";
  fg_0 = "#53676d";
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
in
# Test with
  # nix eval --file $DOTFILES/nix/home-manager/selenized.nix neomutt --arg lib "(import <nixpks>{}).lib"
{ lib }: {
  # https://neomutt.org/guide/configuration
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
}
