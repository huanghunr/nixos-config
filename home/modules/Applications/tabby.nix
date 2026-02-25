{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "tabby";
  version = "1.0.230";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
    hash = "sha256-IxBBlgrGd2hwtB7aFzU+tD7vts4sAtXEQ1xXpdj4RNo=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/tabby.desktop \
      $out/share/applications/tabby.desktop

    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/tabby.png \
      $out/share/icons/hicolor/512x512/apps/tabby.png

    substituteInPlace $out/share/applications/tabby.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=tabby'
  '';

  meta = with lib; {
    description = "Tabby - a terminal for a more modern age";
    homepage = "https://github.com/Eugeny/tabby";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "tabby";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
