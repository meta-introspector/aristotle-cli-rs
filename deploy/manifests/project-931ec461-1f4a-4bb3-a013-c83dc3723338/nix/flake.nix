# Nix package for 931ec461-1f4a-4bb3-a013-c83dc3723338
{
    description = "Aristotle Project 931ec461-1f4a-4bb3-a013-c83dc3723338 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 931ec461-1f4a-4bb3-a013-c83dc3723338 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
