# Nix package for 1bd43cc1-0556-46fc-8761-5aedcfcecac1
{
    description = "Aristotle Project 1bd43cc1-0556-46fc-8761-5aedcfcecac1 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 1bd43cc1-0556-46fc-8761-5aedcfcecac1 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
