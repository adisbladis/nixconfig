self: super:

with super.lib;
{
  simpleserver = super.callPackage ./simpleserver.nix { };
}
