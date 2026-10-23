# Nix package for cf122c5d-1f4e-4552-970c-4b616718c540
{
    description = "Aristotle Project cf122c5d-1f4e-4552-970c-4b616718c540 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project cf122c5d-1f4e-4552-970c-4b616718c540 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
