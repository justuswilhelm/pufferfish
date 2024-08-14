{ lib, pkgs, config, options, specialArgs, ... }:
let
  isLinux = specialArgs.system == "debian" || specialArgs.system == "nixos";
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./tmux.nix
    ./cmus.nix
    ./nvim.nix
    ./neomutt.nix
    ./packages.nix
    ./selenized.nix
  ];

  home.username = "justusperlwitz";
  home.homeDirectory = specialArgs.homeDirectory;

  home.stateVersion = "24.05";

  home.sessionPath = [
    "${config.home.sessionVariables.DOTFILES}/bin"
  ];

  home.sessionVariables = {
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    XDG_CONFIG_HOME = config.xdg.configHome;
    XDG_DATA_HOME = config.xdg.dataHome;
    XDG_STATE_HOME = config.xdg.stateHome;
    XDG_CACHE_HOME = config.xdg.cacheHome;
    NNN_OPENER = "open";
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
    # XXX Still needed?
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  xdg.dataFile = {
    iosevka = {
      source = ../../fonts/iosevka-fixed-regular.ttf;
      target = "fonts/iosevka-fixed-regular.ttf";
    };
  };

  home.file = {
    pdbrc =
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
        text = ''
          import os
          with open(os.path.expanduser("${pdbrcpy}")) as _f: _f = _f.read()
          exec(_f)
          del _f
        '';
        target = ".pdbrc";
      };
  };

  programs.home-manager.enable = true;

  programs.poetry = {
    enable = true;
    settings = {
      cache-dir = "${config.xdg.cacheHome}/pypoetry";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks."*" = { };
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
    settings = {
      # https://github.com/drduh/config/blob/master/gpg.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Options.html
      # 'gpg --version' to get capabilities
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # No comments in messages
      no-comments = true;
      # No version in output
      no-emit-version = true;
      # Disable banner
      no-greeting = true;
      # Long key id format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Display key origins and updates
      #with-key-origin
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Output ASCII instead of binary
      armor = true;
      # Enable smartcard
      use-agent = true;
      # Disable recipient key ID in messages (breaks Mailvelope)
      throw-keyids = true;
      # Default key ID to use (helpful with throw-keyids)
      #default-key 0xFF00000000000001
      #trusted-key 0xFF00000000000001
      # Group recipient keys (preferred ID last)
      #group keygroup = 0xFF00000000000003 0xFF00000000000002 0xFF00000000000001
      # Keyserver URL
      #keyserver hkps://keys.openpgp.org
      #keyserver hkps://keys.mailvelope.com
      #keyserver hkps://keyserver.ubuntu.com:443
      #keyserver hkps://pgpkeys.eu
      #keyserver hkps://pgp.circl.lu
      #keyserver hkp://zkaan2xfbuxia2wpf7ofnkbz6r5zdbbvxbunvp5g2iebopbfc4iqmbad.onion
      # Keyserver proxy
      #keyserver-options http-proxy=http://127.0.0.1:8118
      #keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050
      # Enable key retrieval using WKD and DANE
      #auto-key-locate wkd,dane,local
      #auto-key-retrieve
      # Trust delegation mechanism
      #trust-model tofu+pgp
      # Show expired subkeys
      #list-options show-unusable-subkeys
      # Verbose output
      #verbose
    };
  };
  services.ssh-agent.enable = isLinux;
  services.gpg-agent = {
    enable = isLinux;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
