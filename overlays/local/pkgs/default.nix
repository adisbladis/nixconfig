self: super:
{
  simpleserver = super.callPackage ./simpleserver.nix { };

  adis-applauncher = super.callPackage ./applauncher {};

}
