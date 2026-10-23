# Nix package for 9687656f-b32a-4554-b64a-ff85980c7d0b
{
    description = "Aristotle Project 9687656f-b32a-4554-b64a-ff85980c7d0b deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 9687656f-b32a-4554-b64a-ff85980c7d0b deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
