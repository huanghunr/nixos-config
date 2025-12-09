{ config, lib, pkgs, ... }:

let
  # 1. 定义二进制文件的绝对路径
  # 注意：这里必须是绝对路径
  binaryPath = "${config.home.homeDirectory}/Applications/ida92/ida"; 

  # 2. 检测文件是否存在 (返回 bool)
  # 注意：这在构建配置时执行，而不是运行时
  hasBinary = builtins.pathExists binaryPath;

  # 3. 定义 FHS 环境 (基于你提供的代码)
  # 注意：我去掉了末尾的 .env，因为我们需要的是可执行的 wrapper，而不是 shell 环境
  idaFhsEnv = pkgs.buildFHSEnv {
    name = "ida-launch-wrapper";
    
    targetPkgs = pkgs: (with pkgs; [
      zlib
      glib
      libxml2
      dbus
      fontconfig
      freetype
      
      xorg.libX11
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      libxkbcommon
      libglvnd
      
      wayland
      wayland-protocols
      
      qt6.qtbase
      qt6.qtwayland
    ]);

    # 关键修改：将 runScript 设置为我们的二进制文件路径
    # 这样运行这个 FHS wrapper 时，它会配置好环境然后直接执行 IDA
    # 这里的 toString 是为了确保路径被作为字符串处理，而不是被 Nix Store 捕获
    runScript = "${toString binaryPath}";
  };

in
{
  options.programs.local-ida = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = hasBinary;
      description = "Auto-enable local IDA Pro if binary is present";
    };
  };

  config = lib.mkIf config.programs.local-ida.enable {
    # 4. 创建桌面入口
    xdg.desktopEntries.ida = {
      name = "IDA Pro";
      genericName = "Disassembler";
      
      # 5. EXEC 指向 FHS Wrapper
      # "${idaFhsEnv}/bin/ida-launch-wrapper" 是 FHS 环境生成的启动器
      # 后面跟的参数会被透传给 runScript (即透传给 IDA)
      exec = "${idaFhsEnv}/bin/ida-launch-wrapper";
      
      terminal = false;
      # 可以在这里指定图标路径，例如 "${toString /path/to/icon.png}"
      icon = "${config.home.homeDirectory}/Applications/ida92/appico.png"; 
      categories = [ "Development" "Debugger" ];
      mimeType = [ "application/x-executable" "application/octet-stream" ];
    };
  };
}