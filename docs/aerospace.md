# AeroSpace

Here's a WIP patch for building and linking AeroSpace from nix directly.

It currently fails because of Apple's quarantine.

```patch
diff --git a/aerospace/aerospace.toml b/aerospace/aerospace.toml
index 0c56323..3570928 100644
--- a/aerospace/aerospace.toml
+++ b/aerospace/aerospace.toml
@@ -1,8 +1,5 @@
 # Reference: https://github.com/i3/i3/blob/next/etc/config

-# Start AeroSpace at login
-start-at-login = true
-
 [mode.main.binding]
 # change focus
 cmd-alt-h = 'focus left'
diff --git a/nix/darwin/darwin-configuration.nix b/nix/darwin/darwin-configuration.nix
index 800614b..a046b37 100644
--- a/nix/darwin/darwin-configuration.nix
+++ b/nix/darwin/darwin-configuration.nix
@@ -3,6 +3,7 @@ let
   uid = 501;
   home = "/Users/${name}";
   library = "${home}/Library";
+  nixApplications = "${home}/Applications/Home Manager Apps";
 in
 { user, config, pkgs, ... }:

@@ -71,6 +72,25 @@ in
   launchd.labelPrefix = "net.jwpconsulting";

   launchd.user.agents = {
+    # Translated from .plist excerpt:
+    #     <key>Label</key>
+    #     <string>bobko.aerospace</string>
+    #     <key>ProgramArguments</key>
+    #     <array>
+    #         <string>/Applications/Free/AeroSpace.app/Contents/MacOS/AeroSpace</string>
+    #         <string>--started-at-login</string>
+    #     </array>
+    #     <key>RunAtLoad</key>
+    #     <true/>
+    "aerospace" = {
+      serviceConfig = {
+        ProgramArguments = [
+          "${nixApplications}/AeroSpace.app/Contents/MacOS/AeroSpace"
+          "--started-at-login"
+        ];
+        RunAtLoad = true;
+      };
+    };
     "borgmatic" = {
       serviceConfig =
         let
diff --git a/nix/home-manager/packages.nix b/nix/home-manager/packages.nix
index 44c75f0..edf35ee 100644
--- a/nix/home-manager/packages.nix
+++ b/nix/home-manager/packages.nix
@@ -1,14 +1,19 @@
 { lib, isDebian, isDarwin, pkgs, extraPkgs }:
 let
+  # TODO build aerospace here
+  # See how alacritty is built:
+  # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/applications/terminal-emulators/alacritty/default.nix#L132
   aeroSpace = pkgs.stdenv.mkDerivation {
     pname = "aerospace";
     version = "0.8.6-Beta";
     nativeBuildInputs = [ pkgs.installShellFiles ];
     buildPhase = "";
     installPhase = ''
-      mkdir -p $out/bin
+      mkdir -p $out/bin $out/Applications
       cp bin/aerospace $out/bin
       installManPage manpage/*
+      cp -r AeroSpace.app $out/Applications
+      xattr -d com.apple.quarantine $out/Applications/AeroSpace.app
     '';

     src = pkgs.fetchzip {
```
