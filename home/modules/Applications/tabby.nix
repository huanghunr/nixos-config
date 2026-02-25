{ lib
, fetchurl
, appimageTools
}:

let
  pname = "tabby";
  version = "1.0.230";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
    # 先随便填，后面用 nix 命令算出正确的再替换
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  # wrapType2 的 src 在内部会变成 “解包后的目录（extract 输出）”
  # 所以 extraInstallCommands 里可以直接从 ${src}/... 取文件
extraInstallCommands = ''
  mkdir -p $out/share/applications
  cp ${src}/tabby.desktop $out/share/applications/tabby.desktop

  mkdir -p $out/share/icons/hicolor/512x512/apps
  cp ${src}/usr/share/icons/hicolor/512x512/apps/tabby.png \
    $out/share/icons/hicolor/512x512/apps/tabby.png

  substituteInPlace $out/share/applications/tabby.desktop \
    --replace-fail 'Exec=AppRun' 'Exec=$out/bin/tabby'
'';

  meta = with lib; {
    description = "Tabby - a terminal for a more modern age";
    homepage = "https://github.com/Eugeny/tabby";
    license = licenses.mit; # Tabby 项目是 MIT（应用里还有 Electron/Chromium 组件许可文件）
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}