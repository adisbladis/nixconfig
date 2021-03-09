{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules
  ];

  networking.firewall.allowedTCPPorts = [
    5900  # ReMarkable VNC
  ];

  environment.systemPackages = [
    pkgs.x11vnc  # ReMarkable VNC
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
  ];

  services.tailscale.enable = true;

  services.udev.extraRules = ''
    # Bixolon LCD display
    ACTION=="add", ATTRS{idVendor}=="1504", ATTRS{idProduct}=="0011", RUN+="${pkgs.kmod}/bin/modprobe -q ftdi_sio" RUN+="${pkgs.runtimeShell} -c 'echo 1504 0011 > /sys/bus/usb-serial/drivers/ftdi_sio/new_id'"
  '';

  time.timeZone = lib.mkForce "Africa/Cairo";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.pam.services.sudo.u2fAuth = true;
  security.pam.services.doas.u2fAuth = true;

  hardware.pulseaudio.extraConfig = ''
    load-module module-alsa-sink   device=hw:0,0 channels=4
    load-module module-alsa-source device=hw:0,6 channels=4
  '';

  my.common-cli.enable = true;
  my.common-graphical.enable = true;
  my.laptop.enable = true;
  my.podman.enable = true;

  boot.initrd.availableKernelModules = [
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
  services.xserver.synaptics.additionalOptions = ''
    Option "LeftEdge"  "46"
    Option "RightEdge"  "47"
    Option "VertEdgeScroll"  "1"
  '';

  # Has 10bit display!
  services.xserver.defaultDepth = 30;
  home-manager.users.adisbladis = { ... }: {
    systemd.user.services.picom.Service.Environment = lib.mkForce [ ];
  };

  # # Enable virtual outputs for ReMarkable vnc
  # services.xserver.deviceSection = ''Option "VirtualHeads" "1"'';

  services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
  boot.kernelParams = [ "i915.enable_psrb=1" ];

  # services.xserver.videoDrivers = lib.mkForce [ "intel" ];

  hardware.cpu.intel.updateMicrocode = true;

  # # Better video acceleration
  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };
  # hardware.opengl.package = (pkgs.mesa.override {
  #   galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  # }).drivers;

  programs.captive-browser.interface = "wlp0s20f3";

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = false;

  nixpkgs.overlays = [
    (self: super: {
      vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
    })
  ];

  hardware.opengl.extraPackages = [
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.intel-media-driver
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
