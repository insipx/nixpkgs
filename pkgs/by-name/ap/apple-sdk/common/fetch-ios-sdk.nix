{
  lib,
  stdenvNoCC,
  buildPackages,
}:

{
  sdkPlatform,
  version,
}:

stdenvNoCC.mkDerivation {
  pname = "${sdkPlatform}-SDK";
  inherit version;

  # The xcode package will automatically select the correct version based on stdenv.targetPlatform.xcodeVer
  src = (buildPackages.callPackage ../../../../os-specific/darwin/xcode/default.nix { }).xcode;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    sdkPath="Contents/Developer/Platforms/${sdkPlatform}.platform/Developer/SDKs/${sdkPlatform}.sdk"

    # Extract the iOS SDK from the nested Xcode.app structure to a flat structure
    # matching the format of fetched macOS SDKs
    if [ ! -d "$sdkPath" ]; then
      echo "Error: iOS SDK not found at $sdkPath in Xcode.app"
      echo "Available platforms:"
      ls -la Contents/Developer/Platforms/ || true
      exit 1
    fi

    mkdir -p "$out"
    cp -rd "$sdkPath"/* "$out/"

    # Remove unwanted binaries and man pages to match macOS SDK structure
    rm -rf "$out/usr/bin" "$out/usr/share" 2>/dev/null || true

    runHook postInstall
  '';
}
