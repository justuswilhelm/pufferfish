{ pkgs, projectify, config, ... }:
let
  frontend = projectify.outputs.packages.aarch64-darwin.projectify-frontend-node;
  backend = projectify.outputs.packages.aarch64-darwin.projectify-backend;
  revproxy = projectify.outputs.packages.aarch64-darwin.projectify-revproxy;
  logPath = "/var/log/projectify";
  run-projectify-backend = pkgs.writeShellApplication {
    name = "run-projectify-backend";
    runtimeInputs = with pkgs; [ backend ];
    text = ''
      export STRIPE_ENDPOINT_SECRET=""
      export STRIPE_PRICE_OBJECT=""
      export STRIPE_SECRET_KEY=""
      export STRIPE_PUBLISHABLE_KEY=""
      export MAILGUN_DOMAIN=""
      export MAILGUN_API_KEY=""
      SECRET_KEY="$(cat /etc/projectify/secret_key)"
      export SECRET_KEY
      exec projectify-backend
    '';
  };
  run-projectify-frontend-node = pkgs.writeShellApplication {
    name = "run-projectify-frontend-node";
    runtimeInputs = with pkgs; [ frontend ];
    text = ''
      exec projectify-frontend-node
    '';
  };
in
{
  users.groups.projectify = {
    gid = 600;
  };
  users.users.projectify = {
    createHome = false;
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
    port 12003
    bind 127.0.0.1
    dir /var/projectify/redis/
    logfile /var/log/projectify/projectify-redis.log
  '';

  launchd.agents.projectify-redis = {
    command = "${pkgs.redis}/bin/redis-server /etc/projectify/redis.conf";
    serviceConfig = {
      StandardOutPath = "${logPath}/projectify-redis.stdout.log";
      StandardErrorPath = "${logPath}/projectify-redis.stderr.log";
      KeepAlive = true;
      UserName = "projectify";
    };
  };
  launchd.daemons.projectify-frontend-node = {
    serviceConfig =
      {
        KeepAlive = true;
        Program = "${run-projectify-frontend-node}/bin/run-projectify-frontend-node";
        StandardOutPath = "${logPath}/projectify-frontend-node.stdout.log";
        StandardErrorPath = "${logPath}/projectify-frontend-node.stderr.log";
        EnvironmentVariables = {
          SVELTE_KIT_PORT = "12001";
        };
        UserName = "projectify";
      };
  };
  launchd.daemons.projectify-backend = {
    serviceConfig =
      {
        KeepAlive = true;
        Program = "${run-projectify-backend}/bin/run-projectify-backend";
        StandardOutPath = "${logPath}/projectify-backend.stdout.log";
        StandardErrorPath = "${logPath}/projectify-backend.stderr.log";
        EnvironmentVariables = {
          FRONTEND_URL = "http://localhost:12000";
          ALLOWED_HOSTS = "localhost";
          REDIS_URL = "redis://localhost:12003";
          DJANGO_SETTINGS_MODULE = "projectify.settings.production";
          DJANGO_CONFIGURATION = "Production";
          DATABASE_URL = "sqlite:////var/projectify/projectify-backend.sqlite";
          PORT = "12002";
        };
        UserName = "projectify";
      };
  };

  launchd.daemons.projectify-revproxy = {
    serviceConfig =
      {
        KeepAlive = true;
        Program = "${revproxy}/bin/projectify-revproxy";
        StandardOutPath = "${logPath}/projectify-revproxy.stdout.log";
        StandardErrorPath = "${logPath}/projectify-revproxy.stderr.log";
        EnvironmentVariables = {
          HOST = "http://localhost";
          PORT = "12000";
          FRONTEND_HOST = "http://localhost";
          FRONTEND_PORT = "12001";
          BACKEND_HOST = "http://localhost";
          BACKEND_PORT = "12002";
        };
        UserName = "projectify";
      };
  };

}
