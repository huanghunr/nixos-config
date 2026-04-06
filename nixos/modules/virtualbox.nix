{upkgs,...}:{
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.package = upkgs.virtualbox;
  users.extraGroups.vboxusers.members = [ "huanghunr" ];
}