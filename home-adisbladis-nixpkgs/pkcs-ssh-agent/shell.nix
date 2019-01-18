with import <nixpkgs> {};

mkShell {
  buildInputs = [
    vgo2nix
    golint
    gocode
    udev
    go
  ];

  shellHook = ''
    unset GOPATH
  '';
}
