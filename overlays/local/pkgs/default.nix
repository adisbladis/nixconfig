self: super:
{
  simpleserver = super.callPackage ./simpleserver.nix { };

  bulkrecode = super.python3Packages.callPackage ./bulkrecode.nix { };
}
