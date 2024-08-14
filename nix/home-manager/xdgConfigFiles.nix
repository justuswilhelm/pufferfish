{ isLinux, ... }:
{
  gdb = {
    enable = isLinux;
    source = ../../gdb/gdbinit;
    target = "gdb/gdbinit";
  };
}
