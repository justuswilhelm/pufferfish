{ ... }:
{
  # This includes man pages for the C library
  environment.etc."manpaths.d/xcode".text = ''
    /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man/
  '';
}
