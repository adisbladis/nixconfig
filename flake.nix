{
  description = "My NixOS configuration(s)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.impermanence.url = "github:nix-community/impermanence";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.talon-nix.url = "github:nix-community/talon-nix";
  inputs.talon-nix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";
  inputs.emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  inputs.emacs-overlay.inputs.nixpkgs-stable.follows = "nixpkgs";

  inputs.crane.url = "github:ipetkov/crane";
  inputs.crane.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-github-actions.url = "github:nix-community/nix-github-actions";
  inputs.nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-fast-build.url = "github:Mic92/nix-fast-build";
  inputs.nix-fast-build.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { self
    , nixpkgs
    , impermanence
    , home-manager
    , talon-nix
    , emacs-overlay
    , crane
    , nix-github-actions
    , nix-fast-build
    }:
    let
      inherit (nixpkgs) lib;
    in
    {
      githubActions = nix-github-actions.lib.mkGithubMatrix { inherit (self) checks; };

      nixosConfigurations =
        let
          modules = [
            impermanence.nixosModule
            home-manager.nixosModule
            talon-nix.nixosModules.talon
            ({ ... }: {
              nixpkgs.overlays = [
                emacs-overlay.overlay
                (final: prev: {
                  craneLib = crane.lib.${final.system};
                  nix-fast-build = nix-fast-build.packages.${final.system}.default;
                })
              ];
            })
          ];

          hosts = (
            lib.filterAttrs
              (host: type: type == "directory" && builtins.pathExists (./hosts + "/${host}/configuration.nix"))
              (builtins.readDir ./hosts)
          );

        in
        lib.mapAttrs
          (host: _: lib.nixosSystem {
            system = "x86_64-linux";
            modules = modules ++ [
              ./hosts/${host}/configuration.nix
            ];
          })
          hosts;

      # # Add all systems as flake checks
      # checks.x86_64-linux = lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) self.nixosConfigurations;

      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          env.NIX_PATH = "nixpkgs=${nixpkgs}";
          packages = [ pkgs.nixos-rebuild ];
        };

    };
}
