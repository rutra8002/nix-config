{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  makeBinaryWrapper,
  alsa-lib,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  krb5,
  libdrm,
  libGL,
  libxcb,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  libxkbcommon,
  libice,
  libsm,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxft,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxxf86vm,
  nspr,
  nss,
  udev,
  zlib,
  gowinEda,
}:

let
  version = gowinEda.version;
  programmerArchive = fetchurl {
    name = "gowin-programmer-${version}.tar.gz";
    url = "https://cdn.gowinsemi.com.cn/programmer${version}Education(2536).Linux.x86.tar.gz";
    hash = "sha256-rkA9a55KbHYZYkbQsSI0u6QhV9xjpOk/usx1S6SlZbg=";
  };

  runtimeLibraries = [
    alsa-lib
    dbus
    expat
    fontconfig
    freetype
    glib
    krb5
    libdrm
    libGL
    libxcb
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxkbcommon
    libice
    libsm
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxft
    libxi
    libxrandr
    libxrender
    libxtst
    libxxf86vm
    nspr
    nss
    udev
    zlib
    stdenv.cc.cc.lib
  ];

  executableWrappers = [
    "gw_ide"
    "gw_sh"
    "gao_sh"
    "gvio_sh"
    "floorplanner"
    "assistant"
    "gao_analyzer"
    "gvio_analyzer"
    "GowinModGen"
    "GowinSynthesis"
    "gw_pkgviewer"
    "gw_sdceditor"
    "gw_goeye"
  ];

  libraryPath = lib.makeLibraryPath runtimeLibraries;
in
assert version == "1.9.11.03";
stdenv.mkDerivation {
  pname = "gowin-eda-education";
  inherit version;

  src = programmerArchive;
  sourceRoot = "Programmer";

  nativeBuildInputs = [
    makeBinaryWrapper
    patchelf
  ];

  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/IDE" "$out/Programmer" "$out/bin" "$out/share" "$out/lib/udev/rules.d"
    cp -a ${gowinEda.unwrapped}/. "$out/IDE/"
    cp -a . "$out/Programmer/"
    cp -a ${gowinEda}/share/. "$out/share/"

    cat > "$out/lib/udev/gowin-unbind-ftdi" <<'EOF'
    #!/bin/sh
    set -eu
    printf '%s' "$1" > /sys/bus/usb/drivers/ftdi_sio/unbind
    EOF
    chmod 0555 "$out/lib/udev/gowin-unbind-ftdi"

    cat > "$out/lib/udev/rules.d/70-gowin-programmer.rules" <<EOF
    SUBSYSTEM=="usb", ATTR{idVendor}=="33aa", ATTR{idProduct}=="0120", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_interface", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", DRIVER=="ftdi_sio", RUN+="$out/lib/udev/gowin-unbind-ftdi %k"
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_interface", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", DRIVER=="ftdi_sio", RUN+="$out/lib/udev/gowin-unbind-ftdi %k"
    EOF

    # Use NixOS's graphics and system libraries instead of Gowin's old copies.
    rm -f \
      "$out/Programmer/bin/libstdc++.so.6" \
      "$out/Programmer/bin/libGL.so.1" \
      "$out/Programmer/bin/libglapi.so.0" \
      "$out/Programmer/bin/libfreetype.so.6" \
      "$out/Programmer/bin/libfontconfig.so.1" \
      "$out/Programmer/bin/libexpat.so.1" \
      "$out/Programmer/bin/libX11.so.6" \
      "$out/Programmer/bin/libX11-xcb.so.1" \
      "$out/Programmer/bin/libXau.so.6" \
      "$out/Programmer/bin/libXdamage.so.1" \
      "$out/Programmer/bin/libXext.so.6" \
      "$out/Programmer/bin/libXfixes.so.3" \
      "$out/Programmer/bin/libXft.so.2" \
      "$out/Programmer/bin/libXi.so.6" \
      "$out/Programmer/bin/libXrender.so.1" \
      "$out/Programmer/bin/libXxf86vm.so.1" \
      "$out/Programmer/bin/libxcb-dri2.so.0" \
      "$out/Programmer/bin/libxcb-glx.so.0" \
      "$out/Programmer/bin/libxcb.so.1" \
      "$out/Programmer/bin/libz.so.1"

    find "$out/Programmer" -type f -print0 | while IFS= read -r -d "" file; do
      if patchelf --print-interpreter "$file" >/dev/null 2>&1; then
        patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" "$file"
      fi
    done

    for executable in ${lib.escapeShellArgs executableWrappers}; do
      if [ -x "$out/IDE/bin/$executable" ]; then
        makeBinaryWrapper "$out/IDE/bin/$executable" "$out/bin/$executable" \
          --prefix LD_LIBRARY_PATH : "$out/IDE/lib:$out/Programmer/bin:${libraryPath}" \
          --set-default QT_QPA_PLATFORM xcb
      fi
    done

    if [ ! -x "$out/Programmer/bin/programmer" ]; then
      echo "Gowin Programmer archive does not contain Programmer/bin/programmer" >&2
      exit 1
    fi
    makeBinaryWrapper "$out/Programmer/bin/programmer" "$out/bin/programmer" \
      --prefix LD_LIBRARY_PATH : "$out/IDE/lib:$out/Programmer/bin:${libraryPath}" \
      --set-default QT_QPA_PLATFORM xcb

    runHook postInstall
  '';

  meta = gowinEda.meta // {
    description = "Gowin EDA Education IDE and Programmer for Linux";
    mainProgram = "gw_ide";
  };
}
