# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tmpname"; # Define your hostname.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    mpv
    unzip
    kdeconnect
    # firefox
    # chromium
    falkon
    # krita

    htop
  ];

  # User stuffs
  services.avahi.enable = true;

  # Sane font defaults
  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fontconfig.ultimate.enable = true;
  fonts.fontconfig.ultimate.preset = "osx";

  fonts.fonts = with pkgs; [
    liberation_ttf
    inconsolata
    dejavu_fonts
    emacs-all-the-icons-fonts
    powerline-fonts
    source-code-pro
  ];

  environment.variables = {
    # Enable on screen keyboard globally
    QT_IM_MODULE = "qtvirtualkeyboard";
  };

  services.upower.enable = true;

  programs.fish.enable = true;

  hardware.bluetooth.enable = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.xserver.enable = true;
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "dvorak";

  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.sddm.autoLogin.enable = true;
  # services.xserver.displayManager.sddm.autoLogin.user = "adisbladis";

  services.xserver.desktopManager.plasma5.enableQt4Support = false;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  services.unbound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.adisbladis = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-rsa
AAAAB3NzaC1yc2EAAAADAQABAAACAQCTrw8gZoBYkh4Ud8/QCXAaJk020XMbRlcu61QPTnpjvLLxAwSr3d+K7ccDal9FaSQg0GBx58aVRcdVoFBFmHbX6iqR6OT2hoenbxRfVa69DaY6w/eIY5seQ0Xzio8PsX2Cc4IPdM3XqlpTLhQ2+/kNnDC9/NYs2UX6r318uHrHPW5hs6rFPxvekcel56Vy1LKrMb5EgLwOFuhqegKpuZl6Dw39HHAIi0+cVCqc+eP8SmgdcYCm7CjLXU4mV8BwIMx/8TSDravJhnRLYX+S+BFUA3sXTeg1xzUKhFTE3lF4MJTNB613bcygX4HLXcG0YJ/6CDLBVey0xCfyKSbc18nlhRzuePzU8yYL8TRVoMJrEEurq8ZrkxX+lFs83CnFq4epH3vdz+Y6Q8foTVEF0XECgJ08MElXZRFRA5iWvO4S2PQLqn8LKRVxbF6NV34IrchCQavirZCv01FKRYfbpiNSzGLxKn2qvHDiYeqLV8gqj6wgO+DF8w6DsJcEUO3qiUDpbfXMCU8S5HgwVB7oOh+0g0Gq81HmjX0/a2WhuhbwC1Glt+gyLCLd/2RTRIetMymT8kZ61izVVNh0PeAoy4d2DpcKdmaK8CNjZ1/8c9a4Pxzg1HIHlPEyKf9NZ+TlGlUjmTEVOefxAWBVpQuwqEsOF1BkG9tDZsPQdcMhZbtvYQ==
cardno:000605255225"
    ];
  };

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  networking.firewall.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.libinput.enable = true;
  networking.networkmanager.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    firmwareLinuxNonfree
  ];

  system.stateVersion = "18.09"; # Did you read the comment?

}
