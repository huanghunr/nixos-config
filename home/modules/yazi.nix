{ pkgsconfig, pkgs, inputs, ... }: {
    home.packages = [
        (inputs.yazi.packages.${pkgs.system}.default.override {
            _7zz = pkgs._7zz-rar;  # Support for RAR extraction
        })
    ];
}