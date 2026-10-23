# Nix package for 97d619b3-9e9c-4734-b69a-48a8859ff6bf
{
    description = "Aristotle Project 97d619b3-9e9c-4734-b69a-48a8859ff6bf deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 97d619b3-9e9c-4734-b69a-48a8859ff6bf deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
