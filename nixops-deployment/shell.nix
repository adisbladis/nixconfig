with (import <nixpkgs> {});

mkShell {
  buildInputs = [ nixopsUnstable ];
}
