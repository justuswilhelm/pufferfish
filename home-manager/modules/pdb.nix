{ pkgs, ... }:
let
  pdbrcpy = pkgs.writeTextFile {
    name = "pdbrc.py";
    # Might want to create the following folder:
    # $HOME/.local/state/pdb/pdb_history
    text = ''
      import pdb
      def _pdbrc_init() -> None:
          import readline as r
          import pathlib
          from atexit import register
          history_d = pathlib.Path.home() / ".local/state/pdb"
          history_f = history_d / "pdb_history"
          if not history_d.exists():
            history_d.mkdir(parents=True, exist_ok=True)
          register(r.write_history_file, history_f)
          try:
              r.read_history_file(history_f)
          except IOError:
              pass
          r.set_history_length(1000)
      _pdbrc_init()
      del _pdbrc_init
    '';
  };
in
{
  home.file.".pdbrc".text = ''
    import os
    with open(os.path.expanduser("${pdbrcpy}")) as _f: _f = _f.read()
    exec(_f)
    del _f
  '';
}
