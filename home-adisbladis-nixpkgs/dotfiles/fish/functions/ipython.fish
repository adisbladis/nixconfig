# Defined in - @ line 1
function ipython
    nix-shell -p '(python3.withPackages (ps: [ ps.ipython ps.requests ps.psutil ]))' --run ipython
end
