# Nix package for cef55bd5-3292-4a54-adef-8968dff05a4e
{
    description = "Aristotle Project cef55bd5-3292-4a54-adef-8968dff05a4e deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project cef55bd5-3292-4a54-adef-8968dff05a4e deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
