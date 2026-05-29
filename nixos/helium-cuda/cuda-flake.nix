# SPDX-FileCopyrightText: 2025 NixOS Foundation and contributors
# SPDX-License-Identifier: MIT
# https://wiki.nixos.org/wiki/CUDA#Enabling_CUDA_In_Packages
# Copy with rsync
# nixos/helium-cuda/cuda-flake.nix helium-cuda.local:~/TurboQuant/flake.nix
{
  description = "CUDA development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
        config.cudaVersion = "12";
      };
      # Change according to the driver used: stable, beta
      nvidiaPackage = pkgs.linuxPackages.nvidiaPackages.stable;
    in
    {
      # alejandra is a nix formatter with a beautiful output
      formatter."${system}" = nixpkgs.legacyPackages.${system}.alejandra;
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cmake
          ffmpeg
          fmt.dev
          cudaPackages.cuda_cudart
          cudatoolkit
          nvidiaPackage
          cudaPackages.cudnn
          libGLU
          libGL
          libxi
          libxmu
          freeglut
          libxext
          libx11
          libxv
          libxrandr
          zlib
          ncurses
          ccache
          binutils
          uv
        ];

        LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath [ nvidiaPackage ];
        CUDA_PATH = pkgs.cudatoolkit;
        EXTRA_LDFLAGS = "-L/lib -L${nvidiaPackage}/lib";
        EXTRA_CCFLAGS = "-I/usr/include";
        CMAKE_PREFIX_PATH = "${pkgs.fmt.dev}";
        PKG_CONFIG_PATH = "${pkgs.fmt.dev}/lib/pkgconfig";
      };
    };
}
