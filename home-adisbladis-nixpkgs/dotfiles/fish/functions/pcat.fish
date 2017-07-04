# Defined in - @ line 2
function pcat
	nix-shell -p python36Packages.pygments --run "pygmentize $argv"
end
