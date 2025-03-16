{ config, pkgs, ... }:
let
  logPath = "/var/log/atticd";
  attic-client = pkgs.attic-client;
  attic-server = pkgs.attic-server;
  publicHost = "lithium.local";
  publicPort = 10100;
  cache-base-url = "https://${publicHost}:${toString 10100}";
  cache-url = "${cache-base-url}/lithium-default";
  statePath = "/var/lib/attic";
  host = "localhost";
  port = 18080;
  caddyConfig = ''
    # Attic
    ${cache-base-url} {
      import certs

      reverse_proxy ${host}:${toString port}

      log {
        format console
        output file ${config.services.caddy.logPath}/attic.log
      }
    }
  '';
  tomlFormat = pkgs.formats.toml { };
  atticConfig = {
    # Socket address to listen on
    listen = "127.0.0.1:${toString port}";

    # Allowed `Host` headers
    #
    # This _must_ be configured for production use. If unconfigured or the
    # list is empty, all `Host` headers are allowed.
    allowed-hosts = [
      "${host}:${toString port}"
      "${publicHost}:${toString publicPort}"
    ];

    # The canonical API endpoint of this server
    #
    # This is the endpoint exposed to clients in `cache-config` responses.
    #
    # This _must_ be configured for production use. If not configured, the
    # API endpoint is synthesized from the client's `Host` header which may
    # be insecure.
    #
    # The API endpoint _must_ end with a slash (e.g., `https://domain.tld/attic/`
    # not `https://domain.tld/attic`).
    api-endpoint = "https://${publicHost}:${toString publicPort}/";

    # Whether to soft-delete caches
    #
    # If this is enabled, caches are soft-deleted instead of actually
    # removed from the database. Note that soft-deleted caches cannot
    # have their names reused as long as the original database records
    # are there.
    #soft-delete-caches = false;

    # Whether to require fully uploading a NAR if it exists in the global cache.
    #
    # If set to false, simply knowing the NAR hash is enough for
    # an uploader to gain access to an existing NAR in the global
    # cache.
    #require-proof-of-possession = true;

    # JWT signing token
    #
    # Set this to the Base64 encoding of some random data.
    # You can also set it via the `ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64` environment
    # variable.

    # Database connection
    database = {
      # Connection URL
      #
      # For production use it's recommended to use PostgreSQL.
      url = "sqlite://${statePath}/db.sqlite?mode=rwc";
      # Whether to enable sending on periodic heartbeat queries
      #
      # If enabled, a heartbeat query will be sent every minute
      #heartbeat = false

      # File storage configuration
    };
    storage = {
      # Storage type
      #
      # Can be "local" or "s3".
      type = "local";

      # ## Local storage
      #
      # The directory to store all files under
      path = "${statePath}/storage";

      # ## S3 Storage (set type to "s3" and uncomment below)
      # The AWS region
      #region = "us-east-1";
      #
      # The name of the bucket
      #bucket = "some-bucket";
      #
      # Custom S3 endpoint
      #
      # Set this if you are using an S3-compatible object storage (e.g., Minio).
      #endpoint = "https://xxx.r2.cloudflarestorage.com";
    };

    # Credentials
    #
    # If unset, the credentials are read from the `AWS_ACCESS_KEY_ID` and
    # `AWS_SECRET_ACCESS_KEY` environment variables.
    # storage.credentials = {
    #   access_key_id = "";
    #   secret_access_key = "";
    # }

    # Data chunking
    #
    # Warning: If you change any of the values here, it will be
    # difficult to reuse existing chunks for newly-uploaded NARs
    # since the cutpoints will be different. As a result, the
    # deduplication ratio will suffer for a while after the change.
    chunking = {
      # The minimum NAR size to trigger chunking
      #
      # If 0, chunking is disabled entirely for newly-uploaded NARs.
      # If 1, all NARs are chunked.
      nar-size-threshold = 65536; # chunk files that are 64 KiB or larger

      # The preferred minimum size of a chunk, in bytes
      min-size = 16384; # 16 KiB

      # The preferred average size of a chunk, in bytes
      avg-size = 65536; # 64 KiB

      # The preferred maximum size of a chunk, in bytes
      max-size = 262144; # 256 KiB
    };
    # Compression
    compression = {
      # Compression type
      #
      # Can be "none", "brotli", "zstd", or "xz"
      type = "zstd";

      # Compression level
      #level = 8;
    };
    # Garbage collection
    garbage-collection = {
      # The frequency to run garbage collection at
      #
      # By default it's 12 hours. You can use natural language
      # to specify the interval, like "1 day".
      #
      # If zero, automatic garbage collection is disabled, but
      # it can still be run manually with `atticd --mode garbage-collector-once`.
      interval = "12 hours";

      # Default retention period
      #
      # Zero (default) means time-based garbage-collection is
      # disabled by default. You can enable it on a per-cache basis.
      #default-retention-period = "6 months"
    };
  };
in
{
  users.groups.attic = { gid = 603; };
  users.users.attic = {
    home = statePath;
    description = "attic user";
    gid = 603;
    uid = 53;
    isHidden = true;
  };
  users.knownGroups = [ "attic" ];
  users.knownUsers = [ "attic" ];

  environment.systemPackages = [ attic-client attic-server ];
  environment.etc."attic/atticd.toml".source = tomlFormat.generate "atticd.toml" atticConfig;

  environment.etc."newsyslog.d/attic.conf".text = ''
    # logfilename               [owner:group] mode count size when  flags [/pid_file] [sig_num]
    ${logPath}/attic.stdout.log attic:attic   640  10    *    $D0   J
    ${logPath}/attic.stderr.log attic:attic   640  10    *    $D0   J
  '';

  services.caddy.extraConfig = caddyConfig;

  launchd.daemons.attic = {
    script = ''
      mkdir -p ${statePath}/secrets
      if [ ! -e ${statePath}/secrets/secret.base64 ]; then
        echo "This is where a new secret gets generated"
        # head -c32 /dev/urandom | base64 | sudo tee /var/lib/attic/secrets/secret.base64
      fi

      ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="$(cat ${statePath}/secrets/secret.base64)"
      export ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64
      exec ${attic-server}/bin/atticd --config /etc/attic/atticd.toml
    '';
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/attic.stdout.log";
      StandardErrorPath = "${logPath}/attic.stderr.log";
      UserName = "attic";
    };
  };

  # Derived from running attic use lithium-default
  nix.settings.substituters = [ cache-url ];
  nix.settings.trusted-public-keys = [
    "lithium-default:12m8tx3dPRBH0y4Gf6t/4eGh7Y8AJ7r2TT0Ug/w9Wvo="
  ];
  nix.settings.trusted-substituters = [ cache-url ];
  nix.settings.netrc-file = "/etc/nix/netrc";

  # TODO create startup script that
  # 1. creates run time folders, and assigns them to attic/attic, and chmods
  #    g,o=
  # 2. creates secret - if it doesn't exist

  system.activationScripts.preActivation = {
    text = ''
      mkdir -p ${logPath} ${statePath}
      chown -R attic:attic ${logPath} ${statePath}
      chmod -R go= ${statePath}
    '';
  };
}
