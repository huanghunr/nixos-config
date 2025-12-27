{ config, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/home/huanghunr/.config/sops/age/keys.txt";
}