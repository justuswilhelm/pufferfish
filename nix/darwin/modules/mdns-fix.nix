{ ... }:
{
  launchd.user.agents.mdns-hotfix = {
    command = "dns-sd -R 'lithium' _device-info._tcp local 0";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
