{ pkgs, inputs, ... }:
{
  home.packages =
    with pkgs;
    [
      (ghidra.withExtensions (
        p: with p; [
          ret-sync
          ghidra-extensions.wasm
          ghidra-extensions.kaiju
          ghidra-extensions.findcrypt
          ghidra-extensions.ghidra-firmware-utils
          ghidra-extensions.ghidra-golanganalyzerextension
        ]
      ))
    ]
    ++ [
      binwalk
      upx
      cyberchef
      imhex
      socat
    ]
    ++ [
      inputs.pwndbg.packages.${pkgs.system}.default
    ]
    ++ [
      one_gadget
    ]
    ++ [
      jadx
    ]
    ++ [
      # Recon / scanning
      nmap
      rustscan
      naabu
      ffuf
      feroxbuster
      gobuster
      nuclei
      nuclei-templates
      sqlmap
      tcpdump
      tshark
      termshark
      mitmproxy
      proxychains
      tor
      torsocks
    ]
    ++ [
      # DevSecOps / detection
      semgrep
      gitleaks
      trivy
      syft
      grype
      yara
      sslscan
      testssl
      ssh-audit
    ]
    ++ [
      # Reverse engineering
      radare2
      apktool
    ]
    ++ [
      # Forensics
      volatility3
      exiftool
      foremost
    ]
    ++ [
      # Password auditing
      hashcat
      john
      medusa
    ]
    ++ [
      # Web security proxy/scanner (headless-capable)
      zap
    ];
}
