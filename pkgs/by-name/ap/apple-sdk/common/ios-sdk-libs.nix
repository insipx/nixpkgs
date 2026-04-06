{
  lib,
  config,
  sdkPlatform,
}:

self: super: {
  buildPhase = super.preBuild or "" + ''
    echo "Copying iOS SDK files to source directory: $(pwd)"
    sdkPath="Contents/Developer/Platforms/${sdkPlatform}.platform/Developer/SDKs/${sdkPlatform}.sdk"

    # Copy SDK contents to current directory, excluding Contents
    cp -r "$sdkPath"/* .

    # Remove Contents directory to avoid copying Xcode.app structure
    rm -rf Contents
  '';
}
