{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.pam.services.sudo.u2fAuth = true;
  security.pam.services.doas.u2fAuth = true;

  my.common-cli.enable = true;
  my.common-graphical.enable = true;
  my.laptop.enable = true;
  my.podman.enable = true;

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  security.pam.u2f.authFile = pkgs.writeText "u2f_keys" ''
    adisbladis:4tTUtBtgsj9ANcqfkjiK1Lh0dcacIkH_8013_D4rd7kNIg383jhnVS28aqxhxj0b7reCK_zPwCmGOkDRDUb8jg,04db86d74a17ea3031765fc23ecfa9a860a72929887dfc92e965574c38d4d2f23c56ea0c4f31f33edccce9713a37001fdde0d7c8b13d59118f4ebc4d28c4e06a15
  '';

  networking.hostName = "inari";
  networking.hostId = "1dd6870b";

  fileSystems."/".options = [ "noatime" "nodiratime" ];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" ];
  };

  hardware.trackpoint.enable = true;
  services.xserver.synaptics.enable = true;
  # # Make trackpad act as scroll wheel
  # services.xserver.synaptics.additionalOptions = ''
  #   Option "LeftEdge"  "1"
  #   Option "RightEdge"  "2"
  #   Option "VertEdgeScroll"  "1"
  #   Option "AreaTopEdge"  "2500"
  # '';

  # Has 10bit display!
  # services.xserver.defaultDepth = 30;

  # services.xserver.videoDrivers = lib.mkForce [ "intel" ];
  services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
  # services.xserver.deviceSection = ''
  #   Option        "Tearfree"      "true"
  # '';
  # boot.kernelParams = [ "i915.enable_psr=1" ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = false;

  # # Better video acceleration
  # environment.variables = {
  #   MESA_LOADER_DRIVER_OVERRIDE = "iris";
  # };
  # hardware.opengl.package = (pkgs.mesa.override {
  #   galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  # }).drivers;

  nixpkgs.overlays = [
    (self: super: {
      vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
    })
  ];

  hardware.opengl.extraPackages = [
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
    pkgs.libvdpau-va-gl
  ];

  # Hidpi
  console.font = lib.mkForce "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 180;
  environment.variables.GDK_SCALE = "2";
  environment.variables.GDK_DPI_SCALE = "0.5";
  environment.variables._JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";

  system.stateVersion = "20.09";

}
