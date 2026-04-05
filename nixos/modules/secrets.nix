{ ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/home/huanghunr/.config/sops/age/keys.txt";
  sops.secrets."9ROUTER_API_KEY" = {
    owner = "huanghunr";
  };
}