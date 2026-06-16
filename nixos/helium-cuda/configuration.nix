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
let
  llmServerPort = 8020;
  webUiPort = 8080;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ../modules/network-debug.nix
    ../modules/networkd.nix
    ../modules/nix.nix
    ../modules/openssh.nix
    ../modules/users.nix
  ];
  # Build qemu qcow image
  system.build.qcow = lib.mkForce (
    import "${toString modulesPath}/../lib/make-disk-image.nix" {
      inherit lib config pkgs;
      diskSize = "auto";
      additionalSpace = "20G";
      format = "qcow2";
      baseName = "helium-cuda";
      installBootLoader = true;
      partitionTableType = "hybrid";
    }
  );

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";

  # Directories for downloading models with huggingface
  programs.fish.shellInit = ''
    set -x MODEL_DIR $HOME/models
    set -x HF_HOME $HOME/models
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

  programs.git.enable = true;
  programs.neovim.enable = true;
  environment.systemPackages = [
    # troubleshoot space issues
    pkgs.ncdu
    # For growpart
    pkgs.cloud-utils

    # For dowloading models
    (pkgs.python3.withPackages (p: [
      p.pyyaml
      p.huggingface-hub
    ]))
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
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
    daemon.settings = {
      log-driver = "journald";
    };
  };

  services.qemuGuest.enable = true;

  networking.firewall.allowedTCPPorts = [
    llmServerPort
  ];

  # See this page for how to run Docker compose as a systemd service
  # https://gist.github.com/mosquito/b23e1c1e5723a7fd9e6568e5cf91180f
  systemd.services.llm-server =
    let
      model = "Qwen3.6-35B-A3B";
      basePath = "/home/${specialArgs.name}/models/unsloth/${model}-GGUF";
      modelPath = "${basePath}/${model}-UD-Q3_K_M.gguf";
      mmprojPath = "${basePath}/mmproj-F16.gguf";
    in
    {
      description = "LLM Server";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        User = specialArgs.name;
        WorkingDirectory = "/home/${specialArgs.name}/TurboQuant";
        # See this page for command line flags:
        # https://huggingface.co/Qwen/Qwen3.6-35B-A3B/discussions/37
        # Also see
        # https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
        # --jinja enabled by default
        # commented out --no-mmproj-offload \
        ExecStart = ''
          ${config.nix.package}/bin/nix develop --command build/bin/llama-server \
            --model ${modelPath} \
            --mmproj ${mmprojPath} \
            --alias "unsloth/${model}" \
            --host 0.0.0.0 --port ${builtins.toString llmServerPort} \
            --flash-attn on \
            --no-mmap \
            --parallel 1 \
            --ctx-size 262144 \
            --n-predict 32768 \
            --temp 0.6 \
            --top-p 0.95 \
            --top-k 20 \
            --presence-penalty 0.0 \
            --min-p 0.00 \
            --cache-type-k bf16 \
            --cache-type-v bf16 \
            --ubatch-size 288
        '';
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };

  system.stateVersion = "25.11";
}
