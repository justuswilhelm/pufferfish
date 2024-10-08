{ pkgs, projectify, specialArgs, ... }:
let
  frontend = projectify.outputs.packages.${specialArgs.system}.projectify-frontend-node;
  backend = projectify.outputs.packages.${specialArgs.system}.projectify-backend;
  revproxy = projectify.outputs.packages.${specialArgs.system}.projectify-revproxy;
  logPath = "/var/log/projectify";
  revproxyPort = "18100";
  frontendPort = "18101";
  backendPort = "18102";
  redisPort = "18103";
  hostname = "localhost";
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
        StandardOutPath = "${logPath}/projectify-backend.stdout.log";
        StandardErrorPath = "${logPath}/projectify-backend.stderr.log";
        EnvironmentVariables = {
          FRONTEND_URL = "http://${hostname}:${revproxyPort}";
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

  launchd.daemons.projectify-revproxy = {
    command = "${revproxy}/bin/projectify-revproxy";
    serviceConfig =
      {
        KeepAlive = true;
        StandardOutPath = "${logPath}/projectify-revproxy.stdout.log";
        StandardErrorPath = "${logPath}/projectify-revproxy.stderr.log";
        EnvironmentVariables = {
          HOST = "http://${hostname}";
          PORT = revproxyPort;
          FRONTEND_HOST = "http://${hostname}";
          FRONTEND_PORT = frontendPort;
          BACKEND_HOST = "http://${hostname}";
          BACKEND_PORT = backendPort;
        };
        UserName = "projectify";
      };
  };

}
