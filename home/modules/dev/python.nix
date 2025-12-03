{pkgs, ...}:
{
  home.packages = with pkgs; [
    conda
  ];
}