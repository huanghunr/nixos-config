{ pkgs, ... }: {
    home.packages = [
        (yazi.packages.${pkgs.system}.default.override {
            _7zz = pkgs._7zz-rar;  # Support for RAR extraction
        })
    ];
}