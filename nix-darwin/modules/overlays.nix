{ ... }:
{
  nixpkgs.overlays = [
    (import ../../overlays.nix).vale
    # Make J build again on darwin
    (final: previous: {
      j = previous.j.overrideAttrs (final: previous: { meta.broken = false; });
    })
  ];
}
