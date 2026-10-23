# Nix package for 4b7ae00b-c845-4c67-aedd-8d58dabb1ce1
{
    description = "Aristotle Project 4b7ae00b-c845-4c67-aedd-8d58dabb1ce1 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 4b7ae00b-c845-4c67-aedd-8d58dabb1ce1 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
