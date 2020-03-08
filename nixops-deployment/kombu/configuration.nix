{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];

  my.common-cli.enable = true;
  my.common-graphical.enable = true;
  my.gaming.enable = true;
  my.podman.enable = true;
  my.spell.enable = true;
  my.tmpfs-root.enable = true;

  # Overclock EPYC
  boot.kernelModules = [ "msr" ];
  systemd.services.zenstates = let
    zenstates = let
      src = pkgs.fetchFromGitHub {
        owner = "r4m0n";
        repo = "ZenStates-Linux";
        rev = "0bc27f4740e382f2a2896dc1dabfec1d0ac96818";
        sha256 = "1h1h2n50d2cwcyw3zp4lamfvrdjy1gjghffvl3qrp6arfsfa615y";
      };
    in pkgs.runCommand "zenstates" { buildInputs = [ pkgs.python3 ]; } ''
      mkdir -p $out/bin
      cp ${src}/zenstates.py $out/bin/zenstates
      chmod +x $out/bin/zenstates
      patchShebangs $out/bin/zenstates
    '';
  in {
    description = "Dynamically edit AMD Ryzen/EPYC processor P-States";
    serviceConfig = {
      # Note: Overclocks P0 state to:
      # P0 - Enabled - FID = 40 - DID = 4 - VID = 49 - Ratio = 32.00 - vCore = 1.09375
      ExecStart = "${zenstates}/bin/zenstates -p 0 -f 40 -v 49 -d 4";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # For tmpfs /
  environment.etc."nixos".source = pkgs.runCommand "persistent-link" {} ''
    ln -s /nix/persistent/etc/nixos $out
  '';

  hardware.openrazer.enable = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  services.xserver.deviceSection = ''
    Option        "Tearfree"      "true"
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "b6d4529e";
  networking.hostName = "kombu";

  services.xserver.videoDrivers = lib.mkForce [
    "amdgpu"
    "dummy"  # For xpra
  ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableRedistributableFirmware = true;

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.eno2.useDHCP = false;
  networking.interfaces.wlp37s0.useDHCP = false;

  system.stateVersion = "20.03"; # Did you read the comment?

}
