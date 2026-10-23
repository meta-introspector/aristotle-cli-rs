# Nix package for d58917bf-a104-4ede-a696-91c93e268616
{
    description = "Aristotle Project d58917bf-a104-4ede-a696-91c93e268616 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project d58917bf-a104-4ede-a696-91c93e268616 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
