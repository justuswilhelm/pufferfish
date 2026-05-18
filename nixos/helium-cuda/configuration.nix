# SPDX-FileCopyrightText: 2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  specialArgs,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ../modules/networkd.nix
    ../modules/openssh.nix
    ../modules/users.nix

    ./build.nix
  ];

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot.kernelParams = ["console=ttyS0"];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";

  programs.fish.shellInit = ''
    set -x MODEL_DIR $HOME/models
  '';

  users.users = {
    ${specialArgs.name} = {
      password = "password";
      # Rootless Docker, why not!
      extraGroups = [ "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYV4dnCrWcJambeu0a6OG1mQFdkKaGzmWVzbkqyV/h31rM9tBLbjUTOB/4h/LFiiKo7MLC7L8zUbhtcloGWnyUWXFZOiD1CL4RVB3UH3td6VYBvTvWbob+mYG2YCnaj2wRWYS//qA+GJXWqcmr6HiNGTpQGzbj+zRl1QKJsltF4+MUedjQadgRsF4HEr71QyQLM6/lZOlPb13HuQKtI7WOhL/YHpEz/E9dYHdAuwTzhCJ1+g34IMXD4+QizVEz3eNd2yW6t9IdQl+9QzhkJgvUP1o9NgKeJ4u9YRCvK4DbgyYE5e5/0qO8YCG5ODjc5Lj33/sN+F4tmOIj6x7PNMUAxy4NPyvXwO2weRLXWgns8+zCd3/xnL6fv0ORONOc48cf1M2wpxeZ0x8q+oNdPd7T5Esj8Peo+EXZ0TZp95NoOKwn6+mssPXjtB9aNh6VHfUDirkwJadBq30b5rn5JsLuYSiCVwk1iO5DioQJFdpJW1jaahBTo9uLv3ZyteFEDE8vNZVRWcNX61jp0aP9cXklrXGdfJRj4YEISWlPZqCfP1OBiT9HrxEqk+3pMO7elmRQaUWNPKNsLKQOUKIpRNH12DlA0676ToYVCAHIPCPvYC8DZ4XLmk33/jQ3mmj6tLTeRE+DySbfSNscoyqZ2VWbCt7GPA34Prbr1BjdWi2Cbw== cardno:20_137_860"
      ];
    };
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYV4dnCrWcJambeu0a6OG1mQFdkKaGzmWVzbkqyV/h31rM9tBLbjUTOB/4h/LFiiKo7MLC7L8zUbhtcloGWnyUWXFZOiD1CL4RVB3UH3td6VYBvTvWbob+mYG2YCnaj2wRWYS//qA+GJXWqcmr6HiNGTpQGzbj+zRl1QKJsltF4+MUedjQadgRsF4HEr71QyQLM6/lZOlPb13HuQKtI7WOhL/YHpEz/E9dYHdAuwTzhCJ1+g34IMXD4+QizVEz3eNd2yW6t9IdQl+9QzhkJgvUP1o9NgKeJ4u9YRCvK4DbgyYE5e5/0qO8YCG5ODjc5Lj33/sN+F4tmOIj6x7PNMUAxy4NPyvXwO2weRLXWgns8+zCd3/xnL6fv0ORONOc48cf1M2wpxeZ0x8q+oNdPd7T5Esj8Peo+EXZ0TZp95NoOKwn6+mssPXjtB9aNh6VHfUDirkwJadBq30b5rn5JsLuYSiCVwk1iO5DioQJFdpJW1jaahBTo9uLv3ZyteFEDE8vNZVRWcNX61jp0aP9cXklrXGdfJRj4YEISWlPZqCfP1OBiT9HrxEqk+3pMO7elmRQaUWNPKNsLKQOUKIpRNH12DlA0676ToYVCAHIPCPvYC8DZ4XLmk33/jQ3mmj6tLTeRE+DySbfSNscoyqZ2VWbCt7GPA34Prbr1BjdWi2Cbw== cardno:20_137_860"
      ];
    };
  };
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  programs.git.enable = true;
  environment.systemPackages = [
    # For growpart
    pkgs.cloud-utils

    # club-3090 needs huggingface and pyyaml
    (pkgs.python3.withPackages (p: [ p.pyyaml p.huggingface-hub ]))
  ];

  nixpkgs.config = {
    cudaSupport = true;
    allowUnfree = true;
    nvidia.acceptLicense = true;
    allowUnfreePackages = [
      "nvidia-x11"
    ];
  };

  hardware.graphics = {
    enable = true;
    # Fix the following Nix build error
    # > Option enableNvidia on x86_64 requires 32-bit support libraries
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia uses the nvidiaPackages.stable by default
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    # enabling powermanagement is relevant if your VM can suspend
    # See also https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/powermanagement.html
  };
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    # This gets a deprecated warning, but it still appears to do things
    # https://github.com/NixOS/nixpkgs/blob/d7a713c0b7e47c908258e71cba7a2d77cc8d71d5/nixos/modules/services/hardware/nvidia-container-toolkit/default.nix#L145
    enableNvidia = true;
  };

  services.qemuGuest.enable = true;

  systemd.services.club-3090-vllm = {
    description = "Launch vLLM";
    serviceConfig = {
      User = specialArgs.name;
      WorkingDirectory = "/home/${specialArgs.name}/club-3090";
    };
    environment.MODEL_DIR = "/home/${specialArgs.name}/models";
    path = [
      (pkgs.python3.withPackages (p: [ p.pyyaml p.huggingface-hub ]))
      # It's a bash script
      pkgs.bash
      config.virtualisation.docker.package
      # Fix this:
      #  [preflight] ERROR: 'nvidia-smi' not found — no NVIDIA driver detected.
      config.hardware.nvidia.package
      # Fix this:
      # [preflight] WARN:  Your club-3090 checkout is 97 commit(s) behind origin/master.
      # [preflight]          (last origin fetch: just now)
      pkgs.git
      # Fix this:
      # /home/debian/club-3090/scripts/preflight.sh: line 47: awk: command not found
      pkgs.gawk
      # Fix this:
      # [switch] waiting for http://localhost:8020/v1/models (container=vllm-qwen36-27b, timeout 600s)...
      # /home/debian/club-3090/scripts/switch.sh: line 317: curl: command not found
      pkgs.curl
    ];
    script = ''
      ./scripts/launch.sh --variant vllm/default
    '';
    wantedBy = [ "multi-user.target" ];
  };

  system.stateVersion = "25.11";
}
