{ pkgs, ... }:
let
  # TODO
  # https://github.com/rapid7/metasploit-framework/issues/19889
  # /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/modules/payloads/singles/linux/riscv32le/exec.rb:24:in `initialize': uninitialized constant Msf::Modules::Payload__Singles__Linux__Riscv32le__Exec::MetasploitModule::ARCH_RISCV32LE (NameError)
  # Did you mean?  ARCH_PPCE500V2
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/payload_set.rb:329:in `new'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/payload_set.rb:329:in `add_module'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/loading.rb:108:in `on_module_load'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/base.rb:202:in `load_module'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/base.rb:258:in `block in load_modules'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/directory.rb:52:in `block (2 levels) in each_module_reference_name'
  #         from /nix/store/xq5v8a2p0m96p861m0gbjkc791fv191x-ruby3.3-rex-core-0.1.32/lib/ruby/gems/3.3.0/gems/rex-core-0.1.32/lib/rex/file.rb:133:in `block in find'
  #         from /nix/store/xq5v8a2p0m96p861m0gbjkc791fv191x-ruby3.3-rex-core-0.1.32/lib/ruby/gems/3.3.0/gems/rex-core-0.1.32/lib/rex/file.rb:132:in `catch'
  #         from /nix/store/xq5v8a2p0m96p861m0gbjkc791fv191x-ruby3.3-rex-core-0.1.32/lib/ruby/gems/3.3.0/gems/rex-core-0.1.32/lib/rex/file.rb:132:in `find'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/directory.rb:43:in `block in each_module_reference_name'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/directory.rb:33:in `foreach'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/directory.rb:33:in `each_module_reference_name'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/modules/loader/base.rb:257:in `load_modules'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/loading.rb:170:in `block in load_modules'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/loading.rb:168:in `each'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/loading.rb:168:in `load_modules'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/module_paths.rb:41:in `block in add_module_path'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/module_paths.rb:40:in `each'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/core/module_manager/module_paths.rb:40:in `add_module_path'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/base/simple/framework/module_paths.rb:56:in `block in init_module_paths'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/base/simple/framework/module_paths.rb:55:in `each'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/base/simple/framework/module_paths.rb:55:in `init_module_paths'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/msf/ui/console/driver.rb:173:in `initialize'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/metasploit/framework/command/console.rb:66:in `new'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/metasploit/framework/command/console.rb:66:in `driver'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/metasploit/framework/command/console.rb:54:in `start'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/lib/metasploit/framework/command/base.rb:82:in `start'
  #         from /nix/store/2hf18pac2gyxvz7d30qmwhfh0i8yhb55-metasploit-framework-6.4.35/share/msf/msfconsole:23:in `<main>'
  # metasploit = pkgs-unstable.metasploit.overrideAttrs {
  #   src = pkgs-unstable.fetchFromGitHub {
  #     owner = "rapid7";
  #     repo = "metasploit-framework";
  #     rev = "7603b5d2d4243417c97f0b735c0a47c4b74a7d04";
  #     hash = "sha256-NuJmKkjhrnPpxP5zNpB9Af6wC2xkpfxhCdM62nFHA7c=";
  #   };
  # };
in
{
  users.groups.msf = { };
  users.users.msf = {
    description = "user for Metasploit db";
    group = "msf";
    isSystemUser = true;
  };

  environment.systemPackages = [
    pkgs.metasploit
  ];

  # DB for Metasploit
  # Inside Metasplot, run
  # msfdb init --connection-string postgresql://msf@msf?host=/var/run/postgresql
  # db_connect msf@localhost/msf
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "msf" ];
    ensureUsers = [{
      name = "msf";
      ensureDBOwnership = true;
    }];
    authentication = ''
      local msf all peer map=msf
      host msf all 127.0.0.1/32 trust
    '';
    identMap = ''
      msf /.+ msf
    '';
  };
}
