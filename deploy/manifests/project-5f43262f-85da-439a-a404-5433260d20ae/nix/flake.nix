# Nix package for 5f43262f-85da-439a-a404-5433260d20ae
{
    description = "Aristotle Project 5f43262f-85da-439a-a404-5433260d20ae deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 5f43262f-85da-439a-a404-5433260d20ae deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
