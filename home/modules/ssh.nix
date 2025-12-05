{...}:
{
  programs.ssh.enableDefaultConfig= {
    enable = true;
    addKeysToAgent = "yes";
  };
}