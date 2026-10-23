# Nix package for cc3360d4-4af1-48d5-ade5-557d8c5b0fcb
{
    description = "Aristotle Project cc3360d4-4af1-48d5-ade5-557d8c5b0fcb deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project cc3360d4-4af1-48d5-ade5-557d8c5b0fcb deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
