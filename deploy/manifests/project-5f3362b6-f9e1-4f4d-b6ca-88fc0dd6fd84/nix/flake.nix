# Nix package for 5f3362b6-f9e1-4f4d-b6ca-88fc0dd6fd84
{
    description = "Aristotle Project 5f3362b6-f9e1-4f4d-b6ca-88fc0dd6fd84 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 5f3362b6-f9e1-4f4d-b6ca-88fc0dd6fd84 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
