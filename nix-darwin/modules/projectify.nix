# TODO make this a nix module
{ pkgs, ... }:
let
  frontend = pkgs.projectify-frontend-node;
  backend = pkgs.projectify-backend;
  logPath = "/var/log/projectify";
  frontendPort = "18101";
  backendPort = "18102";
  redisPort = "18103";
  hostname = "lithium.local";
  revproxyPort = "10105";
in
{
  users.groups.projectify = {
    gid = 600;
  };
  users.users.projectify = {
    home = "/var/projectify/home";
    description = "Projectify";
    gid = 600;
    uid = 50;
    isHidden = true;
  };
  users.knownGroups = [
    "projectify"
  ];
  users.knownUsers = [
    "projectify"
  ];
  environment.systemPackages = [ pkgs.redis ];

  # From nix darwin redis services module
  environment.etc."projectify/redis.conf".text = ''
    port ${redisPort}
    bind 127.0.0.1
    dir /var/projectify/redis/
    logfile /var/log/projectify/projectify-redis.log
  '';

  launchd.daemons.projectify-redis = {
    command = "${pkgs.redis}/bin/redis-server /etc/projectify/redis.conf";
    serviceConfig = {
      # TODO check if logging can't be merged
      StandardOutPath = "${logPath}/projectify-redis.stdout.log";
      StandardErrorPath = "${logPath}/projectify-redis.stderr.log";
      KeepAlive = true;
      UserName = "projectify";
    };
  };
  launchd.daemons.projectify-frontend-node = {
    command = "${frontend}/bin/projectify-frontend-node";
    serviceConfig =
      {
        KeepAlive = true;
        # TODO check if logging can't be merged
        StandardOutPath = "${logPath}/projectify-frontend-node.stdout.log";
        StandardErrorPath = "${logPath}/projectify-frontend-node.stderr.log";
        EnvironmentVariables = {
          SVELTE_KIT_PORT = frontendPort;
        };
        UserName = "projectify";
      };
  };
  launchd.daemons.projectify-backend = {
    script = ''
      export STRIPE_ENDPOINT_SECRET=""
      export STRIPE_PRICE_OBJECT=""
      export STRIPE_SECRET_KEY=""
      export STRIPE_PUBLISHABLE_KEY=""
      export MAILGUN_DOMAIN=""
      export MAILGUN_API_KEY=""
      SECRET_KEY="$(cat /etc/projectify/secret_key)"
      export SECRET_KEY
      exec ${backend}/bin/projectify-backend
    '';
    serviceConfig =
      {
        KeepAlive = true;
        # TODO check if logging can't be merged
        StandardOutPath = "${logPath}/projectify-backend.stdout.log";
        StandardErrorPath = "${logPath}/projectify-backend.stderr.log";
        EnvironmentVariables = {
          FRONTEND_URL = "https://${hostname}:${revproxyPort}";
          ALLOWED_HOSTS = hostname;
          REDIS_URL = "redis://${hostname}:${redisPort}";
          DJANGO_SETTINGS_MODULE = "projectify.settings.production";
          DJANGO_CONFIGURATION = "Production";
          DATABASE_URL = "sqlite:////var/projectify/projectify-backend.sqlite";
          PORT = backendPort;
        };
        UserName = "projectify";
      };
  };

  services.caddy.extraConfig = ''
    # SPDX-License-Identifier: AGPL-3.0-or-later
    # SPDX-FileCopyrightText: 2024 JWP Consulting GK
    # Helpful links for Caddy security headers
    # https://github.com/jpcaparas/caddy-csp/blob/f241472610a5a4e4f8d74e0976120bbb2cca84cc/Caddyfile
    # https://paulbradley.dev/caddyfile-web-security-headers/
    (frontend_headers) {
      # We need to relax the CSP a bit, since Svelte has some inline js.
      # Compared to backend_headers, we removed default-src and script-src
      # Furthermore, we have to make sure we don't override any CSP headers
      # Should SvelteKit with adapter-node decide to return a header itself
      # We have to relax style-src here as well, in case of a page transition
      # from landing (prerendered) to dashboard (ssr/csr)
      # Refer to
      # See https://github.com/sveltejs/kit/issues/11747 and
      # https://kit.svelte.dev/docs/configuration
      header ?Content-Security-Policy "
        style-src 'self' 'unsafe-inline';
        font-src 'self';
        img-src 'self' blob: res.cloudinary.com;
        form-action 'self';
        connect-src 'self';
        frame-ancestors 'none';
        object-src 'self';
        base-uri 'self';
      "
    }
    (backend_headers) {
      # The backend is locked down more
      header {
        Content-Security-Policy "
          default-src 'self';
          style-src 'self';
          script-src 'self';
          font-src 'self';
          img-src 'self' res.cloudinary.com;
          form-action 'self';
          connect-src 'self';
          frame-ancestors 'none';
          object-src 'self';
          base-uri 'self';
        "
        # TODO add default-src 'none', at least as a report directive
      }
    }

    https://${hostname}:${revproxyPort} {
      header {
        X-Frame-Options DENY
        Strict-Transport-Security "max-age=15768000; includeSubDomains; preload"
        X-Content-Type-Options nosniff
      }
      handle /admin/* {
        import backend_headers
        reverse_proxy ${hostname}:${backendPort}
      }
      handle /static/django/* {
        import backend_headers
        reverse_proxy ${hostname}:${backendPort}
      }
      handle /ws/* {
        import backend_headers
        reverse_proxy ${hostname}:${backendPort}
      }
      handle_path /api/* {
        import backend_headers
        reverse_proxy ${hostname}:${backendPort}
      }
      handle /* {
        import frontend_headers
        reverse_proxy ${hostname}:${frontendPort}
      }
    }
  '';

  nix.settings = {
    extra-sandbox-paths = [ "/usr/share" "/private/var/db" ];
  };
}
