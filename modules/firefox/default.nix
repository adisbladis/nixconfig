{ config, lib, pkgs, ... }:

let
  cfg = config.my.firefox;

  inherit (pkgs) stdenv fetchurl;
  buildFirefoxXpiAddon = { pname, version, addonId, url, sha256, meta ? { }, ... }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };

in
{
  options.my.firefox.enable = lib.mkEnableOption "Enable Firefox";

  config = lib.mkIf cfg.enable {

    home-manager.users.adisbladis = { ... }: {

      programs.firefox = {

        enable = true;

        profiles = {
          default = {
            isDefault = true;

            extensions = map buildFirefoxXpiAddon (lib.attrValues (lib.importJSON ./extensions.json));

            settings = {
              # Extensions are managed with Nix, don't auto update anything
              "extensions.update.autoUpdateDefault" = false;
              "extensions.update.enabled" = false;

              # Sync
              "services.sync.username" = "adisbladis@gmail.com";

              # Middle click to scroll
              "general.autoScroll" = true;

              # Show blank page on new window
              "browser.startup.page" = 0;
              "browser.startup.homepage" = "about:blank";

              # Privacy enhancements
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "browser.newtabpage.activity-stream.feeds.snippets" = false;
              "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

              # Improve performance
              "gfx.webrender.all" = true;

              # Enable browser debugging
              "devtools.chrome.enabled" = true;

              # Disable tabs
              "browser.tabs.opentabfor.middleclick" = false;

              # Enable userChrome customisations

              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

              # DNT
              "privacy.donottrackheader.enabled" = true;
              "privacy.donottrackheader.value" = 1;
            };

            # extraConfig = ''
            #   console.log(browser.storage.local);
            # '';

            userChrome = ''
              /* Completely hide tabs */
              #TabsToolbar { visibility: collapse; }

              /* hide navigation bar when it is not focused; use Ctrl+L to get focus */
              #main-window:not([customizing]) #navigator-toolbox:not(:focus-within):not(:hover) {
                margin-top: -45px;
              }

              #navigator-toolbox {
                transition: 0.2s margin-top ease-out;
              }

              #titlebar {
                display: none;
                }

              #sidebar-header {
                display: none;
              }
            '';

          };

        };
      };

    };

    programs.browserpass.enable = true;

  };
}
