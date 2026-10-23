# Nix package for 3c84bcb7-cfdb-48c7-8a3a-8f95c2a840b8
{
    description = "Aristotle Project 3c84bcb7-cfdb-48c7-8a3a-8f95c2a840b8 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 3c84bcb7-cfdb-48c7-8a3a-8f95c2a840b8 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
