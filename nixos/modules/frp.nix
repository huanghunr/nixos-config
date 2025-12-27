{ config, pkgs, ... }:

{

  sops.secrets.frp_token = {};

  sops.secrets.frp_server_ip = {};

  sops.templates."frp-env" = {
    content = ''
      FRP_TOKEN=${config.sops.placeholder.frp_token}
      FRP_SERVER_IP=${config.sops.placeholder.frp_server_ip}
    '';
  };

  services.frp = {
    enable = true;
    role = "client";
    
    settings = {
      serverAddr = "{{ .Envs.FRP_SERVER_IP }}";
      serverPort = 7000; 

      # 鉴权配置
      auth = {
        method = "token";
        token = "{{ .Envs.FRP_TOKEN }}";
      };

      proxies = [
        {
          name = "nixos-ssh";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 22;
          remotePort = 6000; 
        }
      ];
    };
  };

  systemd.services.frpc.serviceConfig.EnvironmentFile = config.sops.templates."frp-env".path;
}