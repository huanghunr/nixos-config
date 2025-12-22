{pkgs,...}:
{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; 
      PermitRootLogin = "no";
    };
  };
}