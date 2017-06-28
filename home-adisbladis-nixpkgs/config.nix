{
  allowUnfree = true;
  packageOverrides = pkgs_: with pkgs_; {
    home-manager = import ./home-manager { inherit pkgs; };
  };
}
