# Nix package for f8e27a3f-e5fa-4c4d-ae95-cfd403280fa7
{
    description = "Aristotle Project f8e27a3f-e5fa-4c4d-ae95-cfd403280fa7 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project f8e27a3f-e5fa-4c4d-ae95-cfd403280fa7 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
