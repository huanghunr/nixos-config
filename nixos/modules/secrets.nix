{ config, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/home/huanghunr/.config/sops/age/key.txt";

  sops.secrets.frp_token = {
    owner = config.users.users.huanghunr.name;
  };
}